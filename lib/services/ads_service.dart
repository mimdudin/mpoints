import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import '../models/ads.dart';
import '../utils/constant.dart';

mixin AdsService on Model {
  List<Ads> _adsList = [];
  List<Ads> get adsList => _adsList;

  bool _isLoadingAds = false;
  bool get isLoadingAds => _isLoadingAds;

  int getAdsListCount() {
    return _adsList.length;
  }

  Future<Ads> fetchAdsList() async {
    var _ads;

    _isLoadingAds = true;
    notifyListeners();

    var response =
        await http.get(Constant.baseUrl + Constant.adsParam + Constant.jsonExt);

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      print(responseData);

      final List<Ads> fetchedAdsList = [];
      responseData.forEach((String adsId, dynamic json) {
        _ads = Ads.fromJson(adsId, json);

        fetchedAdsList.add(_ads);
      });

      _adsList = fetchedAdsList;

      _isLoadingAds = false;
      notifyListeners();

      return _ads;
    } else {
      _isLoadingAds = false;
      notifyListeners();
      throw Exception('failed to load data');
    }
  }

  void clearAdsist() {
    _adsList.clear();
    notifyListeners();
  }
}
