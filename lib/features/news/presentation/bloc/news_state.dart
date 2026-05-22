import 'package:equatable/equatable.dart';
import '../../domain/entities/article_entity.dart';

abstract class NewsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class NewsInitial extends NewsState {}
class NewsLoading extends NewsState {}

class NewsLoaded extends NewsState {
  final List<ArticleEntity> articles;
  final bool hasMore;
  final int currentPage;
  NewsLoaded({
    required this.articles,
    this.hasMore = true,
    this.currentPage = 1,
  });
  @override
  List<Object?> get props => [articles, hasMore, currentPage];
}

class NewsPaginating extends NewsState {
  final List<ArticleEntity> articles;
  final int currentPage;
  NewsPaginating({required this.articles, required this.currentPage});
  @override
  List<Object?> get props => [articles, currentPage];
}

class NewsError extends NewsState {
  final String message;
  NewsError(this.message);
  @override
  List<Object?> get props => [message];
}