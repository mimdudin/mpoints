import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:scoped_model/scoped_model.dart';

import '../home_screens/news_slider.dart';
import '../services/main_model.dart';
import '../home_screens/rewards_listview.dart';
import '../home_screens/partner_listview.dart';
import '../utils/rewards_loading.dart';
import '../utils/partners_loading.dart';
import '../pages/partners_library_page.dart';
import '../pages/rewards_library_page.dart';
import '../utils/circular_loading.dart';
import '../utils/strings.dart';
import '../utils/pallete.dart';
// import '../home_screens/ads.dart';
import '../home_screens/ads_slider.dart';

class HomeFragment extends StatefulWidget {
  @override
  _HomeFragmentState createState() => _HomeFragmentState();
}

class _HomeFragmentState extends State<HomeFragment> {
  // @override
  // void initState() {
  //   super.initState();

  //   // loadData();
  // }

  // Future loadData() async {
  //   await Future.wait([
  //     widget.model.fetchRewardList(),
  //     widget.model.fetchPartnerList(),
  //   ]);
  // }

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (context, child, model) {
        return Container(
          // color: Colors.red,
          child: ListView(
            physics: !model.isLoadingAds &&
                    !model.isLoadingNews &&
                    !model.isLoadingPartnerList &&
                    !model.isLoadingrewardList &&
                    !model.isLoadingUser
                ? ClampingScrollPhysics()
                : NeverScrollableScrollPhysics(),
            children: <Widget>[
              Stack(
                alignment: Alignment.topCenter,
                children: <Widget>[
                  Container(
                    height: 150,
                    color: Pallete.primary,
                  ),
                  _buildImageProfile(model),
                  _buildCharityDatePoints(model),
                  _buildMPoints(model),
                ],
              ),
              SizedBox(height: 15),
              _buildNewsLabel(),
              SizedBox(height: 10),
              Container(
                height: 170,
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: model.isLoadingNews ? LoadingCircular25() : NewsSlider(),
              ),
              SizedBox(height: 15),
              _buildRewardsLabel(),
              SizedBox(height: 7),
              Container(
                  height: 195,
                  child: model.isLoadingrewardList
                      ? RewardsLoading()
                      : RewardsListView()),
              SizedBox(height: 15),
              _buildPartnersLabel(),
              SizedBox(height: 8),
              Container(
                  height: 160,
                  child: model.isLoadingPartnerList
                      ? PartnersLoading()
                      : PartnerListView()),
              SizedBox(height: 15),
              _buildAdsLabel(),
              SizedBox(height: 10),
              // Container(
              //     margin: EdgeInsets.symmetric(horizontal: 10),
              //     height: 60,
              //     child: model.isLoadingAds ? LoadingCircular25() : Ads()),
              Container(
                height: 60,
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: model.isLoadingNews ? LoadingCircular25() : AdsSlider(),
              ),
              SizedBox(height: 15),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCharityDatePoints(MainModel model) {
    return Container(
      margin: EdgeInsets.only(top: 140),
      height: 40,
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Container(
              padding: EdgeInsets.only(left: 15),
              child: Row(
                children: <Widget>[
                  Icon(
                    FontAwesomeIcons.handHoldingHeart,
                    color: Pallete.primary,
                  ),
                  SizedBox(width: 10),
                  Text(
                    model.isLoadingUser
                        ? '...'
                        : model.user == null || model.user.mpoints == 0.1
                            ? "0"
                            : "${model.format(model.user.socialPoints)}",
                    style: Theme.of(context)
                        .textTheme
                        .subhead
                        .copyWith(fontSize: 16, color: Pallete.primary),
                  )
                ],
              )),
          Container(
              padding: EdgeInsets.only(right: 15),
              child: Row(
                children: <Widget>[
                  Icon(
                    FontAwesomeIcons.calendar,
                    color: Pallete.primary,
                  ),
                  SizedBox(width: 10),
                  Text(
                    model.isLoadingUser
                        ? '...'
                        : model.user == null || model.user.mpoints == 0.1
                            ? "0"
                            : "${model.format(model.user.mpoints)}",
                    style: Theme.of(context)
                        .textTheme
                        .subhead
                        .copyWith(fontSize: 16, color: Pallete.primary),
                  )
                ],
              )),
        ],
      ),
    );
  }

  Widget _buildMPoints(MainModel model) {
    return Container(
      margin: EdgeInsets.only(top: 105),
      height: 60,
      width: 130,
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[200]),
        color: Colors.white,
        borderRadius: BorderRadius.all(Radius.circular(100)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 4.0, // has the effect of softening the shadow
            spreadRadius: 2.0, // has the effect of extending the shadow
            // offset: Offset(
            //   2.0, // horizontal, move right
            //   2.0, // vertical, move down 10
            // ),
          )
        ],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(
            Strings.mpAvailable,
            style: Theme.of(context)
                .textTheme
                .subhead
                .copyWith(fontSize: 14, color: Pallete.primary),
          ),
          Text(
            model.isLoadingUser
                ? '...'
                : model.user == null || model.user.mpoints == 0.1
                    ? "0"
                    : "${model.format(model.user.mpoints)}",
            style: Theme.of(context)
                .textTheme
                .title
                .copyWith(fontSize: 20, color: Pallete.primary),
          ),
        ],
      ),
    );
  }

  Widget _buildImageProfile(MainModel model) {
    return Container(
      width: 80,
      height: 80,
      child: CircleAvatar(
        child: ClipOval(
            child: CachedNetworkImage(
          width: 200.0,
          height: 200.0,
          fit: BoxFit.cover,
          placeholder: (context, url) => Center(
                child: LoadingCircular10(),
              ),
          imageUrl: model.user?.photo ?? "http://via.placeholder.com/200x150",
          errorWidget: (context, url, error) => new Icon(Icons.error),
          fadeOutDuration: new Duration(seconds: 1),
          fadeInDuration: new Duration(seconds: 3),
          fadeInCurve: Curves.fastOutSlowIn,
        )),
      ),
    );
  }

  Widget _buildNewsLabel() {
    return Container(
        margin: EdgeInsets.only(left: 10, right: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              Strings.latestNews,
              style: Theme.of(context).textTheme.subhead.copyWith(
                  fontSize: 14,
                  color: Pallete.primary,
                  fontWeight: FontWeight.w400),
            ),
            Container()
            // Text(
            //   Strings.viewAll,
            //   style: Theme.of(context).textTheme.subhead.copyWith(
            //       fontSize: 14,
            //       color: Pallete.primary,
            //       fontWeight: FontWeight.w400),
            // ),
          ],
        ));
  }

  Widget _buildRewardsLabel() {
    return Container(
        margin: EdgeInsets.only(left: 10, right: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              Strings.rewards,
              style: Theme.of(context).textTheme.subhead.copyWith(
                  fontSize: 14,
                  color: Pallete.primary,
                  fontWeight: FontWeight.w400),
            ),
            GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            RewardsLibraryPage())),
                child: Text(
                  Strings.viewAll,
                  style: Theme.of(context).textTheme.subhead.copyWith(
                      fontSize: 14,
                      color: Pallete.primary,
                      fontWeight: FontWeight.w400),
                )),
          ],
        ));
  }

  Widget _buildPartnersLabel() {
    return Container(
        margin: EdgeInsets.only(left: 10, right: 15),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Text(
              Strings.partners,
              style: Theme.of(context).textTheme.subhead.copyWith(
                  fontSize: 14,
                  color: Pallete.primary,
                  fontWeight: FontWeight.w400),
            ),
            GestureDetector(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (BuildContext context) =>
                            PartnersLibraryPage())),
                child: Text(
                  Strings.viewAll,
                  style: Theme.of(context).textTheme.subhead.copyWith(
                      fontSize: 14,
                      color: Pallete.primary,
                      fontWeight: FontWeight.w400),
                )),
          ],
        ));
  }

  Widget _buildAdsLabel() {
    return Container(
        margin: EdgeInsets.only(left: 10, right: 15),
        child: Text(Strings.ads,
            style: Theme.of(context).textTheme.subhead.copyWith(
                fontSize: 14,
                color: Pallete.primary,
                fontWeight: FontWeight.w400)));
  }

  // Widget _buildAds() {
  //   return Container(
  //     margin: EdgeInsets.symmetric(horizontal: 10),
  //     height: 60,
  //     color: Colors.grey,
  //   );
  // }
}
