import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class KVnexpressArticle {
  final String title;
  final String content;
  final String thumbnailUrl;

  KVnexpressArticle({this.title, this.content, this.thumbnailUrl});
}


class ArticleGenerator {
  Future<KVnexpressArticle> getVnexpressArticle(String url) async {

    final response = await http.get(url);
    var data = json.decode(response.body)["data"];
    return KVnexpressArticle(
      title: data['title'],
      content: data['content'],
      thumbnailUrl: data['thumbnail_url'],
    );
  }
}
