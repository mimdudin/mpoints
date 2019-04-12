import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';
import 'package:firebase_database/firebase_database.dart';

import './reward_list_service.dart';
import '../models/user.dart';
import '../utils/constant.dart';
import '../models/statement.dart';

mixin UserService on Model, RewardListService {
  User _user = new User();
  User get user => _user;

  String _status = "";
  String get status => _status;

  List<Statement> _statementList = [];
  // List<Statement> get statementList => _statementList;

  List<Statement> get statementList {
    if (_status == 'Claim') {
      return List.from(_statementList
          .where((statement) => statement.claim != null)
          .toList());
    } else if (_status == 'Redeem') {
      return List.from(_statementList
          .where((statement) => statement.rewardName != null)
          .toList());
    }
    return List.from(_statementList);
  }

  bool _isLoadingUser = false;
  bool get isLoadingUser => _isLoadingUser;

  int getStatementsCount() {
    return _statementList.length;
  }

  void addStatementToList(Statement statement) {
    return _statementList.add(statement);
  }

  void setStatus(String update) {
    _status = update;
    notifyListeners();
  }

  Future<User> fetchUserById(String userId) async {
    _isLoadingUser = true;
    notifyListeners();

    final response = await http.get(
        Constant.baseUrl + Constant.userParam + '/$userId' + Constant.jsonExt);

    if (response.statusCode == 200) {
      var result = json.decode(response.body);
      print(result);
      if (result != null) {
        fetchStatements(userId);

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
            socialPoints: result['social_points'],
            statementList: _statementList);
      }
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
        socialPoints: _user?.socialPoints,
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
        socialPoints: _user?.socialPoints,
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
        socialPoints: _user?.socialPoints,
        statementList: _statementList);

    _user = updateUser;

    _isLoadingUser = false;
    notifyListeners();
  }

  Future<void> updateSocialPoints(int socialPoints) async {
    _isLoadingUser = true;
    notifyListeners();

    final response = await http.put(
        Constant.baseUrl +
            Constant.userParam +
            '/${_user.uid}/social_points' +
            Constant.jsonExt,
        body: json.encode(user.socialPoints + socialPoints));
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
        mpointsReceived: _user?.mpointsReceived,
        socialPoints: _user.socialPoints + socialPoints,
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

  Future<List<Statement>> fetchStatements(String uid) async {
    // _isLoadingClaim = true;
    // notifyListeners();

    DatabaseReference ref = FirebaseDatabase.instance.reference();
    await ref.child("users/$uid/statements").once().then((DataSnapshot snap) {
      var values;
      if (snap.value != null) {
        values = new Map<String, dynamic>.from(snap.value);
        print(values);
      }

      final List<Statement> _fetchedClaims = [];

      if (values != null) {
        values.forEach((key, data) {
          print(key);
          print(data);
          var _statement =
              new Statement.fromJson(key, Map<String, dynamic>.from(data));
          _fetchedClaims.add(_statement);
        });
      }

      _statementList = _fetchedClaims;
      notifyListeners();

      print(_statementList.length.toString());

      // _isLoadingClaim = false;
    });
    return _statementList;
  }

  void clearUserList() {
    _user = null;
    notifyListeners();
  }

  void clearStatementList() {
    _statementList.clear();
    notifyListeners();
  }
}
