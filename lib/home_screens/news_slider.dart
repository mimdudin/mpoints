import 'package:flutter/material.dart';

class NewsSlider extends StatefulWidget {
  @override
  _NewsSliderState createState() => _NewsSliderState();
}

class _NewsSliderState extends State<NewsSlider> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 10),
      height: 170,
      color: Colors.grey,
    );
  }
}
