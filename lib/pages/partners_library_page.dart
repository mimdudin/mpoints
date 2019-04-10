import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../utils/circular_loading.dart';
import '../services/main_model.dart';
import '../utils/strings.dart';
import '../screens/partner_list_item.dart';
import '../pages/partners_library/newest_partner_listview.dart';
import '../pages/partners_library/popular_partner_listview.dart';

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
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {},
              ),
            ],
          ),
          body: ListView(
            children: <Widget>[
              SizedBox(height: 10),
              _buildLabel(Strings.newestPartner, context),
              SizedBox(height: 8),
              Container(
                  height: 155,
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
