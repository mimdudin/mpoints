import 'package:flutter/material.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:scoped_model/scoped_model.dart';

import '../../services/main_model.dart';
import './claim_validation_page.dart';
import '../../utils/circular_loading.dart';
import '../../utils/pallete.dart';
import '../../utils/strings.dart';

class ClaimPointsPage extends StatefulWidget {
  @override
  _ClaimPointsPageState createState() => _ClaimPointsPageState();
}

class _ClaimPointsPageState extends State<ClaimPointsPage> {
  var _purchaseController = TextEditingController();
  String _partnerNumber;
  bool _validate = false;

  @override
  void dispose() {
    super.dispose();

    _purchaseController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (context, child, model) {
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
                    Strings.purchaseTrans,
                    style: Theme.of(context)
                        .textTheme
                        .title
                        .copyWith(fontSize: 15, color: Pallete.primary),
                  ),
                ),
                SizedBox(height: 130),
                _buildAmountField(),
                SizedBox(height: 30),
                _buildNextBtn(model)
              ],
            )
          ],
        )));
      },
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

  Widget _buildAmountField() {
    return Container(
      width: MediaQuery.of(context).size.width / 1.8,
      alignment: Alignment.center,
      child: TextField(
        textAlign: TextAlign.center,
        controller: _purchaseController,
        decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
                borderSide: BorderSide(color: Pallete.primary)),
            hintText: Strings.enterPurchaseAmount,
            contentPadding: EdgeInsets.symmetric(vertical: 3),
            errorText: _validate ? "Purchase Amount can't be Empty." : null,
            errorStyle: TextStyle(fontSize: 14, color: Colors.redAccent[200])),
        maxLines: 1,
        keyboardType: TextInputType.number,
        onChanged: (String v) {
          setState(() {
            _partnerNumber = v;
            print(v);
          });
        },
      ),
    );
  }

  Widget _buildNextBtn(MainModel model) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.9,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(),
          Container(
            alignment: Alignment.centerRight,
            height: 40,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(100))),
            child: RaisedButton(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(100))),
              child: model.isLoadingClaim
                  ? LoadingCircular10()
                  : Text(
                      Strings.next,
                      style: Theme.of(context)
                          .textTheme
                          .button
                          .copyWith(fontSize: 16, color: Colors.white),
                    ),
              color: Pallete.primary,
              onPressed: () {
                setState(() {
                  if (_purchaseController.text.isNotEmpty) {
                    _validate = false;

                    model
                        .fetchAvailableClaims(
                            int.parse(_purchaseController.text))
                        .then((_) {
                      _validate = false;

                      if (model.claimList.length > 0 &&
                          model.claimList != null) {
                        // Navigator.push(
                        //     context,
                        //     MaterialPageRoute(
                        //         builder: (BuildContext context) =>
                        //             RedeemSummaryPage(widget.rewards, widget.i)));

                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ClaimValidationPage(model)));

                        _purchaseController.clear();
                      } else {
                        _buildAlert(context);
                        _purchaseController.clear();
                      }
                    });
                  } else {
                    _validate = true;
                  }
                });
              },
            ),
          )
        ],
      ),
    );
  }

  // Alert with single button.
  _buildAlert(context) {
    Alert(
      context: context,
      type: AlertType.warning,
      title: Strings.invalidPartNumber,
      // desc: Strings.notEnoughMPDesc,
      buttons: [
        DialogButton(
          color: Pallete.primary,
          child: Text(
            "OKAY",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
          onPressed: () => Navigator.pop(context),
          width: 120,
        )
      ],
    ).show();
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
}
