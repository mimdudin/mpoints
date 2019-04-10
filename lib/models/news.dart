class News {
  String url;

  News(this.url);

  factory News.fromJson(String newsId, Map<String, dynamic> json) {
    return News(json['url']);
  }
}
