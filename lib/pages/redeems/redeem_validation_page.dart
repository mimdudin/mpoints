import 'package:flutter/material.dart';
import 'dart:async';
import 'package:fast_qr_reader_view/fast_qr_reader_view.dart';

import './redeem_summary_page.dart';

void logError(String code, String message) =>
    print('Error: $code\nError Message: $message');

class RedeemValidationPage extends StatefulWidget {
  @override
  _RedeemValidationPageState createState() => new _RedeemValidationPageState();
}

class _RedeemValidationPageState extends State<RedeemValidationPage>
    with SingleTickerProviderStateMixin {
  QRReaderController controller;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  AnimationController animationController;
  List<CameraDescription> cameras = [];
  Animation<double> verticalPosition;

  @override
  void initState() {
    super.initState();

    checkAvailableCamera();
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
    return new MaterialApp(
      home: new Scaffold(
          key: _scaffoldKey,
          body: Container(
            child: ListView(
              children: <Widget>[
                SizedBox(height: 5),
                _buildBackBtn(context),
                SizedBox(height: 20),
                _buildQRandOrLabel("QR Scanner"),
                SizedBox(height: 40),
                _buildQRScanner(),
                SizedBox(height: 25),
                _buildQRandOrLabel("Or"),
                SizedBox(height: 25),
                Column(
                  children: <Widget>[
                    _buildPartnerNumField(),
                    SizedBox(height: 30),
                    _buildNextBtn()
                  ],
                ),
                SizedBox(height: 25),
              ],
            ),
          )),
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
            .copyWith(fontSize: 15, color: Color(0xffAD8D0B)),
      ),
    );
  }

  Widget _buildNextBtn() {
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
                  builder: (BuildContext context) => RedeemSummaryPage()));
        },
      ),
    );
  }

  Widget _buildPartnerNumField() {
    return Container(
      width: MediaQuery.of(context).size.width / 1.3,
      alignment: Alignment.center,
      child: TextField(
        textAlign: TextAlign.center,
        // controller: _purchaseController,
        decoration: InputDecoration(
            hintText: "Enter Partner Number",
            contentPadding: EdgeInsets.symmetric(vertical: 3)),
        maxLines: 1,
        keyboardType: TextInputType.number,
        onChanged: (String v) {
          print(v);
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

  /// Display the preview from the camera (or a message if the preview is not available).
  Widget _cameraPreviewWidget() {
    if (controller == null || !controller.value.isInitialized) {
      return const Text(
        'No camera selected',
        style: const TextStyle(
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
    showInSnackBar(value.toString());
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
      if (mounted) setState(() {});
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
