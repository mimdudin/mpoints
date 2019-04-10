import 'package:scoped_model/scoped_model.dart';
import 'dart:async';
import 'package:firebase_database/firebase_database.dart';

import '../models/claims.dart';

mixin ClaimService on Model {
  List<Claims> _claimList = [];
  List<Claims> get claimList => _claimList;

  bool _isLoadingClaim = false;
  bool get isLoadingClaim => _isLoadingClaim;

  Future<List<Claims>> fetchAvailableClaims(int purchaseAmount) async {
    _isLoadingClaim = true;
    notifyListeners();

    DatabaseReference ref = FirebaseDatabase.instance.reference();
    await ref
        .child("claims")
        .orderByChild('purchase_amount')
        .equalTo(purchaseAmount)
        .once()
        .then((DataSnapshot snap) {
      Map<dynamic, dynamic> values = snap.value;
      print(values);
      // print(snap.value);
      // var keys = snap.value.keys;
      // var data = snap.value;

      // for (var key in keys) {
      //   _claims = new Claims(
      //     data[key]['id'],
      //     data[key]['contra'],
      //     data[key]['partner_name'],
      //     data[key]['claim'],
      //     data[key]['timestamp'],
      //     data[key]['employee_pin'],
      //     data[key]['partner_number'],
      //     data[key]['purchase_amount'],
      //     data[key]['social_points'],
      //   );
      //   _fetchedClaims.add(_claims);
      // }
      final List<Claims> _fetchedClaims = [];

      if (values != null) {
        values.forEach((key, data) {
          print(key);
          print(data);
          var _claims = new Claims(
            key,
            data['contra'],
            data['partner_name'],
            data['claim'],
            data['timestamp'],
            data['employee_pin'],
            data['partner_number'],
            data['purchase_amount'],
            data['social_points'],
          );
          _fetchedClaims.add(_claims);
        });
      }

      _claimList = _fetchedClaims;

      print(_claimList.length.toString());

      _isLoadingClaim = false;
      notifyListeners();
    });
    return _claimList;
  }
}
