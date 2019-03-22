import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import './redeem_rewards_page.dart';

class RewardsDetailPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[300],
      bottomNavigationBar: BottomAppBar(
          notchMargin: 0.0,
          elevation: 2.0,
          // hasNotch: false,
          color: Color(0xffAD8D0B),
          child:
              //  new Row(
              //   mainAxisSize: MainAxisSize.max,
              //   children: <Widget>[
              // Expanded(child: InkWell(
              //   onTap: (){},
              //   child: Container(
              //     height: 50,
              //     alignment: Alignment.center,
              //     child: Text("CANCEL", style: Theme.of(context).textTheme.button.copyWith(
              //       fontSize: 18, color: Colors.white
              //     ),),
              //   ),
              // )),
              // Container(color: Colors.black12, height: 50, width: 3,),

              //   IconButton(icon)
              //  Expanded(child: InkWell(
              //     onTap: (){},
              //     child: Container(
              //       height: 50,
              //       alignment: Alignment.center,
              //       child: Text("REEDEM", style: Theme.of(context).textTheme.button.copyWith(
              //         fontSize: 18, color: Colors.white
              //       ),),
              //     ),
              //   )),
              InkWell(
            onTap: () => Navigator.push(context, MaterialPageRoute(builder: (BuildContext context) => RedeemRewardsPage())),
            // alignment: Alignment.center,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(
                  Icons.redeem,
                  color: Colors.white,
                ),
                SizedBox(width: 10),
                Container(
                  padding: EdgeInsets.only(top: 3),
                  height: 50,
                  alignment: Alignment.center,
                  child: Text(
                    "REEDEM",
                    style: Theme.of(context)
                        .textTheme
                        .button
                        .copyWith(fontSize: 18, color: Colors.white),
                  ),
                ),
              ],
            ),
          )
          // ],
          // ),
          ),
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
                    'assets/images/products.png',
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
                    Text(
                      "Coupun XXI",
                      style: Theme.of(context)
                          .textTheme
                          .title
                          .copyWith(fontSize: 20.0, color: Color(0xffAD8D0B)),
                    ),

                    Container(
                      padding: EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        color: Colors.red,
                      ),
                      child: Text(
                        "50% OFF",
                        style: Theme.of(context)
                            .textTheme
                            .title
                            .copyWith(fontSize: 14, color: Colors.white),
                      ),
                    )
                    // Icon(
                    //   Icons.check_circle,
                    //   color: Colors.blueAccent,
                    // )
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
                    "Summary",
                    style: Theme.of(context)
                        .textTheme
                        .title
                        .copyWith(fontSize: 16),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            "Category:",
                            style: Theme.of(context)
                                .textTheme
                                .caption
                                .copyWith(fontSize: 14),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "Theatre",
                          style: Theme.of(context)
                              .textTheme
                              .subhead
                              .copyWith(fontSize: 16, color: Color(0xffAD8D0B)),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            "Partner Name:",
                            style: Theme.of(context)
                                .textTheme
                                .caption
                                .copyWith(fontSize: 13),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "21 Theatreecal",
                          style: Theme.of(context)
                              .textTheme
                              .subhead
                              .copyWith(fontSize: 16, color: Color(0xffAD8D0B)),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            "Reward Value:",
                            style: Theme.of(context)
                                .textTheme
                                .caption
                                .copyWith(fontSize: 13),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "\$3424242",
                          style: Theme.of(context)
                              .textTheme
                              .subhead
                              .copyWith(fontSize: 16, color: Color(0xffAD8D0B)),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 5),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            "Reward Cost:",
                            style: Theme.of(context)
                                .textTheme
                                .caption
                                .copyWith(fontSize: 13),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Text(
                          "Mp. 4333",
                          style: Theme.of(context)
                              .textTheme
                              .subhead
                              .copyWith(fontSize: 16, color: Color(0xffAD8D0B)),
                        ),
                      )
                    ],
                  ),
                  SizedBox(height: 10),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          "Description:",
                          style: Theme.of(context)
                              .textTheme
                              .title
                              .copyWith(fontSize: 14),
                        ),
                      ),
                      SizedBox(height: 7),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 18),
                        child: Text(
                          "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more.",
                          style: Theme.of(context)
                              .textTheme
                              .caption
                              .copyWith(fontSize: 14, height: 1.2),
                        ),
                      ),
                    ],
                  )
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
          ]))
        ],
      ),
    );
  }
}
