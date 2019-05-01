import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';

import '../utils/terms_privacy_content.dart';
import '../services/main_model.dart';

class TermsPrivacyPage extends StatefulWidget {
  final MainModel model;

  TermsPrivacyPage(this.model);

  @override
  _TermsPrivacyPageState createState() => _TermsPrivacyPageState();
}

class _TermsPrivacyPageState extends State<TermsPrivacyPage> {
  @override
  void initState() {
    super.initState();

    loadData();
  }

  Future loadData() async {
    await widget.model.fetchUtility();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TermsPrivacyContent(1),
    );
  }
}
