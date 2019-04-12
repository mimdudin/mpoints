import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import '../models/rewards.dart';
import '../utils/constant.dart';

mixin RewardListService on Model {
  int _selRewardIndex;

  List<Rewards> _rewardList = [];
  List<Rewards> get rewardList => _rewardList;

  bool _isLoadingrewardList = false;
  bool get isLoadingrewardList => _isLoadingrewardList;

  int getRewardListCount() {
    return _rewardList.length;
  }

  Future<Rewards> fetchRewardList() async {
    var _reward;

    _isLoadingrewardList = true;
    notifyListeners();

    var response = await http
        .get(Constant.baseUrl + Constant.rewardsParam + Constant.jsonExt);

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      print(responseData);

      final List<Rewards> fetchedRewardList = [];
      responseData.forEach((String rewardId, dynamic json) {
        _reward = Rewards.fromJson(rewardId, json);

        fetchedRewardList.add(_reward);
      });

      _rewardList = fetchedRewardList;
      _isLoadingrewardList = false;
      notifyListeners();

      return _reward;
    } else {
      _isLoadingrewardList = false;
      notifyListeners();
      throw Exception('failed to load data');
    }
  }

  Rewards get getSelectedReward {
    if (_selRewardIndex == null) {
      return null;
    }
    return _rewardList[_selRewardIndex];
  }

  void selectedRewad(int index) {
    _selRewardIndex = index;
    notifyListeners();
  }

  void clearRewardList() {
    _rewardList.clear();
    notifyListeners();
  }
}
