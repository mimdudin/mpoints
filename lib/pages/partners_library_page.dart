import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../utils/circular_loading.dart';
import '../services/main_model.dart';
import '../utils/strings.dart';
import '../screens/partner_list_item.dart';
import '../pages/partners_library/newest_partner_listview.dart';
import '../pages/partners_library/popular_partner_listview.dart';
import '../models/partners.dart';
import '../home_screens/partner_listview.dart';
import '../utils/pallete.dart';
import '../utils/partners_loading.dart';

class PartnersLibraryPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (context, child, model) {
        return Scaffold(
          appBar: AppBar(
            title: Text("Partners Library"),
            actions: <Widget>[
              Builder(
                  builder: (context) => IconButton(
                        icon: Icon(Icons.search),
                        onPressed: () async {
                          // final Rewards rewards = await
                          showSearch(
                              context: context,
                              delegate: DataSearchPartners(model));

                          // Scaffold.of(context).showSnackBar(
                          //     SnackBar(content: Text(rewards.name)));
                        },
                      )),
            ],
          ),
          body: ListView(
            children: <Widget>[
              SizedBox(height: 10),
              _buildLabel(Strings.newestPartner, context),
              SizedBox(height: 8),
              Container(
                  height: 160,
                  child: model.isLoadingPartnerList
                      ? PartnersLoading()
                      : NewestPartnerListView()),
              SizedBox(height: 20),
              _buildLabel(Strings.mostPopular, context),
              SizedBox(height: 8),
              Container(
                  // height: 155,
                  child: model.isLoadingPartnerList
                      ? PartnersLoading()
                      : PopularPartnerListView()),
              SizedBox(height: 10),
              // Container(
              //     height: 155,
              //     child: model.isLoadingPartnerList
              //         ? PartnersLoading()
              //         : PartnerListView()),
            ],
          ),
        );
      },
    );
  }

  Widget _buildLabel(String label, BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 20),
      child: Text(
        label,
        style: Theme.of(context).textTheme.title.copyWith(
            fontSize: 14, color: Pallete.primary, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class DataSearchPartners extends SearchDelegate<Partners> {
  final MainModel model;

  DataSearchPartners(this.model);

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
    final _partnerList = model.partnerList
        .where((partner) =>
            partner.name.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return Container(
        child: query == ''
            ? buildSuggestions(context)
            : _partnerList.length == 0
                ? Center(
                    child: Text("No partners library found."),
                  )
                : GridView.builder(
                    shrinkWrap: true,
                    itemCount: _partnerList == null ? 0 : _partnerList.length,
                    physics: ClampingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    padding: EdgeInsets.symmetric(horizontal: 8),
                    // itemExtent: 10.0,
                    // reverse: true, //makes the list appear in descending order
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: 0.8, crossAxisCount: 3),
                    itemBuilder: (context, i) {
                      var partner = _partnerList[i];
                      return PartnerListItem(partner);
                    }));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionsPartner = query.isEmpty
        ? model.partnerList
        : model.partnerList
            .where((partner) =>
                partner.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
    return ListView.builder(
      itemBuilder: (context, i) => ListTile(
            leading: Icon(FontAwesomeIcons.store),
            title: Text(suggestionsPartner[i].name,
                style:
                    Theme.of(context).textTheme.caption.copyWith(fontSize: 16)),

            // RichText(
            //   text: TextSpan(
            //       text: suggestionsPartner[i].name.substring(0, query.length),
            //       style: Theme.of(context).textTheme.subhead.copyWith(
            //           color: Pallete.primary, fontWeight: FontWeight.bold),
            //       children: [
            //         TextSpan(
            //           text: suggestionsPartner[i].name.substring(query.length),
            //           style: Theme.of(context)
            //               .textTheme
            //               .subhead
            //               .copyWith(color: Colors.grey),
            //         )
            //       ]),
            // ),
            onTap: () {
              query = suggestionsPartner[i].name;
            },
          ),
      itemCount: suggestionsPartner.length,
    );
  }
}
