import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'dart:math' as math;
import 'package:flutter/services.dart';

// import 'package:firebase_database/firebase_database.dart';
// import 'package:firebase_database/ui/firebase_animated_list.dart';
import 'dart:async';
import 'package:flutter_facebook_login/flutter_facebook_login.dart';

// import '../../../models/user.dart';

abstract class BaseAuth {
  Future<FirebaseUser> currentUser();
  Future<void> forgotPassword(String email);
  Future<void> signOut();
  Future<FirebaseUser> signInWithGoogle();
  Future<FirebaseUser> signInWithFacebook();
  Future<FirebaseUser> createUserWithEmailPassword(
      String email,
      String password,
      String firstName,
      String lastName,
      String phoneNumber,
      String referralBy);
  Future<FirebaseUser> signInWithEmailAndPassword(
      String email, String password);
}

class Auth implements BaseAuth {
  DatabaseReference _userRef;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  var googleSignIn = GoogleSignIn();
  var fbSignIn = FacebookLogin();

  @override
  Future<FirebaseUser> currentUser() async {
    FirebaseUser user = await firebaseAuth.currentUser();
    print(user);
    return user != null ? user : null;
  }

  @override
  Future<void> signOut() async {
    // TODO: implement signOut
    await Future.wait([
      firebaseAuth.signOut(),
      fbSignIn.logOut(),
      googleSignIn.signOut(),
    ]);
  }

  // // GoogleSignIn Firebase
  // Future<FirebaseUser> googleSignedIn() async {
  //   GoogleSignInAccount googleSignInAccount = await googleSignIn.signIn();
  //   GoogleSignInAuthentication signInAuthentication =
  //       await googleSignInAccount.authentication;

  //   FirebaseUser user = await firebaseAuth.signInWithGoogle(
  //       idToken: signInAuthentication.idToken,
  //       accessToken: signInAuthentication.accessToken);

  //   setUidDatabse(user);
  //   return user;
  // }

  // Example code of how to sign in with google.
  Future<FirebaseUser> signInWithGoogle() async {
    // try {
    final GoogleSignInAccount googleUser = await googleSignIn.signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser.authentication;
    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );
    FirebaseUser user = await firebaseAuth.signInWithCredential(credential);
    assert(user.email != null);
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await firebaseAuth.currentUser();
    assert(user.uid == currentUser.uid);
    // setState(() {
    if (user != null)
      await checkIfUserHasLoggedIn(user);
    else
      print("Failed to sign in with Google.");
    return user;
  }

  // Firebase with email address and password register
  Future<FirebaseUser> createUserWithEmailPassword(
      String email,
      String password,
      String firstName,
      String lastName,
      String phoneNumber,
      String referralBy) async {
    final FirebaseUser user = await firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);
    // final FirebaseUser currentUser = await firebaseAuth.currentUser();
    // assert(user.uid == currentUser.uid);
    if (user != null)
      // await createFirstUser(
      //     user, firstName, lastName, email, phoneNumber, referralBy);
      await setUidDatabse(
          uid: user.uid,
          firstName: firstName,
          lastName: lastName,
          email: email,
          photo: "http://via.placeholder.com/200x150",
          phoneNumber: phoneNumber,
          referredBy: "",
          myReferral: referralBy);
    else
      print("Failed to sign in with Google.");
    return user;
  }

  // Example code of how to sign in with email and password.
  Future<FirebaseUser> signInWithEmailAndPassword(
      String email, String password) async {
    final FirebaseUser user = await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    // final FirebaseUser currentUser = await firebaseAuth.currentUser();
    // assert(user.uid == currentUser.uid);
    if (user != null)
      print("Success login!");
    else
      print("failed to login");
    return user;
  }

  Future<FirebaseUser> signInWithFacebook() async {
    FacebookLoginResult result =
        await fbSignIn.logInWithReadPermissions(['email', 'public_profile']);
    final AuthCredential credential = FacebookAuthProvider.getCredential(
      accessToken: result.accessToken.token ?? "",
    );
    final FirebaseUser user =
        await firebaseAuth.signInWithCredential(credential);
    assert(user.email != null);
    assert(user.displayName != null);
    assert(!user.isAnonymous);
    assert(await user.getIdToken() != null);

    final FirebaseUser currentUser = await firebaseAuth.currentUser();
    assert(user.uid == currentUser.uid);
    // setState(() {
    if (user != null)
      await checkIfUserHasLoggedIn(user);
    else
      print('Failed to sign in with Facebook.');
    // });
    return user;
  }

  Future<void> setUidDatabse(
      {String uid,
      String firstName,
      String lastName,
      String email,
      String phoneNumber,
      String photo,
      String referredBy,
      String myReferral}) async {
    var rnd = new math.Random();
    var next = rnd.nextDouble() * 1000000;
    while (next < 100000) {
      next *= 10;
    }
    print(next.toInt());

    final Map<String, dynamic> _userData = {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'phoneNumber':
          phoneNumber == "" || phoneNumber == null ? "" : phoneNumber,
      'photo': photo,
      'referredBy': referredBy == "" || referredBy == null ? "" : referredBy,
      'referrals': myReferral == "" || myReferral == null ? "" : myReferral,
      'mpoints': 0.1,
      'mpointsUsed': 0,
      'mpointsReceived': 0.1,
      'social_points': 0.1,
      'customerNumber': next.toInt().toString()
      // 'statements': '',
    };

    _userRef = FirebaseDatabase.instance.reference().child("users");
    await _userRef.child(uid).set(_userData);
  }

  Future<void> forgotPassword(String email) async {
    try {
      await firebaseAuth.sendPasswordResetEmail(email: email);
    } on PlatformException catch (e) {
      print(e.code);
    }
  }

  Future<void> checkIfUserHasLoggedIn(FirebaseUser user) async {
    // _isLoadingClaim = true;
    // notifyListeners();

    DatabaseReference ref = FirebaseDatabase.instance.reference();
    await ref
        .child("users")
        .orderByKey()
        .equalTo(user.uid)
        .once()
        .then((DataSnapshot snap) {
      Map<dynamic, dynamic> values = snap.value;
      print(values);

      // final List<Claims> _fetchedClaims = [];

      if (values == null) {
        setUidDatabse(
            uid: user.uid,
            firstName: user.displayName,
            lastName: "",
            email: user.email,
            photo: user.photoUrl,
            phoneNumber: user.phoneNumber,
            referredBy: "",
            myReferral: "");
        //   values.forEach((key, data) {
        //     print(key);
        //     print(data);
        //     var _claims = new Claims(
        //       key,
        //       data['contra'],
        //       data['partner_name'],
        //       data['claim'],
        //       data['timestamp'],
        //       data['employee_pin'],
        //       data['partner_number'],
        //       data['purchase_amount'],
        //       data['social_points'],
        //     );
        //     _fetchedClaims.add(_claims);
        // });
      }

      // _claimList = _fetchedClaims;

      // print(_claimList.length.toString());

      // _isLoadingClaim = false;
      // notifyListeners();
    });
    // return _claimList;
  }

  Future<void> createFirstUser(
      FirebaseUser user,
      String firstName,
      String lastName,
      String email,
      String phoneNumber,
      String referredBy) async {
    // _isLoadingClaim = true;
    // notifyListeners();

    DatabaseReference ref = FirebaseDatabase.instance.reference();
    await ref
        .child("users")
        .orderByKey()
        .equalTo(user.uid)
        .once()
        .then((DataSnapshot snap) {
      Map<dynamic, dynamic> values = snap.value;
      print(values);

      // final List<Claims> _fetchedClaims = [];

      if (values == null) {
        setUidDatabse(
            uid: user.uid,
            firstName: firstName,
            lastName: lastName,
            email: email,
            photo: "",
            phoneNumber: phoneNumber,
            referredBy: referredBy,
            myReferral: "");
        //   values.forEach((key, data) {
        //     print(key);
        //     print(data);
        //     var _claims = new Claims(
        //       key,
        //       data['contra'],
        //       data['partner_name'],
        //       data['claim'],
        //       data['timestamp'],
        //       data['employee_pin'],
        //       data['partner_number'],
        //       data['purchase_amount'],
        //       data['social_points'],
        //     );
        //     _fetchedClaims.add(_claims);
        // });
      }

      // _claimList = _fetchedClaims;

      // print(_claimList.length.toString());

      // _isLoadingClaim = false;
      // notifyListeners();
    });
    // return _claimList;
  }
}
