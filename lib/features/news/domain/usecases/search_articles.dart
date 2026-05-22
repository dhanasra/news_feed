import '../entities/article_entity.dart';
import '../repositories/news_repository.dart';

class SearchArticles {
  final NewsRepository repository;
  SearchArticles(this.repository);

  Future<List<ArticleEntity>> call({
    required String query,
    int page = 1,
    int pageSize = 20,
  }) {
    return repository.searchArticles(
      query: query,
      page: page,
      pageSize: pageSize,
    );
  }
}