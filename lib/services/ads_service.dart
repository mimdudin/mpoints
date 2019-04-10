import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import '../models/ads.dart';
import '../utils/constant.dart';

mixin AdsService on Model {
  Ads _ads = Ads();
  Ads get ads => _ads;

  bool _isLoadingAds = false;
  bool get isLoadingAds => _isLoadingAds;

  Future<Ads> fetchAds() async {
    _isLoadingAds = true;
    notifyListeners();

    var response =
        await http.get(Constant.baseUrl + Constant.adsParam + Constant.jsonExt);

    if (response.statusCode == 200) {
      Map responseData = json.decode(response.body);
      print(responseData);

      _ads = Ads(banner: responseData['banner'], url: responseData['url']);

      _isLoadingAds = false;
      notifyListeners();

      return _ads;
    } else {
      _isLoadingAds = false;
      notifyListeners();
      throw Exception('failed to load data');
    }
  }
}
