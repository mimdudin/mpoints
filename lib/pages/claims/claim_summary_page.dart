import 'package:flutter/material.dart';

import './claim_success_page.dart';

class ClaimSummaryPage extends StatefulWidget {
  @override
  _ClaimSummaryPageState createState() => _ClaimSummaryPageState();
}

class _ClaimSummaryPageState extends State<ClaimSummaryPage> {
  var _pointsValueController = TextEditingController();
  var _partnerPINController = TextEditingController();

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
                "PURCHASE SUMMARY",
                style: Theme.of(context)
                    .textTheme
                    .title
                    .copyWith(fontSize: 15, color: Color(0xffAD8D0B)),
              ),
            ),
            SizedBox(height: 30),
            _buildPurchaseLabelValue("Partner Name:", "21 Cannonical"),
            SizedBox(height: 8),
            _buildPurchaseLabelValue("Purchase Value:", "Rs. 25.000"),
            SizedBox(height: 8),
            _buildPurchaseLabelValue("Mpoints:", "MP. 2.500"),
            SizedBox(height: 8),
            _buildPurchaseLabelValue("Social Points:", "Sp. 250"),
            SizedBox(height: 45),
            _buildPointsFormField(),
            SizedBox(height: 30),
            _buildPartnerPINFormField(),
            SizedBox(height: 30),
            _buildFinishBtn(),
            SizedBox(height: 25),
          ],
        )
      ],
    )));
  }

  Widget _buildPurchaseLabelValue(String label, String value) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            alignment: Alignment.centerRight,
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              label,
              style: Theme.of(context)
                  .textTheme
                  .caption
                  .copyWith(fontSize: 14, color: Color(0xffAD8D0B)),
            ),
          ),
        ),
        Expanded(
          child: Container(
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: Theme.of(context)
                  .textTheme
                  .subhead
                  .copyWith(fontSize: 16, color: Colors.grey[500]),
            ),
          ),
        ),
      ],
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

  Widget _buildPointsFormField() {
    return Container(
      width: MediaQuery.of(context).size.width / 1.8,
      alignment: Alignment.center,
      child: TextFormField(
        validator: (v) {
          if (v.isEmpty) {
            return "Invalid Points Value.";
          }
        },
        onSaved: (v) {},
        textAlign: TextAlign.center,
        controller: _pointsValueController,
        decoration: InputDecoration(
            hintText: "Enter Points Value",
            contentPadding: EdgeInsets.symmetric(vertical: 3)),
        maxLines: 1,
        keyboardType: TextInputType.number,
      ),
    );
  }

  Widget _buildPartnerPINFormField() {
    return Container(
      width: MediaQuery.of(context).size.width / 1.8,
      alignment: Alignment.center,
      child: TextFormField(
        validator: (v) {
          if (v.isEmpty) {
            return "Invalid Partner PIN.";
          }
        },
        onSaved: (v) {},
        textAlign: TextAlign.center,
        controller: _partnerPINController,
        decoration: InputDecoration(
            hintText: "Enter Partner PIN",
            contentPadding: EdgeInsets.symmetric(vertical: 3)),
        maxLines: 1,
        keyboardType: TextInputType.number,
      ),
    );
  }

  Widget _buildFinishBtn() {
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
          "Finish",
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
                  builder: (BuildContext context) => ClaimSuccessPage()));
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
