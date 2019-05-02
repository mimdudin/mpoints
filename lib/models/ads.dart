class Ads {
  String id, banner, url;

  Ads({this.id, this.banner, this.url});

  factory Ads.fromJson(String id, Map<String, dynamic> json) {
    return Ads(id: id, banner: json['banner'], url: json['url']);
  }
}
