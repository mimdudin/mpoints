import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import './claim_success_page.dart';
import '../../services/main_model.dart';
import '../../models/claims.dart';
import '../../utils/pallete.dart';
import '../../utils/strings.dart';
import '../../utils/circular_loading.dart';

class ClaimSummaryPage extends StatefulWidget {
  // final List<Claims> claimList;
  final String partnerNumber;
  final mpoints, socialPoints, purchaseAmount;

  ClaimSummaryPage(
      this.purchaseAmount, this.mpoints, this.socialPoints, this.partnerNumber);

  @override
  _ClaimSummaryPageState createState() => _ClaimSummaryPageState();
}

class _ClaimSummaryPageState extends State<ClaimSummaryPage> {
  // var _pointsValueController = TextEditingController();
  var _partnerPINController = TextEditingController();
  var _validate = false;
  // int _claim, _purchaseAmount;
  String _partnerPIN, _partnerId, _partnerName;

  @override
  void initState() {
    super.initState();

    // print(widget.claimList.length.toString());
  }

  @override
  void dispose() {
    super.dispose();
    _partnerPINController.clear();
    _partnerPINController.dispose();
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
                    Strings.purchaseSum,
                    style: Theme.of(context)
                        .textTheme
                        .title
                        .copyWith(fontSize: 15, color: Pallete.primary),
                  ),
                ),
                SizedBox(height: 30),
                _buildPurchaseSumItem(model),
                // SizedBox(height: 45),
                // _buildPointsFormField(),
                SizedBox(height: 30),
                _buildPartnerPINField(),
                SizedBox(height: 30),
                _buildFinishBtn(model),
                SizedBox(height: 25),
              ],
            )
          ],
        )));
      },
    );
  }

  Widget _buildPurchaseSumItem(MainModel model) {
    return Container(
        child: ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            shrinkWrap: true,
            itemCount: model.partnerList
                .where(
                    (partner) => partner.partnerNumber == widget.partnerNumber)
                .toList()
                .length,
            itemBuilder: (context, i) {
              var partner = model.partnerList
                  .where((partner) =>
                      partner.partnerNumber == widget.partnerNumber)
                  .toList()[i];
              // setState(() {
              _partnerId = partner.id;
              _partnerName = partner.name;
              // });
              return Column(
                children: <Widget>[
                  _buildPurchaseLabelValue(Strings.partnerName, partner.name),
                  SizedBox(height: 8),
                  _buildPurchaseLabelValue(
                      Strings.purchaseAmount, "Rs. ${widget.purchaseAmount}"),
                  SizedBox(height: 8),
                  _buildPurchaseLabelValue(
                      Strings.mpoints, "Mp. ${model.format(widget.mpoints)}"),
                  SizedBox(height: 8),
                  _buildPurchaseLabelValue(Strings.socialPoints,
                      "Sp. ${model.format(widget.socialPoints)}"),
                ],
              );
            }));
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
                  .copyWith(fontSize: 14, color: Pallete.primary),
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

  // Widget _buildPointsFormField() {
  //   return Container(
  //     width: MediaQuery.of(context).size.width / 1.8,
  //     alignment: Alignment.center,
  //     child: TextFormField(
  //       validator: (v) {
  //         if (v.isEmpty) {
  //           return "Invalid Points Value.";
  //         }
  //       },
  //       onSaved: (v) {},
  //       textAlign: TextAlign.center,
  //       controller: _pointsValueController,
  //       decoration: InputDecoration(
  //           hintText: "Enter Points Value",
  //           contentPadding: EdgeInsets.symmetric(vertical: 3)),
  //       maxLines: 1,
  //       keyboardType: TextInputType.number,
  //     ),
  //   );
  // }

  Widget _buildPartnerPINField() {
    return Container(
      width: MediaQuery.of(context).size.width / 1.8,
      alignment: Alignment.center,
      child: TextField(
        textAlign: TextAlign.center,
        controller: _partnerPINController,
        decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Pallete.primary),
            ),
            hintText: Strings.enterPartPIN,
            contentPadding: EdgeInsets.symmetric(vertical: 3),
            errorText: _validate ? "Partner PIN can't be Empty." : null,
            errorStyle: TextStyle(fontSize: 14, color: Colors.redAccent[200])),
        maxLines: 1,
        keyboardType: TextInputType.number,
        onChanged: (v) {
          setState(() {
            _partnerPIN = v;
            print(v);
          });
        },
      ),
    );
  }

  Widget _buildFinishBtn(MainModel model) {
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
              child: model.isLoadingUser
                  ? LoadingCircular10()
                  : Text(
                      Strings.finish,
                      style: Theme.of(context)
                          .textTheme
                          .button
                          .copyWith(fontSize: 16, color: Colors.white),
                    ),
              color: Pallete.primary,
              onPressed: () {
                setState(() {
                  if (_partnerPINController.text.isNotEmpty) {
                    // if (model.partnerList
                    //         .where((partner) =>
                    //             partner.partnerNumber == _partnerPINController.text)
                    //         .toList()
                    //         .length >
                    //     0) {
                    _validate = false;

                    // for (var claim in widget.claimList) {
                    //  model.selectedRewad(widget.i);
                    updateMPoints(
                            model,
                            widget.mpoints,
                            _partnerName,
                            widget.purchaseAmount,
                            widget.socialPoints,
                            model.user.firstName + " " + model.user.lastName ??
                                "Unknown",
                            _partnerId)
                        .then((_) => Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    ClaimSuccessPage(widget.mpoints)),
                            ModalRoute.withName('/main')));
                    // }
                    // } else {
                    //   _validate = false;

                    //   _buildAlert(context);
                    //   _partnerPINController.clear();
                    // }
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

  // String format(double n) {
  //   return n.toStringAsFixed(n.truncateToDouble() == n ? 0 : 2);
  // }

  // Alert with single button.
  _buildAlert(context) {
    Alert(
      context: context,
      type: AlertType.warning,
      title: Strings.invalidPartPIN,
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

  Future updateMPoints(
      MainModel model,
      double claim,
      String partnerName,
      int purchaseAmount,
      double socialPoints,
      String user,
      String partnerId) async {
    await Future.wait([
      model.updateMPoints(model.user.mpoints + claim),
      model.updateMPointsReceived(claim),
      model.updateSocialPoints(socialPoints),
      model.addClaimToStatement(claim, partnerName, purchaseAmount),
      model.addClaimToPartner(claim, purchaseAmount, user, partnerId),
    ]);
  }
}
