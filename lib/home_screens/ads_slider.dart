import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/circular_loading.dart';
import '../utils/pallete.dart';
import '../services/main_model.dart';

class AdsSlider extends StatefulWidget {
  @override
  _AdsSliderState createState() => _AdsSliderState();
}

class _AdsSliderState extends State<AdsSlider> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (context, child, model) {
        return model.adsList == null || model.adsList.length == 0
            ? LoadingCircular25()
            : Stack(children: [
                CarouselSlider(
                  items: model.adsList.map((i) {
                    return GestureDetector(
                        onTap: () => _launchURL(i.url ?? 'http://google.com'),
                        child: Container(
                            child: Stack(
                          children: <Widget>[
                            CachedNetworkImage(
                              width: 10000,
                              height: 60,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Center(
                                    child: LoadingCircular10(),
                                  ),
                              imageUrl: i.banner ?? "",
                              fadeInCurve: Curves.fastOutSlowIn,
                            )
                            // Positioned(
                            //     bottom: 0.0,
                            //     left: 0.0,
                            //     right: 0.0,
                            //     child: Container(
                            //       decoration: BoxDecoration(
                            //           gradient: LinearGradient(
                            //         colors: [
                            //           Color.fromARGB(200, 0, 0, 0),
                            //           Color.fromARGB(0, 0, 0, 0)
                            //         ],
                            //         begin: Alignment.bottomCenter,
                            //         end: Alignment.topCenter,
                            //       )),
                            //     )),
                          ],
                        )));
                  }).toList(),
                  autoPlay: true,
                  viewportFraction: 1.0,
                  enlargeCenterPage: false,
                  aspectRatio: 2.0,
                  height: 270,
                  onPageChanged: (index) {
                    setState(() {
                      _current = index;
                    });
                  },
                ),
                // Positioned(
                //     bottom: 10.0,
                //     left: 0.0,
                //     right: 0.0,
                //     child: Row(
                //       mainAxisAlignment: MainAxisAlignment.center,
                //       children: map<Widget>(model.newsList, (index, url) {
                //         return Container(
                //           width: 8.0,
                //           height: 8.0,
                //           margin: EdgeInsets.symmetric(horizontal: 2.0),
                //           decoration: BoxDecoration(
                //               shape: BoxShape.circle,
                //               color: _current == index
                //                   ? Pallete.primary
                //                   : Colors.white),
                //         );
                //       }),
                //     ))
              ]);
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

List<T> map<T>(List list, Function handler) {
  List<T> result = [];
  for (var i = 0; i < list.length; i++) {
    result.add(handler(i, list[i]));
  }

  return result;
}
