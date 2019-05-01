import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

import './models/drawer_item.dart';
import './fragments/statements_fragment.dart';
import './fragments/tos_fragment.dart';
import './fragments/home_fragment.dart';
import './services/main_model.dart';
import './pages/profiles/profile_page.dart';
import './pages/claims/claim_points_page.dart';
import './authentications/auth.dart';
import './utils/strings.dart';
import './utils/pallete.dart';
import './utils/circular_loading.dart';
import './utils/my_icons.dart';

class Home extends StatefulWidget {
  final MainModel model;
  final BaseAuth auth;
  final VoidCallback onSignedOut;

  Home({this.auth, this.onSignedOut, this.model});

  final drawerItems = [
    new DrawerItem(title: Strings.home, icon: FontAwesomeIcons.home),
    new DrawerItem(title: Strings.statement, icon: FontAwesomeIcons.chartBar),
    new DrawerItem(
        title: Strings.termsAndPrivacyTOS, icon: FontAwesomeIcons.fileAlt),
    // new DrawerItem(title: "Logout", icon: Icons.exit_to_app)
  ];
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> with SingleTickerProviderStateMixin {
  int _selectedDrawerIndex = 0;
  bool _isSort = false;
  List<FilterModel> _listFilter = [];

  _getDrawerItemWidget(int pos) {
    switch (pos) {
      case 0:
        return HomeFragment();
      case 1:
        return StatementFragment();
      case 2:
        return TermsAndPrivacyFragment();

      default:
        return Text("Error");
    }
  }

  Future _onSelectItem(int index) async {
    setState(() => _selectedDrawerIndex = index);
    Navigator.of(context).pop(); // close the drawer
  }

  @override
  void initState() {
    loadData();

    _listFilter.add(FilterModel("Redeem", false));
    _listFilter.add(FilterModel("Claim", false));

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();

    // setState(() {
    _isSort = false;
    // widget.model.ivariList.sort((a, b) => a.postId.compareTo(b.postId));
    // });
  }

  Future loadData() async {
    await Future.wait([
      widget.model.fetchNewsList(),
      widget.model.fetchRewardList(),
      widget.model.fetchPartnerList(),
      widget.model.fetchUtility(),
      widget.model.fetchAds(),
      widget.auth.currentUser().then((currentUser) {
        widget.model.fetchUserById(currentUser.uid);
        print(currentUser);
      })
      // PermissionHandler().requestPermissions([PermissionGroup.camera])
    ]);
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> drawerOptions = [];
    for (var i = 0; i < widget.drawerItems.length; i++) {
      var d = widget.drawerItems[i];
      drawerOptions.add(new ListTile(
        leading: Icon(d.icon, color: Pallete.primary, size: 26),
        title: Text(d.title,
            style: TextStyle(
                fontSize: 18, letterSpacing: 1, fontWeight: FontWeight.w400)),
        selected: i == _selectedDrawerIndex,
        onTap: () => _onSelectItem(i),
      ));
    }

    return ScopedModelDescendant<MainModel>(
      builder: (context, child, model) {
        return Scaffold(
          appBar: AppBar(
            elevation: 0.0,
            titleSpacing: 0.0,
            title: Text(
                widget.drawerItems[_selectedDrawerIndex].title == Strings.home
                    ? ""
                    : widget.drawerItems[_selectedDrawerIndex].title),
            actions: widget.drawerItems[_selectedDrawerIndex].title ==
                        Strings.home ||
                    widget.drawerItems[_selectedDrawerIndex].title ==
                        Strings.termsAndPrivacyTOS ||
                    model.getStatementsCount() == 0
                ? <Widget>[]
                : <Widget>[
                    Builder(
                        builder: (context) => IconButton(
                              icon: Icon(Icons.search),
                              onPressed: () async {
                                // final Rewards rewards = await
                                showSearch(
                                    context: context,
                                    delegate: DataSearchStatement(model));

                                // Scaffold.of(context).showSnackBar(
                                //     SnackBar(content: Text(rewards.name)));
                              },
                            )),
                    IconButton(
                        icon: Icon(LineAwesomeIcons.filter),
                        onPressed: () => showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return ModalBottomSheet(_listFilter, model);
                              },
                            )),
                    IconButton(
                        icon: Icon(Icons.filter_list),
                        onPressed: () {
                          setState(() {
                            if (_isSort == false) {
                              model.sortStatements();
                              _isSort = true;
                            } else {
                              model.unSortStatements();
                              _isSort = false;
                            }
                          });
                        }),
                  ],
          ),
          drawer: Drawer(
            child: ListView(
              children: <Widget>[
                _buildProfileBanner(model),
                Column(children: drawerOptions),
                // Divider(height: 0),
                _buildFacebook(model),
                _buildWebsite(model),
                _buildEmail(model),
                _buildSignOut(),
                // Divider(height: 0)
              ],
            ),
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => ClaimPointsPage())),
            tooltip: Strings.tooltipClaims,
            child: Icon(Icons.add, size: 40),
            backgroundColor: Pallete.primary,
          ),
          body: _getDrawerItemWidget(_selectedDrawerIndex),
        );
      },
    );
  }

  Widget _buildSignOut() {
    return ListTile(
        // contentPadding: EdgeInsets.only(left: 73.5, right: 15),
        leading: Container(
            padding: EdgeInsets.only(left: 4.0),
            child: Icon(FontAwesomeIcons.signOutAlt,
                color: Pallete.primary, size: 28)),
        title: Text(Strings.signOut,
            style: TextStyle(
                fontSize: 18, letterSpacing: 1, fontWeight: FontWeight.w400)),
        onTap: () {
          Navigator.of(context).pop();
          _signOut().then((_) {
            setState(() {
              widget.model.clearAds();
              widget.model.clearClaimList();
              widget.model.clearNewsList();
              widget.model.clearPartnerList();
              widget.model.clearRewardList();
              widget.model.clearUserList();
              widget.model.clearStatementList();
              widget.model.setStatus('Claim & Redeem');
            });
          });
          // Scaffold.of(context).showSnackBar(new SnackBar(
          //   content: new Text("Sign Out..."),
          // ));
        });
  }

  Widget _buildFacebook(MainModel model){
    return ListTile(
        // contentPadding: EdgeInsets.only(left: 73.5, right: 15),
        leading: Container(
            padding: EdgeInsets.only(left: 4.0),
            child: Icon(FontAwesomeIcons.facebook,
                color: Pallete.primary, size: 28)),
        title: Text('Facebook',
            style: TextStyle(
                fontSize: 18, letterSpacing: 1, fontWeight: FontWeight.w400)),
        onTap: () => _launchURL(model.utility.facebook ?? 'http://goal.com'));
  }

  Widget _buildWebsite(MainModel model) {
    return ListTile(
        // contentPadding: EdgeInsets.only(left: 73.5, right: 15),
        leading: Container(
            padding: EdgeInsets.only(left: 4.0),
            child: Icon(Icons.language, color: Pallete.primary, size: 28)),
        title: Text('Website',
            style: TextStyle(
                fontSize: 18, letterSpacing: 1, fontWeight: FontWeight.w400)),
        onTap: () => _launchURL(model.utility.website ?? 'http://google.com'));
  }

  void _launchURL(String urlAds) async {
    String url = urlAds;
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  Widget _buildEmail(MainModel model) {
    return ListTile(
        // contentPadding: EdgeInsets.only(left: 73.5, right: 15),
        leading: Container(
            padding: EdgeInsets.only(left: 4.0),
            child: Icon(Icons.email, color: Pallete.primary, size: 28)),
        title: Text('Email',
            style: TextStyle(
                fontSize: 18, letterSpacing: 1, fontWeight: FontWeight.w400)),
        onTap: () => model.isLoadingUser
            ? {}
            : launch('mailto:${model.utility.email}?subject=Support'));
  }

  Widget _buildProfileBanner(MainModel model) {
    return GestureDetector(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (BuildContext context) => ProfilePage())),
      child: Container(
          height: 210,
          color: Pallete.primary,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  padding: EdgeInsets.only(right: 5, top: 5),
                  alignment: Alignment.centerRight,
                  child: Icon(
                    Icons.keyboard_arrow_left,
                    color: Colors.white,
                    size: 28,
                  ),
                ),
              ),
              Container(
                width: 100,
                height: 100.0,
                child: CircleAvatar(
                  child: ClipOval(
                      child: CachedNetworkImage(
                    width: 200.0,
                    height: 200.0,
                    fit: BoxFit.cover,
                    placeholder: (context, url) => Center(
                          child: LoadingCircular10(),
                        ),
                    imageUrl: model.user?.photo ??
                        "http://via.placeholder.com/200x150",
                    errorWidget: (context, url, error) => new Icon(Icons.error),
                    fadeOutDuration: new Duration(seconds: 1),
                    fadeInDuration: new Duration(seconds: 3),
                    fadeInCurve: Curves.fastOutSlowIn,
                  )),
                ),
              ),
              SizedBox(height: 15),
              Text(
                model.isLoadingUser
                    ? 'Loading...'
                    : model.user == null || model.user.firstName == ""
                        ? "Unknown"
                        : "${model.user.firstName} ${model.user.lastName}",
                style: Theme.of(context)
                    .textTheme
                    .subhead
                    .copyWith(fontSize: 16, color: Colors.white),
              ),
              SizedBox(height: 3),
              Text(
                model.isLoadingUser
                    ? 'Loading...'
                    : model.user == null || model.user.email == ""
                        ? "anonymous@gmail.com"
                        : "${model.user.email}",
                style: Theme.of(context)
                    .textTheme
                    .subhead
                    .copyWith(fontSize: 13, color: Colors.white),
              ),
              // GestureDetector(
              //   onTap: () => Navigator.of(context).pop(),
              //   child: Container(
              //     padding: EdgeInsets.only(right: 5, bottom: 5),
              //     alignment: Alignment.centerRight,
              //     child: Icon(
              //       Icons.home,
              //       color: Colors.white,
              //       size: 20,
              //     ),
              //   ),
              // ),
            ],
          )),
    );
  }

  Future<void> _signOut() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print("Error: $e");
    }
  }
}

class ModalBottomSheet extends StatefulWidget {
  final List<FilterModel> listFilter;
  final MainModel model;

  ModalBottomSheet(this.listFilter, this.model);

  @override
  _ModalBottomSheetState createState() => _ModalBottomSheetState();
}

class _ModalBottomSheetState extends State<ModalBottomSheet>
    with SingleTickerProviderStateMixin {
  var _value;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        SizedBox(height: 10),
        Text(
          "FILTER BY",
          style: Theme.of(context)
              .textTheme
              .title
              .copyWith(fontSize: 12, color: Colors.black45),
        ),
        SizedBox(height: 5),
        Column(
            children: widget.listFilter
                .map((filter) => Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                      child: Row(
                        children: <Widget>[
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                widget.listFilter.forEach(
                                    (filter) => filter.isSelected = false);
                                filter.isSelected = true;
                                _value = filter.name;
                              });
                            },
                            child: filter.isSelected
                                ? Icon(
                                    Icons.check_circle,
                                    size: 28,
                                    color: Pallete.primary,
                                  )
                                : Icon(
                                    Icons.check_circle_outline,
                                    size: 28,
                                    color: Colors.grey,
                                  ),
                          ),
                          SizedBox(width: 15),
                          Text(
                            filter.name,
                            style: Theme.of(context)
                                .textTheme
                                .subtitle
                                .copyWith(color: Pallete.primary, fontSize: 16),
                          ),
                        ],
                      ),
                    ))
                .toList()),
        Container(
            margin: EdgeInsets.only(bottom: 10, right: 30),
            alignment: Alignment.centerRight,
            child: widget.model.status == 'Claim & Redeem'
                ? RaisedButton(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(100))),
                    onPressed: () {
                      setState(() {
                        if (_value == 'Claim') {
                          widget.model.setStatus('Claim');
                        } else {
                          widget.model.setStatus('Redeem');
                        }
                        Navigator.of(context).pop();
                      });
                    },
                    color: Pallete.primary,
                    child: Text("SAVE",
                        style: Theme.of(context)
                            .textTheme
                            .button
                            .copyWith(color: Colors.white)),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: <Widget>[
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(100))),
                        onPressed: () {
                          setState(() {
                            _value = '';
                            widget.model.setStatus('Claim & Redeem');
                            widget.listFilter
                                .forEach((filter) => filter.isSelected = false);
                            Navigator.of(context).pop();
                          });
                        },
                        color: Colors.red,
                        child: Text("CLOSE FILTER",
                            style: Theme.of(context)
                                .textTheme
                                .button
                                .copyWith(color: Colors.white)),
                      ),
                      SizedBox(width: 10),
                      RaisedButton(
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(100))),
                        onPressed: () {
                          setState(() {
                            if (_value == 'Claim') {
                              widget.model.setStatus('Claim');
                            } else {
                              widget.model.setStatus('Redeem');
                            }
                            Navigator.of(context).pop();
                          });
                        },
                        color: Pallete.primary,
                        child: Text("SAVE",
                            style: Theme.of(context)
                                .textTheme
                                .button
                                .copyWith(color: Colors.white)),
                      ),
                    ],
                  ))
      ],
    );
  }
}

class FilterModel {
  String name;
  bool isSelected;
  FilterModel(this.name, this.isSelected);
}
