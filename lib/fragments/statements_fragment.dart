import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:scoped_model/scoped_model.dart';

import '../services/main_model.dart';
import '../utils/pallete.dart';
import '../utils/strings.dart';
import '../models/statement.dart';
import '../utils/circular_loading.dart';

class StatementFragment extends StatefulWidget {
  @override
  _StatementFragmentState createState() => _StatementFragmentState();
}

class _StatementFragmentState extends State<StatementFragment> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (context, child, model) {
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
                        _buildBalance(model),
                        SizedBox(height: 10),
                        _buildReceived(model),
                        SizedBox(height: 10),
                        _buildUsed(model),
                      ],
                    ),
                  ),
                ),
                Expanded(
                    child: model.isLoadingUser
                        ? Center(child: LoadingCircular25())
                        : model.getStatementsCount() == 0
                            ? Center(child: Text("No statement List."))
                            : ListView.builder(
                                itemCount: model.statementList == null
                                    ? 0
                                    : model.getStatementsCount(),
                                itemBuilder: (context, i) {
                                  var statement = model.statementList[i];
                                  return statement.claim != null
                                      ? _buildStatementClaim(statement, model)
                                      : _buildStatementReward(statement, model);
                                },
                              ))
              ],
            ));
      },
    );
  }

  Widget _buildStatementReward(Statement statement, MainModel model) {
    return Card(
      elevation: 2.0,
      color: Colors.white,
      child: Container(
        color: Color(0xffe6e6e6),
        padding: EdgeInsets.symmetric(vertical: 3),
        child: Column(
          children: <Widget>[
            Container(
              child: ListTile(
                leading: _buildImageProfile(statement),
                title: Text(
                  statement == null || statement.rewardName == ""
                      ? "Unknown"
                      : "${statement.rewardName}",
                  style: Theme.of(context).textTheme.title.copyWith(
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                ),
                subtitle: Text(
                  statement == null || statement.partnerName == ""
                      ? "Unknown"
                      : "${statement.partnerName}",
                  style: Theme.of(context).textTheme.subhead.copyWith(
                        fontSize: 13,
                        color: Colors.black87,
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
                        statement == null
                            ? "2000-00-00"
                            : "${DateTime.fromMillisecondsSinceEpoch(statement.timestamp)}"
                                .substring(0, 10),
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
                        statement == null ? "0" : "${statement.rewardValue}",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.subtitle.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              color: Colors.black87,
                            ),
                      ),
                    )
                  ],
                ),
              ),
            )
            // SizedBox(height: 5),
          ],
        ),
      ),
    );
  }

  Widget _buildStatementClaim(Statement statement, MainModel model) {
    return Card(
      elevation: 2.0,
      color: Colors.white,
      child: Container(
        color: Pallete.primary,
        padding: EdgeInsets.symmetric(vertical: 3),
        child: Column(
          children: <Widget>[
            Container(
              child: ListTile(
                leading: Container(
                  child: _buildImageProfile(statement),
                ),
                title: Text(
                  statement == null || statement.partnerName == ""
                      ? "Unknown"
                      : "${statement.partnerName}",
                  style: Theme.of(context).textTheme.title.copyWith(
                        fontSize: 15,
                        color: Colors.black87,
                      ),
                ),
                subtitle: Text(
                  statement == null
                      ? "Unknown details"
                      : "Claimed for ${statement.purchaseAmount} purchase.",
                  style: Theme.of(context).textTheme.subhead.copyWith(
                        fontSize: 13,
                        color: Colors.black87,
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
                        statement == null
                            ? "2000-00-00"
                            : "${DateTime.fromMillisecondsSinceEpoch(statement.timestamp)}"
                                .substring(0, 10),
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
                        statement == null ? "0" : "${statement.claim}",
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.subtitle.copyWith(
                              fontSize: 20,
                              fontWeight: FontWeight.w400,
                              color: Colors.black87,
                            ),
                      ),
                    )
                  ],
                ),
              ),
            )
            // SizedBox(height: 5),
          ],
        ),
      ),
    );
  }

  Widget _buildImageProfile(Statement statement) {
    return Container(
      width: 60,
      height: 60,
      child: CircleAvatar(
        backgroundColor: Color(0xffe6e6e6),
        child: ClipOval(
            child: statement.claim != null
                ? Icon(FontAwesomeIcons.handHoldingUsd, size: 35, color: Pallete.primary,)
                : CachedNetworkImage(
                    width: 60.0,
                    height: 60.0,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Center(
                          child: LoadingCircular10(),
                        ),
                    imageUrl: statement?.banner ??
                        "http://via.placeholder.com/200x150",
                    errorWidget: (context, url, error) => new Icon(Icons.error),
                    fadeOutDuration: new Duration(seconds: 1),
                    fadeInDuration: new Duration(seconds: 3),
                    fadeInCurve: Curves.fastOutSlowIn,
                  )),
      ),
    );
  }

  Widget _buildBalance(MainModel model) {
    return Container(
      child: Row(
        children: <Widget>[
          Text(Strings.yourMPbalance,
              style: Theme.of(context)
                  .textTheme
                  .subhead
                  .copyWith(fontSize: 15, color: Pallete.primary)),
          SizedBox(width: 5),
          Text(
            model.isLoadingUser
                ? '...'
                : model.user == null ? "0" : "${model.user.mpoints}",
            style: Theme.of(context).textTheme.subhead.copyWith(
                fontSize: 15,
                color: Pallete.primary,
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  Widget _buildReceived(MainModel model) {
    return Container(
      child: Row(
        children: <Widget>[
          Text(Strings.mpReceived,
              style: Theme.of(context)
                  .textTheme
                  .subhead
                  .copyWith(fontSize: 15, color: Pallete.primary)),
          SizedBox(width: 5),
          Text(
            model.isLoadingUser
                ? '...'
                : model.user == null ? "0" : "${model.user.mpointsReceived}",
            style: Theme.of(context).textTheme.subhead.copyWith(
                fontSize: 15,
                color: Pallete.primary,
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }

  Widget _buildUsed(MainModel model) {
    return Container(
      child: Row(
        children: <Widget>[
          Text(Strings.mpUsed,
              style: Theme.of(context)
                  .textTheme
                  .subhead
                  .copyWith(fontSize: 15, color: Pallete.primary)),
          SizedBox(width: 5),
          Text(
            model.isLoadingUser
                ? '...'
                : model.user == null ? "0" : "${model.user.mpointsUsed}",
            style: Theme.of(context).textTheme.subhead.copyWith(
                fontSize: 15,
                color: Pallete.primary,
                decoration: TextDecoration.underline,
                fontWeight: FontWeight.bold),
          )
        ],
      ),
    );
  }
}
