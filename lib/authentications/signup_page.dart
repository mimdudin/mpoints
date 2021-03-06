import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import './auth.dart';
import '../services/main_model.dart';
import '../utils/phone_input_formatter.dart';
import '../utils/pallete.dart';
import '../utils/strings.dart';
import '../utils/circular_loading.dart';
import '../pages/terms_privacy_page.dart';

class SignupPage extends StatefulWidget {
  final BaseAuth auth;
  final VoidCallback onSignedIn;
  final MainModel model;

  SignupPage({this.auth, this.onSignedIn, this.model});
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
                      Strings.signUp.toUpperCase(),
                      style: Theme.of(context)
                          .textTheme
                          .subhead
                          .copyWith(fontSize: 30, color: Pallete.primary),
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
          .createUserWithEmailPassword(
              _email, _password, _firstName, _lastName, _phoneNumber, "")
          .then((user) {
        print("Registered User ${user.uid}");
        widget.onSignedIn();

        setState(() {
          _isLoading = false;
        });

        Navigator.pop(context);
        _firstController.clear();
        _lastController.clear();
        _phoneController.clear();
        _emailController.clear();
        _passwordController.clear();
      });
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
            BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8))),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Container(
              width: 128,
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
                        Strings.signUp,
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
        ));
  }

  Widget _buildFirstNameField() {
    return Container(
      child: TextFormField(
        autofocus: false,
        controller: _firstController,
        cursorColor: Pallete.primary,
        decoration: InputDecoration(
          hintText: Strings.firstName,
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
            return Strings.errorFirstName;
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
        cursorColor: Pallete.primary,
        decoration: InputDecoration(
          hintText: Strings.lastName,
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
            return Strings.errorLastName;
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
            cursorColor: Pallete.primary,
            decoration: InputDecoration(
              labelText: Strings.phoneNumber,
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
              prefixText: '+230 ',
              prefixStyle: TextStyle(
                  color: Pallete.primary,
                  fontSize: 16,
                  fontWeight: FontWeight.bold),
            ),
            focusNode: _phoneFocusNode,
            keyboardType: TextInputType.number,
            maxLines: 1,
            validator: (value) {
              if (value.isEmpty) {
                return Strings.invalidPhoneNumber;
              }
            },
            // inputFormatters: <TextInputFormatter>[
            //   WhitelistingTextInputFormatter.digitsOnly,
            //   // Fit the validating format.
            //   _phoneNumberFormatter,
            // ],
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
            cursorColor: Pallete.primary,
            decoration: InputDecoration(
              hintText: Strings.email,
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
              hintText: Strings.password,
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
            color: Pallete.primary,
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
