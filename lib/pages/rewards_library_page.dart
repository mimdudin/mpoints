import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scoped_model/scoped_model.dart';

import '../services/main_model.dart';
import '../screens/rewards_list_item.dart';
import '../models/rewards.dart';
import '../utils/pallete.dart';

class RewardsLibraryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (context, child, model) {
        return Scaffold(
            appBar: AppBar(
              title: Text("Rewards Library"),
              actions: <Widget>[
                Builder(
                    builder: (context) => IconButton(
                          icon: Icon(Icons.search),
                          onPressed: () async {
                            // final Rewards rewards = await
                            showSearch(
                                context: context,
                                delegate: DataSearchRewards(model));

                            // Scaffold.of(context).showSnackBar(
                            //     SnackBar(content: Text(rewards.name)));
                          },
                        )),
              ],
            ),
            body: Container(
              child: model.getRewardListCount() == 0
                  ? Center(
                      child: Text("No rewards library found."),
                    )
                  : GridView.builder(
                      itemCount: model.rewardList == null
                          ? 0
                          : model.getRewardListCount(),
                      // shrinkWrap: true,
                      physics: ClampingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      padding: EdgeInsets.symmetric(horizontal: 3),
                      // itemExtent: 10.0,
                      // reverse: true, //makes the list appear in descending order
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2),
                      itemBuilder: (context, i) {
                        var reward = model.rewardList[i];
                        return RewardsListItem(reward, i);
                      }),
            ));
      },
    );
  }
}

class DataSearchRewards extends SearchDelegate<Rewards> {
  final MainModel model;

  DataSearchRewards(this.model);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
        query = "";
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    final _rewardList = model.rewardList
        .where(
            (reward) => reward.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return Container(
      child: query == ''
          ? buildSuggestions(context)
          : _rewardList.length == 0
              ? Center(
                  child: Text("No rewards library found."),
                )
              : GridView.builder(
                  itemCount: _rewardList == null ? 0 : _rewardList.length,
                  // shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  padding: EdgeInsets.symmetric(horizontal: 3),
                  // itemExtent: 10.0,
                  // reverse: true, //makes the list appear in descending order
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  itemBuilder: (context, i) {
                    var reward = _rewardList[i];
                    return RewardsListItem(reward, i);
                  }),
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionsRewards = query.isEmpty
        ? model.rewardList
        : model.rewardList
            .where((reward) =>
                reward.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
    return ListView.builder(
      itemBuilder: (context, i) => ListTile(
            leading: Icon(Icons.loyalty),
            title: Text(suggestionsRewards[i].name,
                style:
                    Theme.of(context).textTheme.caption.copyWith(fontSize: 16)),

            // RichText(
            //   text: TextSpan(
            //       text: suggestionsRewards[i].name.substring(0, query.length),
            //       style: Theme.of(context).textTheme.subhead.copyWith(
            //           color: Pallete.primary, fontWeight: FontWeight.bold),
            //       children: [
            //         TextSpan(
            //           text: suggestionsRewards[i].name.substring(query.length),
            //           style: Theme.of(context)
            //               .textTheme
            //               .subhead
            //               .copyWith(color: Colors.grey),
            //         )
            //       ]),
            // ),
            onTap: () {
              query = suggestionsRewards[i].name;
            },
          ),
      itemCount: suggestionsRewards.length,
    );
  }
}
