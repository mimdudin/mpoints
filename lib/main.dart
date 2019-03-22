import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import './home.dart';
import './services/main_model.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    MainModel model = new MainModel();
    return ScopedModel(
      model: model,
      child: MaterialApp(
        theme: ThemeData(primaryColor: Color(0xffAD8D0B)),
        home: Home(model),
      ),
    );
  }
}
