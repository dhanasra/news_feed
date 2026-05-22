import '../entities/article_entity.dart';
import '../repositories/news_repository.dart';

class GetTopHeadlines {
  final NewsRepository repository;
  GetTopHeadlines(this.repository);

  Future<List<ArticleEntity>> call({
    String category = 'technology',
    int page = 1,
    int pageSize = 20,
  }) {
    return repository.getTopHeadlines(
      category: category,
      page: page,
      pageSize: pageSize,
    );
  }
}