import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class PartnersDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      // bottomNavigationBar: Container(
      //   color: Theme.of(context).primaryColor,
      //   child: Row(
      //     children: <Widget>[
      //        Expanded(
      //          child: Builder(
      //            builder: (context) => FlatButton.icon(
      //              onPressed: () {
      //                _launchURL(context, property.listerUrl);
      //              },
      //              icon: Icon(Icons.launch),
      //              label: Text("Visit Listing"),
      //              textColor: Colors.white,
      //            ),
      //          ),
      //        ),
      //     ],
      //   ),
      // ),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            floating: false,
            expandedHeight: 256,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: <Widget>[
                  Image.asset(
                    'assets/images/acer.jpg',
                    // height: 200,
                    fit: BoxFit.cover,
                  ),
                  // This gradient ensures that the toolbar icons are distinct
                  // against the background image.
                  const DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment(0.0, -1.0),
                        end: Alignment(0.0, -0.4),
                        colors: <Color>[Color(0x60000000), Color(0x00000000)],
                      ),
                    ),
                  ),
                  // Positioned(
                  //   bottom: 20,
                  //   left: 0,
                  //   child: Container(
                  //     padding: const EdgeInsets.symmetric(
                  //         vertical: 8, horizontal: 16),
                  //     color: Color.fromRGBO(255, 255, 255, 0.5),
                  //     child: Row(
                  //       children: <Widget>[
                  //         Padding(
                  //           padding: const EdgeInsets.only(right: 8.0),
                  //           child: Icon(
                  //             FontAwesomeIcons.tag,
                  //             size: 20,
                  //             color: Theme.of(context).accentColor,
                  //           ),
                  //         ),
                  //         Text(
                  //           property.priceFormatted,
                  //           style: Theme.of(context).textTheme.title,
                  //         )
                  //       ],
                  //     ),
                  //   ),
                  // ),
                ],
              ),
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            Container(
                color: Colors.white,
                padding: const EdgeInsets.all(16),
                margin: const EdgeInsets.only(bottom: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          "21 Theatreecal",
                          style: Theme.of(context).textTheme.title.copyWith(
                              fontSize: 20.0, color: Color(0xffAD8D0B)),
                        ),
                        SizedBox(height: 5),
                        Text("XXI Organizations",
                            style: Theme.of(context)
                                .textTheme
                                .caption
                                .copyWith(fontSize: 13))
                      ],
                    ),
                    Icon(
                      Icons.check_circle,
                      color: Colors.blueAccent,
                    )
                  ],
                )),
            Container(
              color: Colors.white,
              margin: const EdgeInsets.symmetric(vertical: 4.0),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Contact",
                    style: Theme.of(context)
                        .textTheme
                        .title
                        .copyWith(fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: <Widget>[
                      Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child:
                              // Text(
                              //   "Email:",
                              //   style: Theme.of(context)
                              //       .textTheme
                              //       .caption
                              //       .copyWith(fontSize: 14),
                              // ),
                              Icon(
                            Icons.email,
                            color: Colors.grey,
                            size: 16,
                          )),
                      SizedBox(width: 10),
                      Text(
                        "theatree@gmail.com",
                        style: Theme.of(context)
                            .textTheme
                            .subhead
                            .copyWith(fontSize: 16, color: Color(0xffAD8D0B)),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: <Widget>[
                      Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child:
                              // Text(
                              //   "Phone Number:",
                              //   style: Theme.of(context)
                              //       .textTheme
                              //       .caption
                              //       .copyWith(fontSize: 13),
                              // ),
                              Icon(
                            FontAwesomeIcons.phone,
                            color: Colors.grey,
                            size: 16,
                          )),
                      SizedBox(width: 10),
                      Text(
                        "+1 43424242",
                        style: Theme.of(context)
                            .textTheme
                            .subhead
                            .copyWith(fontSize: 16, color: Color(0xffAD8D0B)),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: <Widget>[
                      Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child:
                              // Text(
                              //   "Facebook:",
                              //   style: Theme.of(context)
                              //       .textTheme
                              //       .caption
                              //       .copyWith(fontSize: 13),
                              // ),
                              Icon(
                            FontAwesomeIcons.facebookF,
                            color: Colors.grey,
                            size: 16,
                          )),
                      SizedBox(width: 10),
                      Text(
                        "21 Theatreecal",
                        style: Theme.of(context)
                            .textTheme
                            .subhead
                            .copyWith(fontSize: 16, color: Color(0xffAD8D0B)),
                      )
                    ],
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: <Widget>[
                      Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child:
                              // Text(
                              //   "Website:",
                              //   style: Theme.of(context)
                              //       .textTheme
                              //       .caption
                              //       .copyWith(fontSize: 13),
                              // ),
                              Icon(
                            Icons.language,
                            color: Colors.grey,
                            size: 16,
                          )),
                      SizedBox(width: 10),
                      Text(
                        "www.theatreecal.com",
                        style: Theme.of(context)
                            .textTheme
                            .subhead
                            .copyWith(fontSize: 16, color: Color(0xffAD8D0B)),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              color: Colors.white,
              margin: const EdgeInsets.symmetric(vertical: 4.0),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    "Partner Rewards",
                    style: Theme.of(context)
                        .textTheme
                        .title
                        .copyWith(fontSize: 16),
                  ),
                  SizedBox(height: 15),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          height: 190,
                          margin: EdgeInsets.symmetric(horizontal: 8),
                          child: GestureDetector(
                            child: Card(
                              margin: EdgeInsets.zero,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              elevation: 2.0,
                              child: Container(
                                height: 190,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(5),
                                        bottomRight: Radius.circular(5))),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(5),
                                              topRight: Radius.circular(5)),
                                        ),
                                        height: 120,
                                        width: 200,
                                        child: Image.asset(
                                          "assets/images/products.png",
                                          fit: BoxFit.cover,
                                          height: 120,
                                          width: 200,
                                        )
                                        // child: ClipRRect(
                                        //   borderRadius:
                                        //       BorderRadius.vertical(top: Radius.circular(5)),
                                        //   child: CachedNetworkImage(
                                        //     imageUrl: reward.banner != null || reward.banner != ''
                                        //         ? reward.banner
                                        //         : '',
                                        //     placeholder: (context, url) => new SpinKitThreeBounce(
                                        //           color: Color(0xffAD8D0B),
                                        //           size: 25,
                                        //         ),
                                        //     errorWidget: (context, url, error) =>
                                        //         new Icon(Icons.error),
                                        //     fadeOutDuration: new Duration(seconds: 1),
                                        //     fadeInDuration: new Duration(seconds: 3),
                                        //     fit: BoxFit.cover,
                                        //     height: 120,
                                        //     width: 200,
                                        //   ),
                                        // )
                                        ),
                                    SizedBox(height: 5),
                                    Container(
                                        height: 34,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Text(
                                          // reward.name != null || reward.name != ''
                                          //     ? reward.name
                                          //     : 'Unknown',
                                          "Coupun XXI",
                                          style: TextStyle(
                                              height: 1,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xffAD8D0B)),
                                        )),
                                    SizedBox(height: 1),
                                    Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Text(
                                          // reward.rewardValue.toString() != null ||
                                          //         reward.rewardValue.toString() != ''
                                          //     ? reward.rewardValue.toString()
                                          //     : '0.0',
                                          "\$4343433",
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption
                                              .copyWith(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                  color: Color(0xffAD8D0B)),
                                        )),
                                    SizedBox(height: 5),
                                  ],
                                ),
                              ),
                            ),
                            // onTap: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => RewardsDetailPage())),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 190,
                          margin: EdgeInsets.symmetric(horizontal: 8),
                          child: GestureDetector(
                            child: Card(
                              margin: EdgeInsets.zero,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              elevation: 2.0,
                              child: Container(
                                height: 190,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(5),
                                        bottomRight: Radius.circular(5))),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(5),
                                              topRight: Radius.circular(5)),
                                        ),
                                        height: 120,
                                        width: 200,
                                        child: Image.asset(
                                          "assets/images/products.png",
                                          fit: BoxFit.cover,
                                          height: 120,
                                          width: 200,
                                        )
                                        // child: ClipRRect(
                                        //   borderRadius:
                                        //       BorderRadius.vertical(top: Radius.circular(5)),
                                        //   child: CachedNetworkImage(
                                        //     imageUrl: reward.banner != null || reward.banner != ''
                                        //         ? reward.banner
                                        //         : '',
                                        //     placeholder: (context, url) => new SpinKitThreeBounce(
                                        //           color: Color(0xffAD8D0B),
                                        //           size: 25,
                                        //         ),
                                        //     errorWidget: (context, url, error) =>
                                        //         new Icon(Icons.error),
                                        //     fadeOutDuration: new Duration(seconds: 1),
                                        //     fadeInDuration: new Duration(seconds: 3),
                                        //     fit: BoxFit.cover,
                                        //     height: 120,
                                        //     width: 200,
                                        //   ),
                                        // )
                                        ),
                                    SizedBox(height: 5),
                                    Container(
                                        height: 34,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Text(
                                          // reward.name != null || reward.name != ''
                                          //     ? reward.name
                                          //     : 'Unknown',
                                          "Coupun XXI",
                                          style: TextStyle(
                                              height: 1,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xffAD8D0B)),
                                        )),
                                    SizedBox(height: 1),
                                    Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Text(
                                          // reward.rewardValue.toString() != null ||
                                          //         reward.rewardValue.toString() != ''
                                          //     ? reward.rewardValue.toString()
                                          //     : '0.0',
                                          "\$4343433",
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption
                                              .copyWith(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                  color: Color(0xffAD8D0B)),
                                        )),
                                    SizedBox(height: 5),
                                  ],
                                ),
                              ),
                            ),
                            // onTap: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => RewardsDetailPage())),
                          ),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          height: 190,
                          margin: EdgeInsets.symmetric(horizontal: 8),
                          child: GestureDetector(
                            child: Card(
                              margin: EdgeInsets.zero,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              elevation: 2.0,
                              child: Container(
                                height: 190,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(5),
                                        bottomRight: Radius.circular(5))),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(5),
                                              topRight: Radius.circular(5)),
                                        ),
                                        height: 120,
                                        width: 200,
                                        child: Image.asset(
                                          "assets/images/products.png",
                                          fit: BoxFit.cover,
                                          height: 120,
                                          width: 200,
                                        )
                                        // child: ClipRRect(
                                        //   borderRadius:
                                        //       BorderRadius.vertical(top: Radius.circular(5)),
                                        //   child: CachedNetworkImage(
                                        //     imageUrl: reward.banner != null || reward.banner != ''
                                        //         ? reward.banner
                                        //         : '',
                                        //     placeholder: (context, url) => new SpinKitThreeBounce(
                                        //           color: Color(0xffAD8D0B),
                                        //           size: 25,
                                        //         ),
                                        //     errorWidget: (context, url, error) =>
                                        //         new Icon(Icons.error),
                                        //     fadeOutDuration: new Duration(seconds: 1),
                                        //     fadeInDuration: new Duration(seconds: 3),
                                        //     fit: BoxFit.cover,
                                        //     height: 120,
                                        //     width: 200,
                                        //   ),
                                        // )
                                        ),
                                    SizedBox(height: 5),
                                    Container(
                                        height: 34,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Text(
                                          // reward.name != null || reward.name != ''
                                          //     ? reward.name
                                          //     : 'Unknown',
                                          "Coupun XXI",
                                          style: TextStyle(
                                              height: 1,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xffAD8D0B)),
                                        )),
                                    SizedBox(height: 1),
                                    Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Text(
                                          // reward.rewardValue.toString() != null ||
                                          //         reward.rewardValue.toString() != ''
                                          //     ? reward.rewardValue.toString()
                                          //     : '0.0',
                                          "\$4343433",
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption
                                              .copyWith(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                  color: Color(0xffAD8D0B)),
                                        )),
                                    SizedBox(height: 5),
                                  ],
                                ),
                              ),
                            ),
                            // onTap: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => RewardsDetailPage())),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Container(
                          height: 190,
                          margin: EdgeInsets.symmetric(horizontal: 8),
                          child: GestureDetector(
                            child: Card(
                              margin: EdgeInsets.zero,
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5))),
                              elevation: 2.0,
                              child: Container(
                                height: 190,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.only(
                                        bottomLeft: Radius.circular(5),
                                        bottomRight: Radius.circular(5))),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Container(
                                        decoration: BoxDecoration(
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(5),
                                              topRight: Radius.circular(5)),
                                        ),
                                        height: 120,
                                        width: 200,
                                        child: Image.asset(
                                          "assets/images/products.png",
                                          fit: BoxFit.cover,
                                          height: 120,
                                          width: 200,
                                        )
                                        // child: ClipRRect(
                                        //   borderRadius:
                                        //       BorderRadius.vertical(top: Radius.circular(5)),
                                        //   child: CachedNetworkImage(
                                        //     imageUrl: reward.banner != null || reward.banner != ''
                                        //         ? reward.banner
                                        //         : '',
                                        //     placeholder: (context, url) => new SpinKitThreeBounce(
                                        //           color: Color(0xffAD8D0B),
                                        //           size: 25,
                                        //         ),
                                        //     errorWidget: (context, url, error) =>
                                        //         new Icon(Icons.error),
                                        //     fadeOutDuration: new Duration(seconds: 1),
                                        //     fadeInDuration: new Duration(seconds: 3),
                                        //     fit: BoxFit.cover,
                                        //     height: 120,
                                        //     width: 200,
                                        //   ),
                                        // )
                                        ),
                                    SizedBox(height: 5),
                                    Container(
                                        height: 34,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Text(
                                          // reward.name != null || reward.name != ''
                                          //     ? reward.name
                                          //     : 'Unknown',
                                          "Coupun XXI",
                                          style: TextStyle(
                                              height: 1,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w500,
                                              color: Color(0xffAD8D0B)),
                                        )),
                                    SizedBox(height: 1),
                                    Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: Text(
                                          // reward.rewardValue.toString() != null ||
                                          //         reward.rewardValue.toString() != ''
                                          //     ? reward.rewardValue.toString()
                                          //     : '0.0',
                                          "\$4343433",
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption
                                              .copyWith(
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w400,
                                                  color: Color(0xffAD8D0B)),
                                        )),
                                    SizedBox(height: 5),
                                  ],
                                ),
                              ),
                            ),
                            // onTap: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => RewardsDetailPage())),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          ]))
        ],
      ),
    );
  }
}
