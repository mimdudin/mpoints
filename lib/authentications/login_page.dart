import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter/services.dart';

import './signup_page.dart';
import '../pages/terms_privacy_page.dart';
import './auth.dart';

class LoginPage extends StatefulWidget {
  final BaseAuth auth;
  final VoidCallback onSignedIn;

  LoginPage({this.auth, this.onSignedIn});

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
                      "SIGN IN",
                      style: Theme.of(context)
                          .textTheme
                          .subhead
                          .copyWith(fontSize: 30, color: Color(0xffAD8D0B)),
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
      var user =
          await widget.auth.signInWithEmailAndPassword(_email, _password);
      print("Signed In ${user.uid}");
      widget.onSignedIn();

      setState(() {
        _isLoading = false;
      });
      _emailController.clear();
      _passwordController.clear();
    } on PlatformException catch (e) {
      if (e.code == 'ERROR_WRONG_PASSWORD') {
        showInSnackBar("Invalid your Email or Password.");
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
            cursorColor: Color(0xffAD8D0B),
            decoration: InputDecoration(
              labelText: "Email",
              hintText: "enter your email",
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
                return 'Please enter a valid email';
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
              "Forgot Password?",
              style: Theme.of(context).textTheme.subtitle.copyWith(
                  fontSize: 14,
                  color: Color(0xffAD8D0B),
                  fontStyle: FontStyle.italic),
            ),
            onTap: _showDialog,
          ),
          Container(
            height: 40,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(100))),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(100))),
              child: _isLoading
                  ? CircularProgressIndicator()
                  : Text(
                      "SIGN IN",
                      style: Theme.of(context)
                          .textTheme
                          .button
                          .copyWith(fontSize: 16, color: Colors.white),
                    ),
              color: Color(0xffAD8D0B),
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
            child: Text("Don't have an account? ",
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
                          )));
            },
            child: Container(
              child: Text("Sign Up",
                  style: TextStyle(
                      fontSize: 15.0,
                      color: Color(0xffAD8D0B),
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
          child: Text("By Sign In you agree with our ",
              style:
                  Theme.of(context).textTheme.caption.copyWith(fontSize: 13)),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => TermsPrivacyPage()));
          },
          child: Container(
            child: Text("Terms.",
                style: TextStyle(
                    fontSize: 15.0,
                    color: Color(0xffAD8D0B),
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
          "OR SIGN IN WITH",
          style: Theme.of(context)
              .textTheme
              .subhead
              .copyWith(fontSize: 15, color: Color(0xffAD8D0B)),
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
                  "Log In",
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
                icon: Icon(
                  FontAwesomeIcons.google,
                  color: Colors.white,
                ),
                elevation: 2.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5))),
                color: Color(0xFFdd4b39),
                label: Text(
                  "Sign In",
                  style: Theme.of(context)
                      .textTheme
                      .button
                      .copyWith(fontSize: 16, color: Colors.white),
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
            cursorColor: Color(0xffAD8D0B),
            decoration: InputDecoration(
              labelText: "Password",
              hintText: "enter your password",
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
                return "Invalid Password";
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
            title: Text("We will send reset password link to your email"),
            content: Container(
                child: TextField(
              controller: _forgotPassController,
              // focusNode: _forgotFocusNode,
              decoration: InputDecoration(
                  hintStyle:
                      TextStyle(fontSize: 16, fontWeight: FontWeight.w400),
                  hintText: 'Enter your email',
                  errorText: _validate ? 'Please enter a valid email' : null),
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
                  child: Text("OK"),
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
      showInSnackBar("Requesting password reset email");
    } catch (e) {
      showInSnackBar(
          "Password reset failed, did you enter the correct address?");
      print("Error $e");
    }
  }

  Future<void> _facebookAuth() async {
    try {
      var fbUser = await widget.auth.signInWithFacebook();
      print("Signed in as ${fbUser.displayName}");
      widget.onSignedIn();

      // Navigator.pushReplacementNamed(context, '/mainapp').then((_) {
      //   Navigator.of(context).pop();
      // });
    } on PlatformException catch (e) {
      if (e.code == 'ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL') {
        showInSnackBar("This Email Address is already registered.");
        print(e.code);
      }
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      var user = await widget.auth.signInWithGoogle();
      print("Signed In ${user.displayName}");
      widget.onSignedIn();
    } on PlatformException catch (e) {
      if (e.code == 'ERROR_ACCOUNT_EXISTS_WITH_DIFFERENT_CREDENTIAL') {
        showInSnackBar("This Email Address is already registered.");
        print(e.code);
      }
    }
  }
}
