import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_top_headlines.dart';
import 'news_event.dart';
import 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final GetTopHeadlines getTopHeadlines;

  NewsBloc({required this.getTopHeadlines}) : super(NewsInitial()) {
    on<LoadArticles>(_onLoadArticles);
    on<LoadMoreArticles>(_onLoadMoreArticles);
    on<RefreshArticles>(_onRefreshArticles);
  }

  Future<void> _onLoadArticles(
    LoadArticles event,
    Emitter<NewsState> emit,
  ) async {
    emit(NewsLoading());
    try {
      final articles = await getTopHeadlines(category: event.category);
      emit(NewsLoaded(articles: articles, hasMore: articles.length == 20));
    } catch (e) {
      emit(NewsError(e.toString()));
    }
  }

  Future<void> _onLoadMoreArticles(
    LoadMoreArticles event,
    Emitter<NewsState> emit,
  ) async {
    final current = state;
    if (current is! NewsLoaded || !current.hasMore) return;

    emit(NewsPaginating(
      articles: current.articles,
      currentPage: current.currentPage,
    ));

    try {
      final nextPage = current.currentPage + 1;
      final newArticles = await getTopHeadlines(
        category: event.category,
        page: nextPage,
      );
      final allArticles = [...current.articles, ...newArticles];
      emit(NewsLoaded(
        articles: allArticles,
        hasMore: newArticles.length == 20,
        currentPage: nextPage,
      ));
    } catch (e) {
      emit(NewsLoaded(
        articles: current.articles,
        hasMore: current.hasMore,
        currentPage: current.currentPage,
      ));
    }
  }

  Future<void> _onRefreshArticles(
    RefreshArticles event,
    Emitter<NewsState> emit,
  ) async {
    emit(NewsLoading());
    try {
      final articles = await getTopHeadlines(category: event.category, page: 1);
      emit(NewsLoaded(articles: articles, hasMore: articles.length == 20));
    } catch (e) {
      emit(NewsError(e.toString()));
    }
  }
}