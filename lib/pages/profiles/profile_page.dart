import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

import 'package:flutter_spinkit/flutter_spinkit.dart';

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: ListView(
        children: <Widget>[
          Container(
            height: 210,
            color: Color(0xffAD8D0B),
            child: Column(
              children: <Widget>[
                GestureDetector(
                  onTap: () => Navigator.of(context).pop(),
                  child: Container(
                    padding: EdgeInsets.only(right: 5, top: 5),
                    alignment: Alignment.centerRight,
                    child: Icon(
                      Icons.keyboard_arrow_left,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                ),
                Column(
                  children: <Widget>[
                    Container(
                      width: 100,
                      height: 100.0,
                      child: CircleAvatar(
                        child: ClipOval(
                            child: CachedNetworkImage(
                          width: 200.0,
                          height: 200.0,
                          fit: BoxFit.cover,
                          placeholder: (context, url) => Center(
                                child: SpinKitFadingCube(
                                  color: Colors.white54,
                                  size: 10,
                                ),
                              ),
                          imageUrl: "http://via.placeholder.com/200x150",
                          errorWidget: (context, url, error) =>
                              new Icon(Icons.error),
                          fadeOutDuration: new Duration(seconds: 1),
                          fadeInDuration: new Duration(seconds: 3),
                          fadeInCurve: Curves.fastOutSlowIn,
                        )),
                      ),
                    ),
                    SizedBox(height: 15),
                    Text(
                      "Gino Furcy",
                      style: Theme.of(context)
                          .textTheme
                          .subhead
                          .copyWith(fontSize: 16, color: Colors.white),
                    ),
                    SizedBox(height: 3),
                    Text(
                      "ginofurcy@gmail.com",
                      style: Theme.of(context)
                          .textTheme
                          .subhead
                          .copyWith(fontSize: 13, color: Colors.white),
                    ),
                  ],
                ),
              ],
            ),
          ),
          _buildProfileLabel("My ID"),
          SizedBox(height: 10),
          _buildQRCode(),
          SizedBox(height: 10),
          _buildProfileLabel("Phone Number"),
          _buildPhoneNumber(),
          SizedBox(height: 10),
          _buildProfileLabel("Referrals"),
          _buildReferrals(),
          SizedBox(height: 25),
        ],
      )),
    );
  }

  Widget _buildPhoneNumber() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40),
      height: 40,
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20))),
        elevation: 2.0,
        color: Colors.white,
        child: Container(
          padding: EdgeInsets.only(top: 5),
          child: Text(
            "+1 993943949",
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .subtitle
                .copyWith(fontSize: 18, color: Colors.grey[500]),
          ),
        ),
      ),
    );
  }

  Widget _buildReferrals() {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 40),
      height: 40,
      child: Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(20),
                bottomRight: Radius.circular(20))),
        elevation: 2.0,
        color: Colors.white,
        child: Container(
          padding: EdgeInsets.only(top: 5),
          child: Text(
            "ABKADJADJWMCMMC",
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .subtitle
                .copyWith(fontSize: 18, color: Colors.grey[500]),
          ),
        ),
      ),
    );
  }

  Widget _buildQRCode() {
    return Container(
        child: Column(
      children: <Widget>[
        Image.asset(
          "assets/images/qrcode.jpg",
          height: 120,
          width: 120,
        ),
        SizedBox(height: 3),
        Text(
          "MPU00001",
          style: Theme.of(context).textTheme.caption.copyWith(fontSize: 16),
        )
      ],
    ));
  }

  Widget _buildProfileLabel(String label) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(height: 10),
            Text(
              label,
              style: Theme.of(context)
                  .textTheme
                  .title
                  .copyWith(fontSize: 16, color: Color(0xffAD8D0B)),
            ),
            SizedBox(height: 5),
            Container(
              height: 2.5,
              margin: EdgeInsets.symmetric(horizontal: 22),
              decoration: BoxDecoration(color: Colors.grey[300]),
            )
          ],
        ));
  }
}
