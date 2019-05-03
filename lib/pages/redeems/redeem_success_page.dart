import 'package:flutter/material.dart';

import '../../utils/strings.dart';
import '../../utils/pallete.dart';
import '../../services/main_model.dart';

class RedeemSuccessPage extends StatefulWidget {
  final String rewardName;
  final MainModel model;
  final Function format;

  RedeemSuccessPage(this.rewardName, this.model, this.format);

  @override
  _RedeemSuccessPageState createState() => _RedeemSuccessPageState();
}

class _RedeemSuccessPageState extends State<RedeemSuccessPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: ListView(
      children: <Widget>[
        SizedBox(height: 20),
        _buildLogo(),
        SizedBox(height: 40),
        Column(
          children: <Widget>[
            _buildSuccessIcon(),
            SizedBox(height: 40),
            _buildSomeText("Redemption Success.", 24),
            SizedBox(height: 15),
            _buildSomeText("${widget.rewardName} Redeemed.", 14),
            SizedBox(height: 15),
            _buildSomeText(
                "Remaining Mpoints: ${widget.format(widget.model.user.mpoints)}",
                16),
            SizedBox(height: 120),
            _buildHomeBtn(),
            SizedBox(height: 25),
          ],
        )
      ],
    )));
  }

  Widget _buildSuccessIcon() {
    return Container(
        child: Image.asset(
      'assets/icons/success.png',
      height: 150,
      color: Pallete.primary,
    ));
  }

  Widget _buildSomeText(String label, double fontSize) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Text(
        label,
        style: Theme.of(context)
            .textTheme
            .subhead
            .copyWith(fontSize: fontSize, color: Color(0xffAD8D0B)),
      ),
    );
  }

  Widget _buildLogo() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 25),
      alignment: Alignment.centerLeft,
      height: 100,
      child: Image.asset(
        "assets/images/logo/logo_v2.png",
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildHomeBtn() {
    return Container(
      alignment: Alignment.centerRight,
      margin: EdgeInsets.symmetric(horizontal: 30),
      height: 40,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Container(
            width: 118,
            child: RaisedButton.icon(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                label: Container(
                  padding: EdgeInsets.only(bottom: 4),
                  child: Image.asset('assets/icons/Home.png', height: 25),
                ),
                icon: Text(
                  Strings.home,
                  style: Theme.of(context).textTheme.button.copyWith(
                      fontSize: 20,
                      color: Colors.white,
                      fontWeight: FontWeight.w300),
                ),
                color: Color(0xffAD8D0B),
                onPressed: () => Navigator.of(context).pop()),
          ),
        ],
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
}
