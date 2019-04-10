import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:scoped_model/scoped_model.dart';

import '../services/main_model.dart';
import '../screens/rewards_list_item.dart';
import '../utils/pallete.dart';
import '../utils/circular_loading.dart';
import '../utils/strings.dart';
import '../models/partners.dart';

class PartnersDetailPage extends StatelessWidget {
  final Partners partner;

  PartnersDetailPage(this.partner);

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (context, child, model) {
        return Scaffold(
          backgroundColor: Colors.grey[300],
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
                      // Image.asset(
                      //   'assets/images/acer.jpg',
                      //   // height: 200,
                      //   fit: BoxFit.cover,
                      // ),
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
                _buildRewardName(context),
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
                Container(
                  color: Colors.white,
                  margin: const EdgeInsets.symmetric(vertical: 4.0),
                  padding: EdgeInsets.symmetric(vertical: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin: EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          Strings.partnerRewards,
                          style: Theme.of(context)
                              .textTheme
                              .title
                              .copyWith(fontSize: 16),
                        ),
                      ),
                      SizedBox(height: 10),
                      Container(
                        child: model.rewardList
                                    .where((reward) =>
                                        reward.partnerName == partner.name)
                                    .toList()
                                    .length ==
                                0
                            ? Center(
                                child: Text("No rewards library found."),
                              )
                            : GridView.builder(
                                shrinkWrap: true,
                                itemCount: model.rewardList
                                            .where((reward) =>
                                                reward.partnerName ==
                                                partner.name)
                                            .toList() ==
                                        null
                                    ? 0
                                    : model.rewardList
                                        .where((reward) =>
                                            reward.partnerName == partner.name)
                                        .toList()
                                        .length,
                                // shrinkWrap: true,
                                physics: ClampingScrollPhysics(),
                                scrollDirection: Axis.vertical,
                                padding: EdgeInsets.symmetric(horizontal: 3),
                                // itemExtent: 10.0,
                                // reverse: true, //makes the list appear in descending order
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 2),
                                itemBuilder: (context, i) {
                                  var reward = model.rewardList
                                      .where((reward) =>
                                          reward.partnerName == partner.name)
                                      .toList()[i];
                                  return RewardsListItem(reward, i);
                                }),
                      )
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
        imageUrl: partner?.logo ?? "",
        errorWidget: (context, url, error) => new Icon(Icons.error),
        fadeOutDuration: new Duration(seconds: 1),
        fadeInDuration: new Duration(seconds: 3),
        fadeInCurve: Curves.fastOutSlowIn,
      ),
    );
  }

  Widget _buildRewardName(BuildContext context) {
    return Container(
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
                  partner?.name ?? "Unknown",
                  style: Theme.of(context)
                      .textTheme
                      .title
                      .copyWith(fontSize: 20.0, color: Pallete.primary),
                ),
                SizedBox(height: 5),
                Text(partner?.category ?? "Unknown",
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
        ));
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
          partner?.email ?? "example@gmail.com",
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
          partner?.phoneNumber ?? "+1 23456789",
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
          partner?.facebook ?? "Unknown",
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
          partner?.website ?? "www.example.com",
          style: Theme.of(context)
              .textTheme
              .subhead
              .copyWith(fontSize: 16, color: Pallete.primary),
        ),
      ],
    );
  }
}
