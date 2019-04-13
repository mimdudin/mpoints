import 'package:flutter/material.dart';
import 'dart:async';
import 'package:scoped_model/scoped_model.dart';
import 'package:fast_qr_reader_view/fast_qr_reader_view.dart';
import 'package:rflutter_alert/rflutter_alert.dart';

import './claim_summary_page.dart';
import '../../services/main_model.dart';
import '../../utils/pallete.dart';
import '../../utils/strings.dart';
import '../../utils/circular_loading.dart';

void logError(String code, String message) =>
    print('Error: $code\nError Message: $message');

class ClaimValidationPage extends StatefulWidget {
  final MainModel model;
  final String purchaseAmount;

  ClaimValidationPage(this.model, this.purchaseAmount);

  @override
  _ClaimValidationPageState createState() => new _ClaimValidationPageState();
}

class _ClaimValidationPageState extends State<ClaimValidationPage>
    with SingleTickerProviderStateMixin {
  QRReaderController controller;
  AnimationController animationController;

  List<CameraDescription> cameras = [];
  Animation<double> verticalPosition;

  var _partNumController = TextEditingController();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  var _validate = false;
  String _partnerNumber;

  @override
  void initState() {
    super.initState();

    checkAvailableCamera();
  }

  @override
  void dispose() {
    _partNumController?.dispose();
    animationController?.stop();
    animationController?.dispose();
    controller?.stopScanning();
    controller?.dispose();
    super.dispose();
  }

  Future<Null> checkAvailableCamera() async {
    // Fetch the available cameras before initializing the app.
    try {
      cameras = await availableCameras();

      if (cameras != null) {
        animationController = new AnimationController(
          vsync: this,
          duration: new Duration(seconds: 3),
        );

        animationController.addListener(() {
          this.setState(() {});
        });
        animationController.forward();
        verticalPosition = Tween<double>(begin: 0.0, end: 300.0).animate(
            CurvedAnimation(parent: animationController, curve: Curves.linear))
          ..addStatusListener((state) {
            if (state == AnimationStatus.completed) {
              animationController.reverse();
            } else if (state == AnimationStatus.dismissed) {
              animationController.forward();
            }
          });

        // pick the first available camera
        onNewCameraSelected(cameras[0]);
      }
    } on QRReaderException catch (e) {
      logError(e.code, e.description);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (context, child, model) {
        return Scaffold(
          key: _scaffoldKey,
          body: Container(
            child: ListView(
              children: <Widget>[
                SizedBox(height: 5),
                _buildBackBtn(context),
                SizedBox(height: 20),
                _buildQRandOrLabel(Strings.qrScanner),
                SizedBox(height: 40),
                _buildQRScanner(),
                SizedBox(height: 25),
                _buildQRandOrLabel(Strings.or),
                SizedBox(height: 25),
                Column(
                  children: <Widget>[
                    _buildAmountField(),
                    SizedBox(height: 30),
                    _buildNextBtn(model)
                  ],
                ),
                SizedBox(height: 25),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildQRScanner() {
    return Container(
      height: 300,
      child: Stack(
        children: <Widget>[
          Container(alignment: Alignment.center, child: _cameraPreviewWidget()),
          Center(
            child: Stack(
              children: <Widget>[
                SizedBox(
                  height: 300.0,
                  width: 300.0,
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.red, width: 2.0)),
                  ),
                ),
                Positioned(
                  top: verticalPosition != null ? verticalPosition.value : 0,
                  child: Container(
                    width: 300.0,
                    height: 2.0,
                    color: Colors.red,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQRandOrLabel(String label) {
    return Container(
      alignment: Alignment.center,
      child: Text(
        label,
        style: Theme.of(context)
            .textTheme
            .title
            .copyWith(fontSize: 15, color: Pallete.primary),
      ),
    );
  }

  Widget _buildNextBtn(MainModel model) {
    return Container(
      alignment: Alignment.centerRight,
      height: 40,
      width: MediaQuery.of(context).size.width / 1.3,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(100))),
      child: RaisedButton(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(100))),
        child: Text(
          Strings.next,
          style: Theme.of(context)
              .textTheme
              .button
              .copyWith(fontSize: 16, color: Colors.white),
        ),
        color: Pallete.primary,
        onPressed: () {
          setState(() {
            if (_partNumController.text.isNotEmpty) {
              if (widget.model.partnerList
                      .where(
                          (partner) => partner.partnerNumber == _partnerNumber)
                      .toList()
                      .length >
                  0) {
                _validate = false;

                var mpoints = int.parse(widget.purchaseAmount) * 10 / 100;
                print(mpoints.toString());

                var socialPoints = int.parse(widget.purchaseAmount) * 1 / 100;
                print(socialPoints.toString());

                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) => ClaimSummaryPage(
                           int.parse(widget.purchaseAmount),
                            mpoints,
                            socialPoints,
                            _partnerNumber)));
                _partNumController.clear();
              } else {
                _validate = false;

                _buildAlert(context);
                _partNumController.clear();
              }
            } else {
              _validate = true;
            }
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

  Widget _buildAmountField() {
    return Container(
      width: MediaQuery.of(context).size.width / 1.3,
      alignment: Alignment.center,
      child: TextField(
        textAlign: TextAlign.center,
        controller: _partNumController,
        decoration: InputDecoration(
            focusedBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: Pallete.primary),
            ),
            hintText: Strings.enterPartNumber,
            contentPadding: EdgeInsets.symmetric(vertical: 3),
            errorText: _validate ? "Partner Number can't be Empty." : null,
            errorStyle: TextStyle(fontSize: 14, color: Colors.redAccent[200])),
        maxLines: 1,
        keyboardType: TextInputType.number,
        onChanged: (v) {
          setState(() {
            _partnerNumber = v;
            print(v);
          });
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
            color: Pallete.primary,
          ),
          onPressed: () => Navigator.pop(context),
        ));
  }

  /// Display the preview from the camera (or a message if the preview is not available).
  Widget _cameraPreviewWidget() {
    if (controller == null || !controller.value.isInitialized) {
      return Text(
        Strings.noCamSelected,
        style: TextStyle(
          color: Colors.white,
          fontSize: 24.0,
          fontWeight: FontWeight.w900,
        ),
      );
    } else {
      return AspectRatio(
        aspectRatio: 1,
        child: new QRReaderPreview(controller),
      );
    }
  }

  void onCodeRead(dynamic value) {
    print(value.toString());
    setState(() {
      if (widget.model.partnerList
              .where((partner) => partner.partnerNumber == value.toString())
              .toList()
              .length >
          0) {
        _validate = false;

        var mpoints = int.parse(widget.purchaseAmount) * 10 / 100;
        print(mpoints.toString());

        var socialPoints = int.parse(widget.purchaseAmount) * 1 / 100;
        print(socialPoints.toString());

        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => ClaimSummaryPage(
                    widget.purchaseAmount,
                    mpoints,
                    socialPoints,
                    value.toString())));
        _partNumController.clear();
      } else {
        _validate = false;

        _buildAlert(context);
        _partNumController.clear();
      }
    });
    // ... do something
    // wait 5 seconds then start scanning again.
    new Future.delayed(const Duration(seconds: 5), controller.startScanning);
  }

  void onNewCameraSelected(CameraDescription cameraDescription) async {
    if (controller != null) {
      await controller.dispose();
    }
    controller = new QRReaderController(cameraDescription, ResolutionPreset.low,
        [CodeFormat.qr, CodeFormat.pdf417], onCodeRead);

    // If the controller is updated then update the UI.
    controller.addListener(() {
      // if (mounted) setState(() {});
      if (controller.value.hasError) {
        showInSnackBar('Camera error ${controller.value.errorDescription}');
      }
    });

    try {
      await controller.initialize();
      if (mounted) {
        setState(() {});
        controller.startScanning();
      }
    } on QRReaderException catch (e) {
      logError(e.code, e.description);
      showInSnackBar('Error: ${e.code}\n${e.description}');
    }
  }

  void showInSnackBar(String message) {
    if (_scaffoldKey.currentState != null) {
      _scaffoldKey.currentState
          .showSnackBar(new SnackBar(content: new Text(message)));
    }
  }
}
