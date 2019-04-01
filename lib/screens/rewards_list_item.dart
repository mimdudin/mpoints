import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../pages/rewards_detail_page.dart';
import '../models/rewards.dart';

class RewardsListItem extends StatelessWidget {
  final Rewards reward;

  RewardsListItem(this.reward);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 190,
      margin: EdgeInsets.all(5), //8
      child: GestureDetector(
        child: Card(
          margin: EdgeInsets.zero,
          color: Colors.white,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5))),
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
                    child: ClipRRect(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(5)),
                      child: CachedNetworkImage(
                        imageUrl: reward.banner != null || reward.banner != ''
                            ? reward.banner
                            : '',
                        placeholder: (context, url) => new SpinKitThreeBounce(
                              color: Color(0xffAD8D0B),
                              size: 25,
                            ),
                        errorWidget: (context, url, error) =>
                            new Icon(Icons.error),
                        fadeOutDuration: new Duration(seconds: 1),
                        fadeInDuration: new Duration(seconds: 3),
                        fit: BoxFit.cover,
                        height: 120,
                        width: 200,
                      ),
                    )),
                SizedBox(height: 5),
                Container(
                    height: 34,
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      reward.name != null || reward.name != ''
                          ? reward.name
                          : 'Unknown',
                      style: TextStyle(
                          height: 1,
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: Color(0xffAD8D0B)),
                    )),
                SizedBox(height: 1),
                Container(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Text(
                      reward.rewardValue.toString() != null ||
                              reward.rewardValue.toString() != ''
                          ? reward.rewardValue.toString()
                          : '0.0',
                      style: Theme.of(context).textTheme.caption.copyWith(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: Color(0xffAD8D0B)),
                    )),
                SizedBox(height: 5),
              ],
            ),
          ),
        ),
        onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
                builder: (BuildContext context) => RewardsDetailPage())),
      ),
    );
  }
}
