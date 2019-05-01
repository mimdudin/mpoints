import 'package:flutter/material.dart';

import './authentications/auth.dart';
import './home.dart';
import './authentications/login_page.dart';
import './services/main_model.dart';

class RootPage extends StatefulWidget {
  final BaseAuth auth;
  final MainModel model;

  RootPage({this.auth, this.model});

  @override
  _RootPageState createState() => _RootPageState();
}

enum AuthStatus { notSignedIn, signedIn }

class _RootPageState extends State<RootPage> {
  AuthStatus _status = AuthStatus.notSignedIn;

  @override
  void initState() {
    super.initState();
    widget.auth.currentUser().then((userData) {
      setState(() {
        _status =
            userData == null ? AuthStatus.notSignedIn : AuthStatus.signedIn;
      });
    });
  }

  void _onSignedIn() {
    setState(() {
      _status = AuthStatus.signedIn;
    });
  }

  void _onSignedOut() {
    setState(() {
      _status = AuthStatus.notSignedIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (_status) {
      case AuthStatus.notSignedIn:
        return LoginPage(auth: widget.auth, onSignedIn: _onSignedIn, model: widget.model);
        break;
      case AuthStatus.signedIn:
        return Home(auth: widget.auth, onSignedOut: _onSignedOut, model: widget.model);
        break;
    }
  }
}
