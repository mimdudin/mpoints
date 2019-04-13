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
                                    : model.status == 'Claim & Redeem'
                                        ? model.getStatementsCount()
                                        : model.status == 'Claim'
                                            ? model.statementList
                                                .where((statement) =>
                                                    statement.claim != null)
                                                .toList()
                                                .length
                                            : model.statementList
                                                    .where((statement) =>
                                                        statement.rewardName !=
                                                        null)
                                                    .toList()
                                                    .length ??
                                                model.getStatementsCount(),
                                itemBuilder: (context, i) {
                                  var statement = model.statementList[i];
                                  return statement.claim != null
                                      ? BuildStatementClaim(statement, model)
                                      : BuildStatementReward(statement, model);
                                },
                              ))
              ],
            ));
      },
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
                : model.user == null || model.user.mpoints == 0.1
                    ? "0"
                    : "${model.format(model.user.mpoints)}",
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
                : model.user == null || model.user.mpoints == 0.1
                    ? "0"
                    : "${model.format(model.user.mpointsReceived)}",
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

class DataSearchStatement extends SearchDelegate<Statement> {
  final MainModel model;

  DataSearchStatement(this.model);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = "";
        },
      )
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: AnimatedIcon(
        icon: AnimatedIcons.menu_arrow,
        progress: transitionAnimation,
      ),
      onPressed: () {
        close(context, null);
        query = "";
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // TODO: implement buildResults
    final _statementList = model.statementList
        .where((statement) =>
            statement.rewardName != null &&
            statement.rewardName.toLowerCase().contains(query.toLowerCase()))
        .toList();

    return Container(
        child: query == ''
            ? buildSuggestions(context)
            : _statementList.length == 0
                ? Center(
                    child: Text("No statement found."),
                  )
                : ListView.builder(
                    itemCount:
                        _statementList == null ? 0 : _statementList.length,
                    itemBuilder: (context, i) {
                      var statement = _statementList[i];
                      return statement.claim != null
                          ? BuildStatementClaim(statement, model)
                          : BuildStatementReward(statement, model);
                    },
                  ));
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final suggestionsStatement = query.isEmpty
        ? model.statementList
            .where((statement) => statement.rewardName != null)
            .toList()
        : model.statementList
            .where((statement) =>
                statement.rewardName != null &&
                statement.rewardName
                    .toLowerCase()
                    .contains(query.toLowerCase()))
            .toList();
    return ListView.builder(
      itemBuilder: (context, i) => ListTile(
            leading: Icon(Icons.history),
            title: Text(suggestionsStatement[i]?.rewardName,
                style:
                    Theme.of(context).textTheme.caption.copyWith(fontSize: 16)),

            // RichText(
            //   text: TextSpan(
            //       text: suggestionsRewards[i].name.substring(0, query.length),
            //       style: Theme.of(context).textTheme.subhead.copyWith(
            //           color: Pallete.primary, fontWeight: FontWeight.bold),
            //       children: [
            //         TextSpan(
            //           text: suggestionsRewards[i].name.substring(query.length),
            //           style: Theme.of(context)
            //               .textTheme
            //               .subhead
            //               .copyWith(color: Colors.grey),
            //         )
            //       ]),
            // ),
            onTap: () {
              query = suggestionsStatement[i]?.rewardName;
            },
          ),
      itemCount: suggestionsStatement.length,
    );
  }
}

class BuildStatementClaim extends StatelessWidget {
  final Statement statement;
  final MainModel model;

  BuildStatementClaim(this.statement, this.model);

  @override
  Widget build(BuildContext context) {
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
                  child: BuildImageProfile(statement),
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
                        statement == null
                            ? "0"
                            : "${model.format(statement.claim)}",
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
}

class BuildStatementReward extends StatelessWidget {
  final Statement statement;
  final MainModel model;

  BuildStatementReward(this.statement, this.model);

  @override
  Widget build(BuildContext context) {
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
                leading: BuildImageProfile(statement),
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
                      margin: EdgeInsets.only(bottom: 10),
                      padding: EdgeInsets.all(5),
                      // color: Colors.lightGreen,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(50)),
                        color: Colors.green,
                      ),
                      child: Text(
                        "SUCCESS",
                        style: Theme.of(context)
                            .textTheme
                            .title
                            .copyWith(fontSize: 10, color: Colors.white, fontWeight: FontWeight.bold),
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
}

class BuildImageProfile extends StatelessWidget {
  final Statement statement;

  BuildImageProfile(this.statement);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 60,
      height: 60,
      child: CircleAvatar(
        backgroundColor: Color(0xffe6e6e6),
        child: ClipOval(
            child: statement.claim != null
                ? Icon(
                    FontAwesomeIcons.handHoldingUsd,
                    size: 35,
                    color: Pallete.primary,
                  )
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
}
