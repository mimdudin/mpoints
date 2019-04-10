import 'package:flutter/material.dart';

import '../utils/terms_privacy_content.dart';

class TermsAndPrivacyFragment extends StatefulWidget {
  @override
  _TermsAndPrivacyFragmentState createState() => _TermsAndPrivacyFragmentState();
}

class _TermsAndPrivacyFragmentState extends State<TermsAndPrivacyFragment> {
  @override
  Widget build(BuildContext context) {
    return TermsPrivacyContent(0);
  }
}