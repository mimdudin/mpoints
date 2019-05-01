import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:rflutter_alert/rflutter_alert.dart';
import 'package:scoped_model/scoped_model.dart';

import './redeems/redeem_validation_page.dart';
import '../utils/strings.dart';
import '../utils/pallete.dart';
import '../models/rewards.dart';
import '../services/main_model.dart';
import '../utils/circular_loading.dart';

class RewardsDetailPage extends StatelessWidget {
  final Rewards reward;
  final int index;

  RewardsDetailPage({this.reward, this.index});

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (context, child, model) {
        return Scaffold(
          backgroundColor: Colors.grey[300],
          bottomNavigationBar: BottomAppBar(
            notchMargin: 0.0,
            elevation: 2.0,
            // hasNotch: false,
            color: Pallete.primary,
            child: _buildRedeemBottom(context, model),
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
                      _buildImgBanner(context),
                      // This gradient ensures that the toolbar icons are distinct
                      // against the background image.
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment(0.0, -1.0),
                            end: Alignment(0.0, -0.4),
                            colors: <Color>[
                              Color(0x60000000),
                              Color(0x00000000)
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SliverList(
                  delegate: SliverChildListDelegate([
                _buildRewardTitle(context),
                Container(
                  color: Colors.white,
                  margin: const EdgeInsets.symmetric(vertical: 4.0),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        Strings.summary,
                        style: Theme.of(context)
                            .textTheme
                            .title
                            .copyWith(fontSize: 16),
                      ),
                      SizedBox(height: 10),
                      _buildSumCategory(context),
                      SizedBox(height: 5),
                      _buildSumPartner(context),
                      // SizedBox(height: 5),
                      // _buildSumRewardValue(context),
                      SizedBox(height: 5),
                      _buildSumRewardCost(context),
                      SizedBox(height: 10),
                      _buildSumDesc(context),
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
                        Strings.contact,
                        style: Theme.of(context)
                            .textTheme
                            .title
                            .copyWith(fontSize: 16),
                      ),
                      SizedBox(height: 10),
                      _buildEmailContact(context),
                      SizedBox(height: 8),
                      _buildPhoneContact(context),
                      SizedBox(height: 8),
                      _buildFBcontact(context),
                      SizedBox(height: 8),
                      _buildWebContact(context),
                    ],
                  ),
                ),
              ]))
            ],
          ),
        );
      },
    );
  }

  Widget _buildImgBanner(BuildContext context) {
    return Container(
      // width: 200,
      // height: 200,
      child: CachedNetworkImage(
        width: 200.0,
        height: 200.0,
        fit: BoxFit.cover,
        placeholder: (context, url) => Center(
              child: LoadingCircular10(),
            ),
        imageUrl: reward?.banner ?? "",
        errorWidget: (context, url, error) => new Icon(Icons.error),
        fadeOutDuration: new Duration(seconds: 1),
        fadeInDuration: new Duration(seconds: 3),
        fadeInCurve: Curves.fastOutSlowIn,
      ),
    );
  }

  Widget _buildRedeemBottom(BuildContext context, MainModel model) {
    return InkWell(
      onTap: () {
        if (model.user.mpoints < reward.rewardCost) {
          _buildAlert(context);
        } else {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) =>
                      RedeemValidationPage(reward, index)));
        }
      },
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
              Strings.redeem,
              style: Theme.of(context)
                  .textTheme
                  .button
                  .copyWith(fontSize: 18, color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  // Alert with single button.
  _buildAlert(context) {
    Alert(
      context: context,
      type: AlertType.error,
      title: Strings.notEnoughMP,
      desc: Strings.notEnoughMPDesc,
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

  Widget _buildRewardTitle(BuildContext context) {
    return Container(
        color: Colors.white,
        padding: const EdgeInsets.all(16),
        margin: const EdgeInsets.only(bottom: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              reward?.name ?? "Unknown",
              style: Theme.of(context)
                  .textTheme
                  .title
                  .copyWith(fontSize: 20.0, color: Pallete.primary),
            ),

            Container(
              padding: EdgeInsets.all(5),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(50)),
                color: Colors.red,
              ),
              child: Text(
                "${reward?.discount}%" ?? "0%",
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
        ));
  }

  Widget _buildSumCategory(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              Strings.category,
              style: Theme.of(context).textTheme.caption.copyWith(fontSize: 14),
            ),
          ),
        ),
        Expanded(
          child: Text(
            reward?.category ?? "Unknown",
            style: Theme.of(context)
                .textTheme
                .subhead
                .copyWith(fontSize: 16, color: Color(0xffAD8D0B)),
          ),
        ),
      ],
    );
  }

  Widget _buildSumPartner(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              Strings.partnerName,
              style: Theme.of(context).textTheme.caption.copyWith(fontSize: 13),
            ),
          ),
        ),
        Expanded(
          child: Text(
            reward?.partnerName ?? "Unknown",
            style: Theme.of(context)
                .textTheme
                .subhead
                .copyWith(fontSize: 16, color: Pallete.primary),
          ),
        )
      ],
    );
  }

  // Widget _buildSumRewardValue(BuildContext context) {
  //   return Row(
  //     children: <Widget>[
  //       Expanded(
  //         child: Container(
  //           padding: EdgeInsets.symmetric(horizontal: 10),
  //           child: Text(
  //             Strings.rewardValue,
  //             style: Theme.of(context).textTheme.caption.copyWith(fontSize: 13),
  //           ),
  //         ),
  //       ),
  //       Expanded(
  //         child: Text(
  //           "\$${reward?.rewardValue}" ?? "\$0",
  //           style: Theme.of(context)
  //               .textTheme
  //               .subhead
  //               .copyWith(fontSize: 16, color: Pallete.primary),
  //         ),
  //       )
  //     ],
  //   );
  // }

  Widget _buildSumRewardCost(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child: Text(
              Strings.rewardCost,
              style: Theme.of(context).textTheme.caption.copyWith(fontSize: 13),
            ),
          ),
        ),
        Expanded(
          child: Text(
            "Mp. ${reward?.rewardCost}" ?? "Mp. 0",
            style: Theme.of(context)
                .textTheme
                .subhead
                .copyWith(fontSize: 16, color: Pallete.primary),
          ),
        )
      ],
    );
  }

  Widget _buildSumDesc(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Text(
            Strings.description,
            style: Theme.of(context).textTheme.title.copyWith(fontSize: 14),
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
    );
  }

  Widget _buildEmailContact(BuildContext context) {
    return Row(
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
          reward?.email ?? "owner@email.com",
          style: Theme.of(context)
              .textTheme
              .subhead
              .copyWith(fontSize: 16, color: Pallete.primary),
        ),
      ],
    );
  }

  Widget _buildPhoneContact(BuildContext context) {
    return Row(
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
          reward?.phoneNumber ?? "+1 23456789",
          style: Theme.of(context)
              .textTheme
              .subhead
              .copyWith(fontSize: 16, color: Pallete.primary),
        ),
      ],
    );
  }

  Widget _buildFBcontact(BuildContext context) {
    return Row(
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
          reward?.facebook ?? "Unknown",
          style: Theme.of(context)
              .textTheme
              .subhead
              .copyWith(fontSize: 16, color: Pallete.primary),
        )
      ],
    );
  }

  Widget _buildWebContact(BuildContext context) {
    return Row(
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
          reward?.website ?? "www.example.com",
          style: Theme.of(context)
              .textTheme
              .subhead
              .copyWith(fontSize: 16, color: Pallete.primary),
        ),
      ],
    );
  }
}
