import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:news_app/features/news/domain/entities/article_entity.dart';
import 'package:news_app/features/news/domain/entities/source_entity.dart';
import 'package:news_app/features/news/domain/usecases/get_top_headlines.dart';
import 'package:news_app/features/news/presentation/bloc/news_bloc.dart';
import 'package:news_app/features/news/presentation/bloc/news_event.dart';
import 'package:news_app/features/news/presentation/bloc/news_state.dart';

class MockGetTopHeadlines extends Mock implements GetTopHeadlines {}

const _mockArticle = ArticleEntity(
  source: SourceEntity(name: 'BBC'),
  title: 'Test Article',
  url: 'https://bbc.com/1',
);

void main() {
  late MockGetTopHeadlines mockUseCase;

  setUp(() {
    mockUseCase = MockGetTopHeadlines();
  });

  blocTest<NewsBloc, NewsState>(
    'emits [NewsLoading, NewsLoaded] when LoadArticles succeeds',
    build: () {
      when(() => mockUseCase(
            category: any(named: 'category'),
            page: any(named: 'page'),
            pageSize: any(named: 'pageSize'),
          )).thenAnswer((_) async => [_mockArticle]);
      return NewsBloc(getTopHeadlines: mockUseCase);
    },
    act: (bloc) => bloc.add(LoadArticles()),
    expect: () => [
      NewsLoading(),
      isA<NewsLoaded>().having((s) => s.articles.length, 'articles count', 1),
    ],
  );

  blocTest<NewsBloc, NewsState>(
    'emits [NewsLoading, NewsError] when LoadArticles throws',
    build: () {
      when(() => mockUseCase(
            category: any(named: 'category'),
            page: any(named: 'page'),
            pageSize: any(named: 'pageSize'),
          )).thenThrow(Exception('Network error'));
      return NewsBloc(getTopHeadlines: mockUseCase);
    },
    act: (bloc) => bloc.add(LoadArticles()),
    expect: () => [
      NewsLoading(),
      isA<NewsError>(),
    ],
  );
}