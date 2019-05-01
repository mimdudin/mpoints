import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';

import './signup_page.dart';
import './auth.dart';
import '../services/main_model.dart';
import '../pages/terms_privacy_page.dart';
import '../utils/circular_loading.dart';
import '../utils/pallete.dart';
import '../utils/strings.dart';

class LoginPage extends StatefulWidget {
  final BaseAuth auth;
  final VoidCallback onSignedIn;
  final MainModel model;

  LoginPage({this.auth, this.onSignedIn, this.model});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  var _emailController = TextEditingController();
  var _passwordController = TextEditingController();
  var _forgotPassController = TextEditingController();

  var _emailFocusNode = FocusNode();
  var _passwordFocusNode = FocusNode();
  var _forgotFocusNode = FocusNode();

  String _email;
  String _password;
  String _forgotEmail;

  bool _obscureText;
  bool _isLoading;
  bool _validate;

  var _formKey = GlobalKey<FormState>();
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();

    _obscureText = true;
    _isLoading = false;
    _validate = false;
  }

  @override
  void dispose() {
    super.dispose();

    _emailController.dispose();
    _passwordController.dispose();
    _forgotPassController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        alignment: Alignment.center,
        child: Center(
          child: Container(
            child: Form(
              key: _formKey,
              child: ListView(
                physics: NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                children: <Widget>[
                  _buildLogo(),
                  SizedBox(height: 20),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      Strings.signIn.toUpperCase(),
                      style: Theme.of(context)
                          .textTheme
                          .subhead
                          .copyWith(fontSize: 30, color: Pallete.primary),
                    ),
                  ),
                  SizedBox(height: 10),
                  _buildEmailField(),
                  SizedBox(height: 5),
                  _buildPasswordField(),
                  SizedBox(height: 15),
                  _buildForgotSignInBtn(),
                  SizedBox(height: 15),
                  _buildLabelRegister(),
                  SizedBox(height: 30),
                  _buildSignInWith(),
                  SizedBox(height: 15),
                  _buildLabelTerms(),
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void _validateAndSubmit() async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    _formKey.currentState.save();

    try {
      await widget.auth
          .signInWithEmailAndPassword(_email, _password)
          .then((user) {
        print("Signed In ${user.uid}");
        widget.onSignedIn();

        setState(() {
          _isLoading = false;
        });
        _emailController.clear();
        _passwordController.clear();
      });
    } on PlatformException catch (e) {
      if (e.code == 'ERROR_WRONG_PASSWORD') {
        showInSnackBar(Strings.errorEmailPass);
        print(e.code);
      } else if (e.code == 'ERROR_USER_NOT_FOUND') {
        showInSnackBar(Strings.errorNotUser);
        print(e.code);
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  Widget _buildEmailField() {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 0.0),
        child: Container(
          child: TextFormField(
            autofocus: false,
            controller: _emailController,
            cursorColor: Pallete.primary,
            decoration: InputDecoration(
              labelText: Strings.email,
              hintText: Strings.hintEmail,
              hintStyle: TextStyle(
                  color: Color(0xffb7b7b7),
                  height: 1.5,
                  fontSize: 13.0,
                  fontWeight: FontWeight.w500),
            ),
            focusNode: _emailFocusNode,
            keyboardType: TextInputType.emailAddress,
            maxLines: 1,
            validator: (value) {
              if (value.isEmpty ||
                  !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                      .hasMatch(value)) {
                return Strings.enterValidEmail;
              }
            },
            onSaved: (value) => _email = value,
          ),
        ));
  }

  Widget _buildForgotSignInBtn() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          GestureDetector(
            child: Text(
              Strings.forgotPass,
              style: Theme.of(context).textTheme.subtitle.copyWith(
                  fontSize: 14,
                  color: Pallete.primary,
                  fontStyle: FontStyle.italic),
            ),
            onTap: _showDialog,
          ),
          Container(
            height: 40,
            width: 125,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(8))),
            child: RaisedButton.icon(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(8))),
              label: _isLoading
                  ? Image.asset('assets/icons/Right.png',
                      height: 25, color: Pallete.primary)
                  : Image.asset('assets/icons/Right.png', height: 25),
              icon: _isLoading
                  ? LoadingCircular10()
                  : Text(
                      Strings.signIn,
                      style: Theme.of(context).textTheme.button.copyWith(
                          fontSize: 17,
                          color: Colors.white,
                          fontWeight: FontWeight.w400),
                    ),
              color: Pallete.primary,
              onPressed: _validateAndSubmit,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLabelRegister() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            child: Text(Strings.dontHaveAccount,
                style:
                    Theme.of(context).textTheme.caption.copyWith(fontSize: 13)),
          ),
          GestureDetector(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => SignupPage(
                            auth: widget.auth,
                            onSignedIn: widget.onSignedIn,
                            model: widget.model,
                          )));
            },
            child: Container(
              child: Text(Strings.signUp,
                  style: TextStyle(
                      fontSize: 15.0,
                      color: Pallete.primary,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline)),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildLabelTerms() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          child: Text(Strings.descTerms,
              style:
                  Theme.of(context).textTheme.caption.copyWith(fontSize: 13)),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) =>
                        TermsPrivacyPage(widget.model)));
          },
          child: Container(
            child: Text(Strings.terms,
                style: TextStyle(
                    fontSize: 15.0,
                    color: Pallete.primary,
                    fontWeight: FontWeight.w500)),
          ),
        )
      ],
    );
  }

  Widget _buildSignInWith() {
    return Column(
      children: <Widget>[
        Text(
          Strings.orSignWith,
          style: Theme.of(context)
              .textTheme
              .subhead
              .copyWith(fontSize: 15, color: Pallete.primary),
        ),
        SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RaisedButton.icon(
                icon: Icon(
                  FontAwesomeIcons.facebookF,
                  color: Colors.white,
                ),
                elevation: 2.0,
                color: Color(0xFF3b5998),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                label: Text(
                  Strings.logIn,
                  style: Theme.of(context)
                      .textTheme
                      .button
                      .copyWith(fontSize: 16, color: Colors.white),
                ),
                onPressed: _facebookAuth),
            SizedBox(
              width: 5.0,
            ),
            RaisedButton.icon(
                icon: Image.asset('assets/icons/google.png', height: 25),
                elevation: 2.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                color: Colors.white,
                label: Text(
                  Strings.signInSmall,
                  style: Theme.of(context)
                      .textTheme
                      .button
                      .copyWith(fontSize: 16, color: Colors.grey[700]),
                ),
                onPressed: _signInWithGoogle),
          ],
        )
      ],
    );
  }

  Widget _buildPasswordField() {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 0.0),
        child: Container(
          child: TextFormField(
            obscureText: _obscureText,
            autofocus: false,
            controller: _passwordController,
            cursorColor: Pallete.primary,
            decoration: InputDecoration(
              labelText: Strings.password,
              hintText: Strings.hintPassword,
              hintStyle: TextStyle(
                  color: Color(0xffb7b7b7),
                  height: 1.5,
                  fontSize: 13.0,
                  fontWeight: FontWeight.w500),
              suffixIcon: IconButton(
                icon: Icon(_obscureText
                    ? FontAwesomeIcons.eyeSlash
                    : FontAwesomeIcons.eye),
                iconSize: 16,
                onPressed: () {
                  // Update the state i.e. toogle the state of passwordVisible variable
                  setState(() {
                    _obscureText ? _obscureText = false : _obscureText = true;
                  });
                },
              ),
            ),
            focusNode: _passwordFocusNode,
            maxLines: 1,
            validator: (value) {
              if (value.isEmpty || value.length < 6) {
                return Strings.errorPassword;
              }
            },
            onSaved: (value) => _password = value,
          ),
        ));
  }

  Widget _buildLogo() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 25),
      alignment: Alignment.center,
      height: 100,
      child: Image.asset(
        "assets/images/logo/logo_v2.png",
        fit: BoxFit.cover,
      ),
    );
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(SnackBar(
      content: Text(value),
      duration: Duration(seconds: 2),
    ));
  }

  void hideSnackBar() {
    _scaffoldKey.currentState
        .hideCurrentSnackBar(reason: SnackBarClosedReason.timeout);
  }

  void _showDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(Strings.resetPassDesc),
            content: Container(
                child: TextField(
              controller: _forgotPassController,
              // focusNode: _forgotFocusNode,
              decoration: InputDecoration(
                  hintStyle:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                  hintText: Strings.hintEmail,
                  errorText: _validate ? Strings.enterValidEmail : null),
              onChanged: (v) => _forgotEmail = v,
            )),
            actions: <Widget>[
              // model.isLoading
              //     ? SpinKitFadingCube(
              //         color: Colors.orange,
              //         size: 30,
              //       )
              //     :
              // usually buttons at the bottom of the dialog
              // FlatButton(
              //   child: new Text("CANCEL"),
              //   onPressed: () {
              //     Navigator.of(context).pop();
              //   },
              // ),
              FlatButton(
                  child: Text(
                    "OK",
                    style: Theme.of(context)
                        .textTheme
                        .button
                        .copyWith(color: Pallete.primary),
                  ),
                  onPressed: () {
                    setState(() {
                      if (_forgotPassController.text.isEmpty ||
                          !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                              .hasMatch(_forgotPassController.text)) {
                        _validate = true;
                      } else {
                        _validate = false;

                        print(_forgotEmail);
                        _requestForgotPassword();
                        Navigator.of(context).pop();
                        _forgotPassController.clear();
                      }
                    });
                  })
            ],
          );
        });
  }

  Future<void> _requestForgotPassword() async {
    try {
      await widget.auth.forgotPassword(_forgotEmail);
      showInSnackBar(Strings.requestingPass);
    } catch (e) {
      showInSnackBar(Strings.errorRequestPass);
      print("Error $e");
    }
  }

  Future<void> _facebookAuth() async {
    try {
      await widget.auth.signInWithFacebook().then((user) {
        print("Signed in as ${user.displayName}");
        widget.onSignedIn();
      });

      // Navigator.pushReplacementNamed(context, '/mainapp').then((_) {
      //   Navigator.of(context).pop();
      // });
    } on PlatformException catch (e) {
      if (e.code == 'ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL') {
        showInSnackBar(Strings.alreadyRegistEmail);
        print(e.code);
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      await widget.auth.signInWithGoogle().then((user) {
        print("Signed In ${user.displayName}");
        widget.onSignedIn();
      });
    } on PlatformException catch (e) {
      if (e.code == 'ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL') {
        showInSnackBar(Strings.alreadyRegistEmail);
        print(e.code);
      }
    }
  }
}
