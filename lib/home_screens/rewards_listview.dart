import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../services/main_model.dart';
import '../screens/rewards_list_item.dart';

class RewardsListView extends StatefulWidget {
  @override
  _RewardsListViewState createState() => _RewardsListViewState();
}

class _RewardsListViewState extends State<RewardsListView> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (context, child, model) {
        return !model.isLoadingrewardList && model.getRewardListCount() == 0
            ? Center(child: Text("No reward list."))
            : ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 2), //vert;2
                scrollDirection: Axis.horizontal,
                itemCount:
                    model.rewardList == null ? 0 : model.getRewardListCount(),
                itemBuilder: (context, i) {
                  var reward = model.rewardList[i];
                  return RewardsListItem(reward);
                },
              );
      },
    );
  }
}
