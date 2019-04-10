import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:permission_handler/permission_handler.dart';

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

class _HomeState extends State<Home> {
  int _selectedDrawerIndex = 0;

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
    super.initState();
    widget.auth.currentUser().then((val) {
      loadData(val.uid);
      print(val);
    });
  }

  Future loadData(String userId) async {
    await Future.wait([
      widget.model.fetchNewsList(),
      widget.model.fetchRewardList(),
      widget.model.fetchPartnerList(),
      widget.model.fetchAds(),
      widget.model.fetchUserById(userId),
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
                        Strings.termsAndPrivacyTOS
                ? <Widget>[]
                : <Widget>[
                    IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () {},
                    ),
                    IconButton(
                      icon: Icon(Icons.filter_list),
                      onPressed: () {},
                    ),
                  ],
          ),
          drawer: Drawer(
            child: ListView(
              children: <Widget>[
                _buildProfileBanner(model),
                Column(children: drawerOptions),
                // Divider(height: 0),
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
          _signOut();
          // Scaffold.of(context).showSnackBar(new SnackBar(
          //   content: new Text("Sign Out..."),
          // ));
        });
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

  void _signOut() async {
    try {
      await widget.auth.signOut();
      widget.onSignedOut();
    } catch (e) {
      print("Error: $e");
    }
  }
}
