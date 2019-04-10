import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import './reward_list_service.dart';

import '../models/user.dart';
import '../utils/constant.dart';
import '../models/statement.dart';

mixin UserService on Model, RewardListService {
  User _user = new User();
  User get user => _user;

  List<Statement> _statementList = [];
  List<Statement> get statementList => _statementList;

  bool _isLoadingUser = false;
  bool get isLoadingUser => _isLoadingUser;

  int getStatementsCount() {
    return _statementList.length;
  }

  Future<User> fetchUserById(String userId) async {
    _isLoadingUser = true;
    notifyListeners();

    final response = await http.get(
        Constant.baseUrl + Constant.userParam + '/$userId' + Constant.jsonExt);

    if (response.statusCode == 200) {
      var result = json.decode(response.body);
      print(result);

      // if (result['addresses'] != null) {
      //   result['addresses'].forEach((String addressId, dynamic jsonAddress) {
      //     print("ADDRESS: $jsonAddress");
      //     var address = Address.fromJson(addressId, jsonAddress);
      //     addressToList(address);
      //   });
      // }
      final List<Statement> fetchedStatementList = [];

      if (result['statements'] != null) {
        result['statements']
            .forEach((String statementId, dynamic jsonStatement) {
          print("STATEMENT: $jsonStatement");
          var statement = Statement.fromJson(statementId, jsonStatement);
          fetchedStatementList.add(statement);
        });

        _statementList = fetchedStatementList;
      }

      _user = User(
          uid: userId,
          firstName: result['firstName'],
          lastName: result['lastName'],
          email: result['email'],
          phoneNumber: result['phoneNumber'],
          photo: result['photo'],
          referredBy: result['referredBy'],
          myReferral: result['referrals'],
          mpoints: result['mpoints'],
          mpointsUsed: result['mpointsUsed'],
          mpointsReceived: result['mpointsReceived'],
          statementList: _statementList);

      //  User.fromJson(result);

      _isLoadingUser = false;
      notifyListeners();
      return _user;
    } else {
      _isLoadingUser = false;
      notifyListeners();
      throw Exception('failed to load user');
    }
  }

  Future<void> updateMPoints(int mpoints) async {
    _isLoadingUser = true;
    notifyListeners();

    final response = await http.put(
        Constant.baseUrl +
            Constant.userParam +
            '/${_user.uid}/mpoints' +
            Constant.jsonExt,
        body: json.encode(mpoints));
    print(json.decode(response.body));

    final User updateUser = User(
        uid: _user?.uid,
        firstName: _user?.firstName,
        lastName: _user?.lastName,
        email: _user?.email,
        phoneNumber: _user?.phoneNumber,
        photo: _user?.photo,
        referredBy: _user?.referredBy,
        myReferral: _user?.myReferral,
        mpoints: mpoints,
        mpointsUsed: _user?.mpointsUsed,
        mpointsReceived: _user?.mpointsReceived,
        statementList: _statementList);

    _user = updateUser;

    _isLoadingUser = false;
    notifyListeners();
  }

  Future<void> updateMPointsUsed(int rewardCost) async {
    _isLoadingUser = true;
    notifyListeners();

    final response = await http.put(
        Constant.baseUrl +
            Constant.userParam +
            '/${_user.uid}/mpointsUsed' +
            Constant.jsonExt,
        body: json.encode(user.mpointsUsed + rewardCost));
    print(json.decode(response.body));

    final User updateUser = User(
        uid: _user?.uid,
        firstName: _user?.firstName,
        lastName: _user?.lastName,
        email: _user?.email,
        phoneNumber: _user?.phoneNumber,
        photo: _user?.photo,
        referredBy: _user?.referredBy,
        myReferral: _user?.myReferral,
        mpoints: _user?.mpoints,
        mpointsUsed: _user.mpointsUsed + rewardCost,
        mpointsReceived: _user?.mpointsReceived,
        statementList: _statementList);

    _user = updateUser;

    _isLoadingUser = false;
    notifyListeners();
  }

  Future<void> updateMPointsReceived(int claim) async {
    _isLoadingUser = true;
    notifyListeners();

    final response = await http.put(
        Constant.baseUrl +
            Constant.userParam +
            '/${_user.uid}/mpointsReceived' +
            Constant.jsonExt,
        body: json.encode(user.mpointsReceived + claim));
    print(json.decode(response.body));

    final User updateUser = User(
        uid: _user?.uid,
        firstName: _user?.firstName,
        lastName: _user?.lastName,
        email: _user?.email,
        phoneNumber: _user?.phoneNumber,
        photo: _user?.photo,
        referredBy: _user?.referredBy,
        myReferral: _user?.myReferral,
        mpoints: _user?.mpoints,
        mpointsUsed: _user?.mpointsUsed,
        mpointsReceived: _user.mpointsReceived + claim,
        statementList: _statementList);

    _user = updateUser;

    _isLoadingUser = false;
    notifyListeners();
  }

  Future addRedeemToStatement(int rewardCost) async {
    final timestamp = DateTime.now().toUtc().millisecondsSinceEpoch;
    print(timestamp.toString());

    _isLoadingUser = true;
    notifyListeners();

    final Map<String, dynamic> statementData = {
      'banner': getSelectedReward.banner,
      'contra': "Unknown",
      'timestamp': timestamp,
      'partner_name': getSelectedReward.partnerName,
      'reward_cost': rewardCost,
      'reward_name': getSelectedReward.name,
      'reward_value': getSelectedReward.rewardValue
    };

    try {
      final http.Response response = await http.post(
          Constant.baseUrl +
              Constant.userParam +
              '/${_user.uid}' +
              Constant.statementParam +
              Constant.jsonExt,
          body: json.encode(statementData));

      final Map<String, dynamic> responseData = json.decode(response.body);
      print(responseData);

      final Statement newStatement = Statement(
          id: responseData['name'],
          banner: getSelectedReward.banner,
          contra: "Unknown",
          timestamp: timestamp,
          partnerName: getSelectedReward.partnerName,
          rewardCost: rewardCost,
          rewardName: getSelectedReward.name,
          rewardValue: getSelectedReward.rewardValue);

      _statementList.add(newStatement);

      _isLoadingUser = false;
      notifyListeners();
    } catch (error) {
      _isLoadingUser = false;
      notifyListeners();
      throw Exception('failed to load data');
    }
  }

  Future addClaimToStatement(
      int claim, String partnerName, int purchaseAmount) async {
    final timestamp = DateTime.now().toUtc().millisecondsSinceEpoch;
    print(timestamp.toString());

    _isLoadingUser = true;
    notifyListeners();

    final Map<String, dynamic> statementData = {
      'claim': claim,
      'contra': "Unknown",
      'timestamp': timestamp,
      'partner_name': partnerName,
      'purchase_amount': purchaseAmount
    };

    try {
      final http.Response response = await http.post(
          Constant.baseUrl +
              Constant.userParam +
              '/${_user.uid}' +
              Constant.statementParam +
              Constant.jsonExt,
          body: json.encode(statementData));

      final Map<String, dynamic> responseData = json.decode(response.body);
      print(responseData);

      final Statement newStatement = Statement(
          id: responseData['name'],
          claim: claim,
          contra: "Unknown",
          timestamp: timestamp,
          partnerName: partnerName,
          purchaseAmount: purchaseAmount);

      _statementList.add(newStatement);

      _isLoadingUser = false;
      notifyListeners();
    } catch (error) {
      _isLoadingUser = false;
      notifyListeners();
      throw Exception('failed to load data');
    }
  }
}
