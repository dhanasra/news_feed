import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/errors/exceptions.dart';
import '../../isolates/article_parser_isolate.dart';
import '../models/article_model.dart';

abstract class NewsRemoteDataSource {
  Future<List<ArticleModel>> getTopHeadlines({
    String category,
    int page,
    int pageSize,
  });
  Future<List<ArticleModel>> searchArticles({
    required String query,
    int page,
    int pageSize,
  });
}

class NewsRemoteDataSourceImpl implements NewsRemoteDataSource {
  final Dio dio;
  NewsRemoteDataSourceImpl(this.dio);

  @override
  Future<List<ArticleModel>> getTopHeadlines({
    String category = 'technology',
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final response = await dio.get(
        ApiConstants.topHeadlines,
        queryParameters: {
          'country': 'us',
          'category': category,
          'page': page,
          'pageSize': pageSize,
        },
      );
      return parseArticlesInIsolate(response.data);
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Server error');
    }
  }

  @override
  Future<List<ArticleModel>> searchArticles({
    required String query,
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final response = await dio.get(
        ApiConstants.everything,
        queryParameters: {
          'q': query,
          'sortBy': 'publishedAt',
          'page': page,
          'pageSize': pageSize,
        },
      );
      return parseArticlesInIsolate(response.data);
    } on DioException catch (e) {
      throw ServerException(e.message ?? 'Server error');
    }
  }
}