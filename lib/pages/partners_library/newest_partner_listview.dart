import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../services/main_model.dart';
import '../../models/partners.dart';
import '../../screens/partner_list_item.dart';

class NewestPartnerListView extends StatelessWidget {
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (context, child, model) {
        var _newestPartnerList = model.partnerList
            .where((partner) => partner.isNewest == true)
            .toList();
        return !model.isLoadingPartnerList && _newestPartnerList.length == 0
            ? Center(child: Text("No partner list."))
            : NotificationListener<OverscrollIndicatorNotification>(
                onNotification: (overscroll) {
                  overscroll.disallowGlow();
                },
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: ClampingScrollPhysics(),
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                  scrollDirection: Axis.horizontal,
                  itemCount: _newestPartnerList == null
                      ? 0
                      : _newestPartnerList.length,
                  itemBuilder: (context, i) {
                    var partner = _newestPartnerList[i];
                    return PartnerListItem(partner);
                  },
                ),
              );
      },
    );
  }
}
