import 'package:equatable/equatable.dart';

abstract class NewsEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class LoadArticles extends NewsEvent {
  final String category;
  LoadArticles({this.category = 'technology'});
  @override
  List<Object?> get props => [category];
}

class LoadMoreArticles extends NewsEvent {
  final String category;
  LoadMoreArticles({this.category = 'technology'});
  @override
  List<Object?> get props => [category];
}

class RefreshArticles extends NewsEvent {
  final String category;
  RefreshArticles({this.category = 'technology'});
  @override
  List<Object?> get props => [category];
}