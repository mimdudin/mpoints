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

  String _status = "Claim & Redeem";
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
    } else if (_status == 'Claim & Redeem') {
      return List.from(_statementList);
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
            customerNumber: result['customerNumber'],
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

  Future<void> updateMPoints(double mpoints) async {
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

  Future<void> updateMPointsReceived(double claim) async {
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

  Future<void> updateSocialPoints(double socialPoints) async {
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
      'uniqueId': _statementList.length + 1,
      'banner': getSelectedReward.banner,
      'contra': "Unknown",
      'timestamp': timestamp,
      'partner_name': getSelectedReward.partnerName,
      'reward_cost': rewardCost,
      'reward_name': getSelectedReward.name,
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
          uniqueId: _statementList.length + 1,
          banner: getSelectedReward.banner,
          contra: "Unknown",
          timestamp: timestamp,
          partnerName: getSelectedReward.partnerName,
          rewardCost: rewardCost,
          rewardName: getSelectedReward.name);

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
      double claim, String partnerName, int purchaseAmount) async {
    final timestamp = DateTime.now().toUtc().millisecondsSinceEpoch;
    print(timestamp.toString());

    _isLoadingUser = true;
    notifyListeners();

    final Map<String, dynamic> statementData = {
      'uniqueId': _statementList.length + 1,
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
          uniqueId: _statementList.length + 1,
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

  Future addClaimToPartner(
      double claim, int purchaseAmount, String user, String partnerId) async {
    final timestamp = DateTime.now().toUtc().millisecondsSinceEpoch;
    print(timestamp.toString());

    _isLoadingUser = true;
    notifyListeners();

    final Map<String, dynamic> statementData = {
      'claim': claim,
      'contra': "Unknown",
      'timestamp': timestamp,
      'purchase_amount': purchaseAmount,
      'user': user,
    };

    try {
      final http.Response response = await http.post(
          Constant.baseUrl + '/partners/$partnerId/claims' + Constant.jsonExt,
          body: json.encode(statementData));

      final Map<String, dynamic> responseData = json.decode(response.body);
      print(responseData);

      // final Statement newStatement = Statement(
      //     id: responseData['name'],
      //     claim: claim,
      //     contra: "Unknown",
      //     timestamp: timestamp,
      //     partnerName: partnerName,
      //     purchaseAmount: purchaseAmount);

      // _statementList.add(newStatement);

      _isLoadingUser = false;
      notifyListeners();
    } catch (error) {
      _isLoadingUser = false;
      notifyListeners();
      throw Exception('failed to load data');
    }
  }

  Future addRedeemToPartner(String banner, String partnerName, int rewardCost,
      String rewardName, String partnerId, String user) async {
    final timestamp = DateTime.now().toUtc().millisecondsSinceEpoch;
    print(timestamp.toString());

    _isLoadingUser = true;
    notifyListeners();

    final Map<String, dynamic> statementData = {
      'banner': banner,
      'contra': "Unknown",
      'timestamp': timestamp,
      'reward_cost': rewardCost,
      'reward_name': rewardName,
      'user': user,
    };

    try {
      final http.Response response = await http.post(
          Constant.baseUrl +
              '/partners/$partnerId/redeem_request' +
              Constant.jsonExt,
          body: json.encode(statementData));

      final Map<String, dynamic> responseData = json.decode(response.body);
      print(responseData);

      // final Statement newStatement = Statement(
      //     id: responseData['name'],
      //     claim: claim,
      //     contra: "Unknown",
      //     timestamp: timestamp,
      //     partnerName: partnerName,
      //     purchaseAmount: purchaseAmount);

      // _statementList.add(newStatement);

      _isLoadingUser = false;
      notifyListeners();
    } catch (error) {
      _isLoadingUser = false;
      notifyListeners();
      throw Exception('failed to load data');
    }
  }

  Future<List<Statement>> fetchStatements(String uid) async {
    final List<Statement> _fetchedClaims = [];

    // _isLoadingClaim = true;
    // notifyListeners();

    DatabaseReference ref = FirebaseDatabase.instance.reference();
    await ref.child("users/$uid/statements").once().then((DataSnapshot snap) {
      var values;
      if (snap.value != null) {
        values = new Map<String, dynamic>.from(snap.value);
        print(values);
      }

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

  String format(double n) {
    return n?.toStringAsFixed(n?.truncateToDouble() == n ? 0 : 2);
  }

  void sortStatements() {
    _statementList.sort((b, a) => a.uniqueId.compareTo(b.uniqueId));
  }

  void unSortStatements() {
    _statementList.sort((a, b) => a.uniqueId.compareTo(b.uniqueId));
  }
}
