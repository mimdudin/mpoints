import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class StatementFragment extends StatefulWidget {
  @override
  _StatementFragmentState createState() => _StatementFragmentState();
}

class _StatementFragmentState extends State<StatementFragment> {
  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.all(5),
        child: Column(
          children: <Widget>[
            Card(
              elevation: 2.0,
              color: Colors.white,
              child: Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  children: <Widget>[
                    _buildBalance(),
                    SizedBox(height: 10),
                    _buildReceived(),
                    SizedBox(height: 10),
                    _buildUsed(),
                  ],
                ),
              ),
            ),
            _buildStatementList(),
          ],
        ));
  }

  Widget _buildStatementList() {
    return Card(
      elevation: 2.0,
      color: Colors.white,
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 3),
        child: Column(
          children: <Widget>[
            Container(
              child: ListTile(
                leading: _buildImageProfile(),
                title: Text(
                  "21 Theatreecal",
                  style: Theme.of(context).textTheme.title.copyWith(
                        fontSize: 15,
                        color: Color(0xffAD8D0B),
                      ),
                ),
                subtitle: Text(
                  "Voucher Drink",
                  style: Theme.of(context).textTheme.subhead.copyWith(
                        fontSize: 13,
                        color: Color(0xffAD8D0B),
                      ),
                ),
                trailing: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: <Widget>[
                    Container(
                      // color: Colors.limeAccent,
                      height: 15,
                      // color: Colors.green,
                      child: Text(
                        "30 May 2018",
                        textAlign: TextAlign.start,
                        style: Theme.of(context)
                            .textTheme
                            .caption
                            .copyWith(fontSize: 12),
                      ),
                    ),
                    SizedBox(height: 8),
                    Container(
                      padding: EdgeInsets.only(bottom: 10),
                      // color: Colors.lightGreen,
                      child: Text(
                        "9,999",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.subtitle.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              color: Color(0xffAD8D0B),
                            ),
                      ),
                    )
                  ],
                ),
              ),
            )
            // SizedBox(height: 5),
            // SizedBox(height: 5),
          ],
        ),
      ),
    );
  }

  Widget _buildImageProfile() {
    return Container(
      width: 60,
      height: 60,
      child: CircleAvatar(
        child: ClipOval(
            child: CachedNetworkImage(
          width: 60.0,
          height: 60.0,
          fit: BoxFit.cover,
          placeholder: (context, url) => Center(
                child: SpinKitFadingCube(
                  color: Colors.white54,
                  size: 10,
                ),
              ),
          imageUrl: "http://via.placeholder.com/200x150",
          errorWidget: (context, url, error) => new Icon(Icons.error),
          fadeOutDuration: new Duration(seconds: 1),
          fadeInDuration: new Duration(seconds: 3),
          fadeInCurve: Curves.fastOutSlowIn,
        )),
      ),
    );
  }

  Widget _buildBalance() {
    return Container(
      child: Row(
        children: <Widget>[
          Text("Your MPoints Balance:",
              style: Theme.of(context)
                  .textTheme
                  .subhead
                  .copyWith(fontSize: 15, color: Color(0xffAD8D0B))),
          SizedBox(width: 5),
          Text(
            "999,999",
            style: Theme.of(context).textTheme.subhead.copyWith(
                fontSize: 15,
                color: Color(0xffAD8D0B),
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  Widget _buildReceived() {
    return Container(
      child: Row(
        children: <Widget>[
          Text("Total MPoints Received:",
              style: Theme.of(context)
                  .textTheme
                  .subhead
                  .copyWith(fontSize: 15, color: Color(0xffAD8D0B))),
          SizedBox(width: 5),
          Text(
            "999,999",
            style: Theme.of(context).textTheme.subhead.copyWith(
                fontSize: 15,
                color: Color(0xffAD8D0B),
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  Widget _buildUsed() {
    return Container(
      child: Row(
        children: <Widget>[
          Text("Total MPoints Used:",
              style: Theme.of(context)
                  .textTheme
                  .subhead
                  .copyWith(fontSize: 15, color: Color(0xffAD8D0B))),
          SizedBox(width: 5),
          Text(
            "999,999",
            style: Theme.of(context).textTheme.subhead.copyWith(
                fontSize: 15,
                color: Color(0xffAD8D0B),
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
