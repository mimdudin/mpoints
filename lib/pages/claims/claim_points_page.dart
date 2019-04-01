import 'package:flutter/material.dart';

import './claim_validation_page.dart';

class ClaimPointsPage extends StatefulWidget {
  @override
  _ClaimPointsPageState createState() => _ClaimPointsPageState();
}

class _ClaimPointsPageState extends State<ClaimPointsPage> {
  var _purchaseController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: ListView(
      children: <Widget>[
        SizedBox(height: 5),
        _buildBackBtn(context),
        SizedBox(height: 20),
        _buildLogo(),
        SizedBox(height: 40),
        Column(
          children: <Widget>[
            Container(
              alignment: Alignment.center,
              child: Text(
                "PURCHASE TRANSACTION",
                style: Theme.of(context)
                    .textTheme
                    .title
                    .copyWith(fontSize: 15, color: Color(0xffAD8D0B)),
              ),
            ),
            SizedBox(height: 130),
            _buildAmountField(),
            SizedBox(height: 30),
            _buildNextBtn()
          ],
        )
      ],
    )));
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

  Widget _buildAmountField() {
    return Container(
      width: MediaQuery.of(context).size.width / 1.8,
      alignment: Alignment.center,
      child: TextField(
        textAlign: TextAlign.center,
        controller: _purchaseController,
        decoration: InputDecoration(
            hintText: "Enter Purchase Amount",
            contentPadding: EdgeInsets.symmetric(vertical: 3)),
        maxLines: 1,
        keyboardType: TextInputType.number,
        onChanged: (String v) {
          print(v);
        },
      ),
    );
  }

  Widget _buildNextBtn() {
    return Container(
      alignment: Alignment.centerRight,
      height: 40,
      width: MediaQuery.of(context).size.width / 1.9,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(100))),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(100))),
        child: Text(
          "Next",
          style: Theme.of(context)
              .textTheme
              .button
              .copyWith(fontSize: 16, color: Colors.white),
        ),
        color: Color(0xffAD8D0B),
        onPressed: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => ClaimValidationPage()));
        },
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
