import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../services/main_model.dart';
import '../../models/partners.dart';
import '../../screens/partner_list_item.dart';

class PopularPartnerListView extends StatelessWidget {
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (context, child, model) {
        var _popularPartnerList =
            model.partnerList.where((partner) => partner.isPopular == true).toList();
        return !model.isLoadingPartnerList && _popularPartnerList.length == 0
            ? Center(child: Text("No partner list."))
            : GridView.builder(
              shrinkWrap: true,
                itemCount: _popularPartnerList == null
                    ? 0
                    : _popularPartnerList.length,
                physics: ClampingScrollPhysics(),
                scrollDirection: Axis.vertical,
                padding: EdgeInsets.symmetric(horizontal: 8),
                // itemExtent: 10.0,
                // reverse: true, //makes the list appear in descending order
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    childAspectRatio: 0.8,
                    crossAxisCount: 3),
                itemBuilder: (context, i) {
                  var partner = _popularPartnerList[i];
                  return PartnerListItem(partner);
                });
      },
    );
  }
}

//   Container(
//               child: model.getRewardListCount() == 0
//                   ? Center(
//                       child: Text("No rewards library found."),
//                     )
//                   : GridView.builder(
//                       itemCount: model.rewardList == null
//                           ? 0
//                           : model.getRewardListCount(),
//                       // shrinkWrap: true,
//                       physics: ClampingScrollPhysics(),
//                       scrollDirection: Axis.vertical,
//                       padding: EdgeInsets.symmetric(horizontal: 3),
//                       // itemExtent: 10.0,
//                       // reverse: true, //makes the list appear in descending order
//                       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                           crossAxisCount: 2),
//                       itemBuilder: (context, i) {
//                         var reward = model.rewardList[i];
//                         return RewardsListItem(reward, i);
//                       }),
//             )
// }
