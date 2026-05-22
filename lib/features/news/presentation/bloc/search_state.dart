import 'package:equatable/equatable.dart';
import '../../domain/entities/article_entity.dart';

abstract class SearchState extends Equatable {
  @override
  List<Object?> get props => [];
}

class SearchInitial extends SearchState {}
class SearchLoading extends SearchState {}

class SearchLoaded extends SearchState {
  final List<ArticleEntity> articles;
  SearchLoaded(this.articles);
  @override
  List<Object?> get props => [articles];
}

class SearchError extends SearchState {
  final String message;
  SearchError(this.message);
  @override
  List<Object?> get props => [message];
}