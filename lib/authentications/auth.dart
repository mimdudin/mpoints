import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
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
      String referralCode);
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
      firebaseAuth.signOut(), fbSignIn.logOut(), googleSignIn.signOut(),
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
    if (user != null) {
      setUidDatabse(user.uid, user.displayName, "", user.photoUrl, user.email,
          user.phoneNumber, "");
    } else {
      print("Failed to sign in with Google.");
    }
    // });
    // } on PlatformException catch (error) {
    //   print(error.message);
    // }

    return user;
  }

  // Firebase with email address and password register
  Future<FirebaseUser> createUserWithEmailPassword(
      String email,
      String password,
      String firstName,
      String lastName,
      String phoneNumber,
      String referralCode) async {
    FirebaseUser user = await firebaseAuth.createUserWithEmailAndPassword(
        email: email, password: password);

    setUidDatabse(
        user.uid, firstName, lastName, "", email, phoneNumber, referralCode);
    return user;
  }

  // Example code of how to sign in with email and password.
  Future<FirebaseUser> signInWithEmailAndPassword(
      String email, String password) async {
    final FirebaseUser user = await firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
    if (user != null)
      print("Success login");
    else
      print("failed to login");
    return user;
  }

  Future<FirebaseUser> signInWithFacebook() async {
    FacebookLoginResult result =
        await fbSignIn.logInWithReadPermissions(['email', 'public_profile']);
    final AuthCredential credential = FacebookAuthProvider.getCredential(
      accessToken: result.accessToken.token,
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
    if (user != null) {
      print('Successfully signed in with Facebook. ' + user.uid);
      setUidDatabse(user.uid, user.displayName, "", user.photoUrl, user.email,
          user.phoneNumber, "");
    } else {
      print('Failed to sign in with Facebook. ');
    }
    // });
    return user;
  }

  void setUidDatabse(
      String uid,
      String firstName,
      String lastName,
      String photoUrl,
      String email,
      String phoneNumber,
      String referralCode) async {
    final Map<String, dynamic> _userData = {
      'uid': uid,
      'firstName': firstName,
      'lastName': lastName,
      'profilePhoto': photoUrl,
      'email': email,
      'phoneNumber':
          phoneNumber == "" || phoneNumber == null ? "" : phoneNumber,
      'referralCode': referralCode,
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
}
