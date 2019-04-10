import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'dart:async';

import './redeem_success_page.dart';
import '../../models/rewards.dart';
import '../../utils/strings.dart';
import '../../utils/pallete.dart';
import '../../services/main_model.dart';
import '../../utils/circular_loading.dart';
import '../rewards_detail_page.dart';

class RedeemSummaryPage extends StatefulWidget {
  final Rewards rewards;
  final int i;

  RedeemSummaryPage(this.rewards, this.i);

  @override
  _RedeemSummaryPageState createState() => _RedeemSummaryPageState();
}

class _RedeemSummaryPageState extends State<RedeemSummaryPage> {
  var _partnerPINController = TextEditingController();
  bool _validate = false;
  String _partPIN;

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
                    Strings.reedemSum,
                    style: Theme.of(context)
                        .textTheme
                        .title
                        .copyWith(fontSize: 15, color: Pallete.primary),
                  ),
                ),
                SizedBox(height: 30),
                _buildRedeemLabelValue(Strings.partnerName,
                    widget.rewards?.partnerName ?? "Unknown"),
                SizedBox(height: 8),
                _buildRedeemLabelValue(
                    Strings.rewardName, widget.rewards?.name ?? "Unknown"),
                SizedBox(height: 8),
                _buildRedeemLabelValue(Strings.rewardValue,
                    "Rs. ${widget.rewards?.rewardValue}" ?? "Rs. 0"),
                SizedBox(height: 8),
                _buildRedeemLabelValue(
                    Strings.mpBalance, "Mp. ${model.user?.mpoints}" ?? "Mp. 0"),
                SizedBox(height: 8),
                _buildRedeemLabelValue(Strings.rewardCost,
                    "Mp. ${widget.rewards?.rewardCost}" ?? "Rs. 0"),
                SizedBox(height: 45),
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
            _partPIN = v;
            print(v);
          });
        },
      ),
    );
  }

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

  Widget _buildRedeemLabelValue(String label, String value) {
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
                  if (_partnerPINController.text ==
                      widget.rewards.employeePin) {
                    _validate = false;
                    model.selectedRewad(widget.i);
                    updateMPoints(model, widget.rewards.rewardCost).then((_) =>
                        Navigator.of(context).pushAndRemoveUntil(
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    RedeemSuccessPage(widget.rewards?.name)),
                            ModalRoute.withName('/main')));
                  } else if (_partnerPINController.text.isEmpty) {
                    _validate = true;
                  } else if (_partnerPINController.text !=
                      widget.rewards.partnerNumber) {
                    _validate = false;

                    _buildAlert(context);
                    _partnerPINController.clear();
                  }
                });
              },
            ),
          )
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
            color: Pallete.primary,
          ),
          onPressed: () => Navigator.pop(context),
        ));
  }

  Future updateMPoints(MainModel model, int rewardCost) async {
    await Future.wait([
      model.updateMPoints(model.user.mpoints - rewardCost),
      model.updateMPointsUsed(rewardCost),
      model.addRedeemToStatement(rewardCost)
    ]);
  }
}
