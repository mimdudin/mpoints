import 'package:shimmer/shimmer.dart';
import 'package:flutter/material.dart';

class PartnersLoading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
        margin: EdgeInsets.symmetric(horizontal: 10),
        // height: 190,
        width: double.infinity,
        // padding: EdgeInsets.symmetric(horizontal: 2.0, vertical: 3),
        child: Shimmer.fromColors(
          baseColor: Colors.grey[300],
          highlightColor: Colors.grey[100],
          child: Row(
            children: <Widget>[
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300])),
                  height: 155,
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 7),
                          height: 120,
                          width: 150,
                          color: Colors.grey[300],
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          height: 15,
                          width: 70,
                          color: Colors.grey[300],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300])),
                  height: 155,
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 7),
                          height: 120,
                          width: 150,
                          color: Colors.grey[300],
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          height: 15,
                          width: 70,
                          color: Colors.grey[300],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey[300])),
                  height: 155,
                  child: Container(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          margin:
                              EdgeInsets.symmetric(horizontal: 5, vertical: 7),
                          height: 120,
                          width: 150,
                          color: Colors.grey[300],
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 5),
                          height: 15,
                          width: 70,
                          color: Colors.grey[300],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
