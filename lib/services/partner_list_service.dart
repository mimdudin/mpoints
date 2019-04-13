import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import '../models/partners.dart';
import '../utils/constant.dart';

mixin PartnerListService on Model {
  List<Partners> _partnerList = [];
  List<Partners> get partnerList => _partnerList;

  bool _isLoadingPartnerList = false;
  bool get isLoadingPartnerList => _isLoadingPartnerList;

  int getPartnerListCount() {
    return _partnerList.length;
  }

  Future<Partners> fetchPartnerList() async {
    var _partner;

    _isLoadingPartnerList = true;
    notifyListeners();

    var response = await http
        .get(Constant.baseUrl + Constant.partnerListParam + Constant.jsonExt);

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      print(responseData);

      final List<Partners> fetchedPartnerList = [];
      responseData.forEach((String partnerId, dynamic json) {
        _partner = Partners(
          id: partnerId,
          name: json['name'],
          category: json['category'],
          logo: json['logo'],
          email: json['email'],
          facebook: json['facebook'],
          phoneNumber: json['phone_number'],
          partnerNumber: json['partner_number'],
          website: json['website'],
          isNewest: json['isNewest'],
          isPopular: json['isPopular'],
        );

        fetchedPartnerList.add(_partner);
      });

      _partnerList = fetchedPartnerList;
      _isLoadingPartnerList = false;
      notifyListeners();

      return _partner;
    } else {
      _isLoadingPartnerList = false;
      notifyListeners();
      throw Exception('failed to load data');
    }
  }

  void clearPartnerList() {
    _partnerList.clear();
    notifyListeners();
  }
}
