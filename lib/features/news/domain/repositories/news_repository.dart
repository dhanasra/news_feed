import '../entities/article_entity.dart';

abstract class NewsRepository {
  Future<List<ArticleEntity>> getTopHeadlines({
    String category,
    int page,
    int pageSize,
  });

  Future<List<ArticleEntity>> searchArticles({
    required String query,
    int page,
    int pageSize,
  });
}