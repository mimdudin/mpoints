import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';

class RewardsLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 190,
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: 2.0, vertical: 3),
      child: Shimmer.fromColors(
          baseColor: Colors.grey[300],
          highlightColor: Colors.grey[100],
          child: Row(
            children: <Widget>[
              Expanded(
                  child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300])),
                      margin: EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: 120,
                            width: 200,
                            color: Colors.grey[300],
                          ),
                          SizedBox(height: 10),
                          Container(
                            color: Colors.grey[300],
                            height: 18,
                            width: 150,
                            margin: EdgeInsets.symmetric(horizontal: 10),
                          ),
                          SizedBox(height: 7),
                          Container(
                            height: 18,
                            color: Colors.grey[300],
                            width: 100,
                            margin: EdgeInsets.symmetric(horizontal: 10),
                          ),
                          SizedBox()
                        ],
                      ))),
              Expanded(
                  child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey[300])),
                      margin: EdgeInsets.symmetric(horizontal: 8),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            height: 120,
                            width: 200,
                            color: Colors.grey[300],
                          ),
                          SizedBox(height: 10),
                          Container(
                            color: Colors.grey[300],
                            height: 18,
                            width: 150,
                            margin: EdgeInsets.symmetric(horizontal: 10),
                          ),
                          SizedBox(height: 7),
                          Container(
                            height: 18,
                            color: Colors.grey[300],
                            width: 100,
                            margin: EdgeInsets.symmetric(horizontal: 10),
                          ),
                          SizedBox()
                        ],
                      ))),
            ],
          )),
    );
  }
}
