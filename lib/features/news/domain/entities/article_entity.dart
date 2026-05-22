import 'package:equatable/equatable.dart';
import 'source_entity.dart';

class ArticleEntity extends Equatable {
  final SourceEntity source;
  final String? author;
  final String title;
  final String? description;
  final String url;
  final String? urlToImage;
  final DateTime? publishedAt;
  final String? content;
  final int viewCount;

  const ArticleEntity({
    required this.source,
    this.author,
    required this.title,
    this.description,
    required this.url,
    this.urlToImage,
    this.publishedAt,
    this.content,
    this.viewCount = 0,
  });

  @override
  List<Object?> get props => [url, title];
}