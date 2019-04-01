import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../utils/phone_input_formatter.dart';
import '../pages/terms_privacy_page.dart';
import './auth.dart';

class SignupPage extends StatefulWidget {
  final BaseAuth auth;
  final VoidCallback onSignedIn;

  SignupPage({this.auth, this.onSignedIn});
  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  var _firstController = TextEditingController();
  var _lastController = TextEditingController();
  var _phoneController = TextEditingController();
  var _emailController = TextEditingController();
  var _passwordController = TextEditingController();

  var _firstFocusNode = FocusNode();
  var _lastFocusNode = FocusNode();
  var _phoneFocusNode = FocusNode();
  var _emailFocusNode = FocusNode();
  var _passwordFocusNode = FocusNode();

  String _firstName;
  String _lastName;
  String _phoneNumber;
  String _email;
  String _password;

  bool _obscureText;
  bool _isLoading;

  var _formKey = GlobalKey<FormState>();
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  final PhoneInputFormatter _phoneNumberFormatter = PhoneInputFormatter();

  @override
  void initState() {
    super.initState();

    _obscureText = true;
    _isLoading = false;
  }

  @override
  void dispose() {
    super.dispose();

    _firstController.dispose();
    _lastController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Container(
        child: Center(
          child: Container(
            child: Form(
              key: _formKey,
              child: ListView(
                children: <Widget>[
                  SizedBox(height: 5),
                  _buildBackBtn(context),
                  SizedBox(height: 20),
                  _buildLogo(),
                  SizedBox(height: 20),
                  Container(
                    alignment: Alignment.center,
                    child: Text(
                      "SIGN UP",
                      style: Theme.of(context)
                          .textTheme
                          .subhead
                          .copyWith(fontSize: 30, color: Color(0xffAD8D0B)),
                    ),
                  ),
                  SizedBox(height: 25),
                  Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 40.0, vertical: 0.0),
                      child: Row(
                        children: <Widget>[
                          Expanded(child: _buildFirstNameField()),
                          SizedBox(width: 20),
                          Expanded(child: _buildLastNameField()),
                        ],
                      )),
                  SizedBox(height: 5),
                  _buildPhoneNumberField(),
                  SizedBox(height: 5),
                  _buildEmailField(),
                  SizedBox(height: 5),
                  _buildPasswordField(),
                  SizedBox(height: 15),
                  _buildSignUpBtn(),
                  SizedBox(height: 20),
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

  Future<void> _validateAndSubmit() async {
    if (!_formKey.currentState.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    _formKey.currentState.save();

    try {
      // if (widget.auth != null) {
      var user = await widget.auth.createUserWithEmailPassword(
          _email, _password, _firstName, _lastName, _phoneNumber, "");
      print("Registered User ${user.uid}");
      widget.onSignedIn();

      setState(() {
        _isLoading = false;
      });
      _firstController.clear();
      _lastController.clear();
      _phoneController.clear();
      _emailController.clear();
      _passwordController.clear();
      Navigator.pop(context);
      // }
    } on PlatformException catch (e) {
      if (e.code == 'ERROR_EMAIL_ALREADY_IN_USE') {
        showInSnackBar("Email address is already use by another account.");
        print(e.code);
      }
      setState(() {
        _isLoading = false;
      });
      print("Error: $e");
    }
  }

  Widget _buildSignUpBtn() {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 40),
        height: 40,
        decoration:
            BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(100))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(100))),
              child: _isLoading
                  ? CircularProgressIndicator()
                  : Text(
                      "SIGN UP",
                      style: Theme.of(context)
                          .textTheme
                          .button
                          .copyWith(fontSize: 16, color: Colors.white),
                    ),
              color: Color(0xffAD8D0B),
              onPressed: _validateAndSubmit,
            ),
          ],
        ));
  }

  Widget _buildFirstNameField() {
    return Container(
      child: TextFormField(
        autofocus: false,
        controller: _firstController,
        cursorColor: Color(0xffAD8D0B),
        decoration: InputDecoration(
          hintText: "First Name",
          hintStyle: TextStyle(
              color: Color(0xffb7b7b7),
              height: 1.5,
              fontSize: 13.0,
              fontWeight: FontWeight.w500),
        ),
        focusNode: _firstFocusNode,
        keyboardType: TextInputType.text,
        maxLines: 1,
        validator: (value) {
          if (value.isEmpty) {
            return "First Name can't be empty.";
          }
        },
        onSaved: (value) => _firstName = value,
      ),
    );
  }

  Widget _buildLastNameField() {
    return Container(
      child: TextFormField(
        autofocus: false,
        controller: _lastController,
        cursorColor: Color(0xffAD8D0B),
        decoration: InputDecoration(
          hintText: "Last Name",
          hintStyle: TextStyle(
              color: Color(0xffb7b7b7),
              height: 1.5,
              fontSize: 13.0,
              fontWeight: FontWeight.w500),
        ),
        focusNode: _lastFocusNode,
        keyboardType: TextInputType.text,
        maxLines: 1,
        validator: (value) {
          if (value.isEmpty) {
            return "Last Name can't be empty.";
          }
        },
        onSaved: (value) => _lastName = value,
      ),
    );
  }

  Widget _buildPhoneNumberField() {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 0.0),
        child: Container(
          child: TextFormField(
            autofocus: false,
            controller: _phoneController,
            cursorColor: Color(0xffAD8D0B),
            decoration: InputDecoration(
              labelText: 'Phone Number',
              labelStyle: TextStyle(
                  color: Color(0xffb7b7b7),
                  height: 1.2,
                  fontSize: 13.0,
                  fontWeight: FontWeight.w500),
              hintStyle: TextStyle(
                  color: Color(0xffb7b7b7),
                  height: 1.5,
                  fontSize: 13.0,
                  fontWeight: FontWeight.w500),
              prefixText: '+1 ',
              prefixStyle: TextStyle(
                  color: Color(0xffAD8D0B),
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            focusNode: _phoneFocusNode,
            keyboardType: TextInputType.number,
            maxLines: 1,
            validator: (value) {
              if (value.isEmpty) {
                return "Invalid Phone Number";
              }
            },
            inputFormatters: <TextInputFormatter>[
              WhitelistingTextInputFormatter.digitsOnly,
              // Fit the validating format.
              _phoneNumberFormatter,
            ],
            onSaved: (value) => _phoneNumber = value,
          ),
        ));
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
              hintText: "Email",
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
              hintText: "Password",
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

  Widget _buildBackBtn(BuildContext context) {
    return Container(
        alignment: Alignment.centerLeft,
        child: IconButton(
          icon: Icon(
            Icons.arrow_back,
            size: 28,
            color: Color(0xffAD8D0B),
          ),
          onPressed: () => Navigator.pop(context),
        ));
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
}
