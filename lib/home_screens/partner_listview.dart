import 'package:flutter/material.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../services/main_model.dart';
import '../models/partners.dart';
import '../pages/partners_detail_page.dart';

class PartnerListView extends StatefulWidget {
  @override
  _PartnerListViewState createState() => _PartnerListViewState();
}

class _PartnerListViewState extends State<PartnerListView> {
  @override
  Widget build(BuildContext context) {
    return ScopedModelDescendant<MainModel>(
      builder: (context, child, model) {
        return !model.isLoadingPartnerList && model.getPartnerListCount() == 0
            ? Center(child: Text("No partner list."))
            : ListView.builder(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                scrollDirection: Axis.horizontal,
                itemCount:
                    model.partnerList == null ? 0 : model.getPartnerListCount(),
                itemBuilder: (context, i) {
                  var partner = model.partnerList[i];
                  return _buildPartnerListItem(partner);
                },
              );
      },
    );
  }

  Widget _buildPartnerListItem(Partners partner) {
    return Container(
      height: 155,
      child: GestureDetector(
          child: Card(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(0))),
            margin: EdgeInsets.zero,
            color: Colors.white,
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin: EdgeInsets.symmetric(horizontal: 5, vertical: 7),
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      border: Border.all(color: Color(0xffAD8D0B)),
                    ),
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      child: CachedNetworkImage(
                        imageUrl: partner.logo != null || partner.logo != ''
                            ? partner.logo
                            : '',
                        placeholder: (context, url) => new SpinKitThreeBounce(
                              color: Color(0xffAD8D0B),
                              size: 15,
                            ),
                        errorWidget: (context, url, error) =>
                            new Icon(Icons.error),
                        fadeOutDuration: new Duration(seconds: 1),
                        fadeInDuration: new Duration(seconds: 3),
                        fit: BoxFit.cover,
                        height: 120,
                        width: 120,
                      ),
                    ),
                  ),
                  Container(
                      alignment: Alignment.centerLeft,
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text(
                        partner.name != null || partner.name != ''
                            ? partner.name
                            : 'Unknown',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: Color(0xffAD8D0B)),
                      )),
                ],
              ),
            ),
          ),
          onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => PartnersDetailPage()),
              )),
    );
  }
}
