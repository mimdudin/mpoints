import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:typed_data';
import 'dart:ui' as ui;
import 'dart:math' as Math;
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:image_gallery_saver/image_gallery_saver.dart';

import '../../utils/strings.dart';

class ClaimSuccessPage extends StatefulWidget {
  final claim;

  ClaimSuccessPage(this.claim);

  @override
  _ClaimSuccessPageState createState() => _ClaimSuccessPageState();
}

class _ClaimSuccessPageState extends State<ClaimSuccessPage> {
  static GlobalKey _globalKey = new GlobalKey();

  @override
  void initState() {
    super.initState();
    PermissionHandler().requestPermissions([PermissionGroup.storage]);
    // PermissionHandler().requestPermissions(<PermissionGroup>[
    //   PermissionGroup.storage, // 在这里添加需要的权限
    // ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            child: RepaintBoundary(
                key: _globalKey,
                child: ListView(
                  children: <Widget>[
                    SizedBox(height: 20),
                    _buildLogo(),
                    SizedBox(height: 40),
                    Column(
                      children: <Widget>[
                        _buildSuccessIcon(),
                        SizedBox(height: 40),
                        _buildSomeText("Congratulations!!!", 24),
                        SizedBox(height: 10),
                        _buildSomeText("You got ${widget.claim} Mpoints.", 14),
                        SizedBox(height: 120),
                        _buildHomeCaptureBtn(),
                        SizedBox(height: 25),
                      ],
                    )
                  ],
                ))));
  }

  Widget _buildSuccessIcon() {
    return Container(
        child: Image.asset(
      'assets/icons/success.png',
      height: 150,
      color: Colors.grey[350],
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
        "assets/images/logo/logo_v1.png",
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildHomeCaptureBtn() {
    return Container(
      alignment: Alignment.centerLeft,
      margin: EdgeInsets.symmetric(horizontal: 30),
      height: 40,
      decoration:
          BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(8))),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 118,
            child: RaisedButton.icon(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(8))),
                label: Container(
                  padding: EdgeInsets.only(bottom: 4),
                  child:  Image.asset('assets/icons/Home.png', height: 25),),
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
          // SizedBox(width: 30),
          // Container(
          //   height: 40,
          //   decoration: BoxDecoration(
          //       borderRadius: BorderRadius.all(Radius.circular(100))),
          //   child: RaisedButton.icon(
          //     shape: RoundedRectangleBorder(
          //         borderRadius: BorderRadius.all(Radius.circular(100))),
          //     icon: Icon(
          //       Icons.camera_alt,
          //       color: Colors.white,
          //     ),
          //     label: Text(
          //       "Photo",
          //       style: Theme.of(context)
          //           .textTheme
          //           .button
          //           .copyWith(fontSize: 16, color: Colors.white),
          //     ),
          //     color: Color(0xffAD8D0B),
          //     onPressed: screenShot,
          //   ),
          // )
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

  screenShot() async {
    RenderRepaintBoundary boundary =
        _globalKey.currentContext.findRenderObject();
    ui.Image image = await boundary.toImage();
    ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    final result = await ImageGallerySaver.save(byteData.buffer.asUint8List());
    print(result);
    // var filePath = await ImagePickerSaver.saveFile(
    //     fileData: byteData.buffer.asUint8List());
    // print(filePath);
  }

  // takeScreenShot() async {
  //   int rand = new Math.Random().nextInt(10000);
  //   RenderRepaintBoundary boundary =
  //       previewContainer.currentContext.findRenderObject();
  //   ui.Image image = await boundary.toImage();
  //   final directory = (await getApplicationDocumentsDirectory()).path;
  //   ByteData byteData = await image.toByteData(format: ui.ImageByteFormat.png);
  //   Uint8List pngBytes = byteData.buffer.asUint8List();
  //   print(pngBytes);

  //   File imgFile = new File('$directory/Mp_$rand.png');
  //   imgFile.writeAsBytes(pngBytes);
  // }
}
