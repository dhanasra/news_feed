import 'dart:math';
import '../../domain/entities/article_entity.dart';
import 'source_model.dart';

class ArticleModel extends ArticleEntity {
  const ArticleModel({
    required super.source,
    super.author,
    required super.title,
    super.description,
    required super.url,
    super.urlToImage,
    super.publishedAt,
    super.content,
    super.viewCount,
  });

  factory ArticleModel.fromJson(Map<String, dynamic> json) {
    return ArticleModel(
      source: SourceModel.fromJson(
        json['source'] as Map<String, dynamic>? ?? {'name': 'Unknown'},
      ),
      author: json['author'] as String?,
      title: (json['title'] as String?) ?? 'No title',
      description: json['description'] as String?,
      url: (json['url'] as String?) ?? '',
      urlToImage: json['urlToImage'] as String?,
      publishedAt: json['publishedAt'] != null
          ? DateTime.tryParse(json['publishedAt'] as String)
          : null,
      content: json['content'] as String?,
      viewCount: Random().nextInt(50000) + 1000, // simulated
    );
  }

  Map<String, dynamic> toJson() => {
    'source': (source as SourceModel).toJson(),
    'author': author,
    'title': title,
    'description': description,
    'url': url,
    'urlToImage': urlToImage,
    'publishedAt': publishedAt?.toIso8601String(),
    'content': content,
    'viewCount': viewCount,
  };
}