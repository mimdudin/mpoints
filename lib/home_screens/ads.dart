import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

import '../services/ads_service.dart';
import '../utils/circular_loading.dart';
import '../services/main_model.dart';

class Ads extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (context, child, model) {
        return GestureDetector(
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            height: 60,
            // color: Colors.grey,
            child: CachedNetworkImage(
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              placeholder: (context, url) => Center(
                    child: LoadingCircular25(),
                  ),
              imageUrl: model.ads?.banner ?? "",
              errorWidget: (context, url, error) => new Icon(Icons.error),
              fadeOutDuration: new Duration(seconds: 1),
              fadeInDuration: new Duration(seconds: 3),
              fadeInCurve: Curves.fastOutSlowIn,
            ),
            //         Image.network(
            //   model.ads.banner ?? "",
            //   height: 70,
            //   fit: BoxFit.cover,
            // )
          ),
          onTap: () => _launchURL(model.ads?.url),
        );
      },
    );
  }

  void _launchURL(String urlAds) async {
    String url = urlAds;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }
}
