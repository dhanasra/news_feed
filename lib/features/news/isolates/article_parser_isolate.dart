import 'package:flutter/foundation.dart';
import '../data/models/article_model.dart';

List<ArticleModel> _parseArticles(Map<String, dynamic> data) {
  final articles = data['articles'] as List<dynamic>? ?? [];
  return articles
      .map((e) => ArticleModel.fromJson(e as Map<String, dynamic>))
      .where((a) => a.title != '[Removed]' && a.url.isNotEmpty)
      .toList();
}

Future<List<ArticleModel>> parseArticlesInIsolate(
  Map<String, dynamic> data,
) async {
  return compute(_parseArticles, data);
}