import '../../domain/entities/article_entity.dart';
import '../../domain/repositories/news_repository.dart';
import '../datasources/news_local_data_source.dart';
import '../datasources/news_remote_data_source.dart';

class NewsRepositoryImpl implements NewsRepository {
  final NewsRemoteDataSource remote;
  final NewsLocalDataSource local;

  NewsRepositoryImpl({required this.remote, required this.local});

  @override
  Future<List<ArticleEntity>> getTopHeadlines({
    String category = 'technology',
    int page = 1,
    int pageSize = 20,
  }) async {
    final cacheKey = 'headlines_${category}_$page';

    // 1. Try cache first
    final cached = local.getArticles(cacheKey);
    if (cached != null) return cached;

    // 2. Fetch from network
    final articles = await remote.getTopHeadlines(
      category: category,
      page: page,
      pageSize: pageSize,
    );

    // 3. Store in cache
    await local.cacheArticles(cacheKey, articles);
    return articles;
  }

  @override
  Future<List<ArticleEntity>> searchArticles({
    required String query,
    int page = 1,
    int pageSize = 20,
  }) async {
    return remote.searchArticles(query: query, page: page, pageSize: pageSize);
  }
}