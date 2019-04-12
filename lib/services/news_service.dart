import 'package:scoped_model/scoped_model.dart';
import 'package:http/http.dart' as http;
import 'dart:async';
import 'dart:convert';

import '../models/news.dart';
import '../utils/constant.dart';

mixin NewsService on Model {
  List<News> _newsList = [];
  List<News> get newsList => _newsList;

  bool _isLoadingNews = false;
  bool get isLoadingNews => _isLoadingNews;

  int getNewsListCount() {
    return _newsList.length;
  }

  Future<News> fetchNewsList() async {
    var _news;

    _isLoadingNews = true;
    notifyListeners();

    var response = await http
        .get(Constant.baseUrl + Constant.newsParam + Constant.jsonExt);

    if (response.statusCode == 200) {
      var responseData = json.decode(response.body);
      print(responseData);

      final List<News> fetchedNewsList = [];
      responseData.forEach((String newsId, dynamic json) {
        _news = News.fromJson(newsId, json);

        fetchedNewsList.add(_news);
      });

      _newsList = fetchedNewsList;
      _isLoadingNews = false;
      notifyListeners();

      return _news;
    } else {
      _isLoadingNews = false;
      notifyListeners();
      throw Exception('failed to load data');
    }
  }

  void clearNewsList() {
    _newsList.clear();
    notifyListeners();
  }
}
