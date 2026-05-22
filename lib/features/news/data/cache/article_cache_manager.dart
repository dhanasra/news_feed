import 'dart:convert';
import 'package:hive/hive.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/ttl_cache.dart';
import '../models/article_model.dart';

class ArticleCacheManager {
  final Box<String> _box;
  final TtlCache _ttl = TtlCache();

  ArticleCacheManager(this._box);

  Future<void> cacheArticles(String key, List<ArticleModel> articles) async {
    final encoded = jsonEncode(articles.map((a) => a.toJson()).toList());
    await _box.put(key, encoded);
    _ttl.setTimestamp(key);
  }

  List<ArticleModel>? getCachedArticles(String key) {
    if (_ttl.isExpired(key, AppConstants.cacheTtlMinutes)) return null;
    final raw = _box.get(key);
    if (raw == null) return null;
    final list = jsonDecode(raw) as List<dynamic>;
    return list
        .map((e) => ArticleModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  void invalidate(String key) {
    _box.delete(key);
    _ttl.invalidate(key);
  }
}