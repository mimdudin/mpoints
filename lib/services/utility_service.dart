import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import '../models/utility.dart';
import '../utils/constant.dart';

mixin UtilityService on Model {
  Utility _utility = Utility();
  Utility get utility => _utility;

  bool _isLoadingUtility = false;
  bool get isLoadingUtility => _isLoadingUtility;

  Future<Utility> fetchUtility() async {
    _isLoadingUtility = true;
    notifyListeners();

    var response = await http
        .get(Constant.baseUrl + Constant.utilityParam + Constant.jsonExt);

    if (response.statusCode == 200) {
      Map responseData = json.decode(response.body);
      print(responseData);

      _utility = Utility(
          email: responseData['email'],
          website: responseData['website'],
          facebook: responseData['facebook'],
          termOfUse: responseData['termOfUse']);

      _isLoadingUtility = false;
      notifyListeners();

      return _utility;
    } else {
      _isLoadingUtility = false;
      notifyListeners();
      throw Exception('failed to load data');
    }
  }

  void clearAds() {
    _utility = null;
    notifyListeners();
  }
}
