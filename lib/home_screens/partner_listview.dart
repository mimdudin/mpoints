import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../services/main_model.dart';
import '../models/partners.dart';
import '../screens/partner_list_item.dart';

class PartnerListView extends StatefulWidget {
  @override
  _PartnerListViewState createState() => _PartnerListViewState();
}

class _PartnerListViewState extends State<PartnerListView> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (context, child, model) {
        return !model.isLoadingPartnerList && model.getPartnerListCount() == 0
            ? Center(child: Text("No partner list."))
            : ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                scrollDirection: Axis.horizontal,
                itemCount:
                    model.partnerList == null ? 0 : model.getPartnerListCount(),
                itemBuilder: (context, i) {
                  var partner = model.partnerList[i];
                  return PartnerListItem(partner);
                },
              );
      },
    );
  }
}
