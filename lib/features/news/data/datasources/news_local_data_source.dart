import '../cache/article_cache_manager.dart';
import '../models/article_model.dart';

abstract class NewsLocalDataSource {
  List<ArticleModel>? getArticles(String key);
  Future<void> cacheArticles(String key, List<ArticleModel> articles);
}

class NewsLocalDataSourceImpl implements NewsLocalDataSource {
  final ArticleCacheManager cacheManager;
  NewsLocalDataSourceImpl(this.cacheManager);

  @override
  List<ArticleModel>? getArticles(String key) {
    return cacheManager.getCachedArticles(key);
  }

  @override
  Future<void> cacheArticles(String key, List<ArticleModel> articles) async {
    await cacheManager.cacheArticles(key, articles);
  }
}