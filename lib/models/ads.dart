class Ads {
  String banner, url;

  Ads({this.banner, this.url});

  factory Ads.fromJson(Map<String, dynamic> json) {
    return Ads(banner: json['banner'], url: json['url']);
  }
}
