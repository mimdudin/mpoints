import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import './home.dart';
import './root_page.dart';
import './services/main_model.dart';
import './authentications/login_page.dart';
import './utils/pallete.dart';
import './splashscreen.dart';
import './authentications/auth.dart';
import './pages/rewards_detail_page.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MainModel model = new MainModel();
    return ScopedModel(
      model: model,
      child: MaterialApp(
        theme: ThemeData(
            primaryColor: Pallete.primary, cursorColor: Pallete.primary),
        home: SplashScreen(),
        routes: {
          '/main': (BuildContext context) =>
              RootPage(model: model, auth: Auth()),
          '/rewardDetail': (BuildContext context) => RewardsDetailPage()
        },
      ),
    );
  }
}
