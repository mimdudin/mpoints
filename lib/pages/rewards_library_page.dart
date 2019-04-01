import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../services/main_model.dart';
import '../screens/rewards_list_item.dart';

class RewardsLibraryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (context, child, model) {
        return Scaffold(
            appBar: AppBar(
              title: Text("Rewards Library"),
              actions: <Widget>[
                IconButton(
                  icon: Icon(Icons.search),
                  onPressed: (){},
                ),
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
                        return RewardsListItem(reward);
                      }),
            ));
      },
    );
  }
}
