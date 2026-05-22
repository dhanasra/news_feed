import 'package:flutter_test/flutter_test.dart';
import 'package:news_app/features/news/isolates/article_parser_isolate.dart';

void main() {
  test('parseArticlesInIsolate parses valid JSON correctly', () async {
    final json = {
      'articles': [
        {
          'source': {'id': 'bbc', 'name': 'BBC'},
          'author': 'John Doe',
          'title': 'Test headline',
          'description': 'A description',
          'url': 'https://bbc.com/article',
          'urlToImage': null,
          'publishedAt': '2024-01-01T00:00:00Z',
          'content': 'Article content here.',
        }
      ]
    };

    final articles = await parseArticlesInIsolate(json);

    expect(articles.length, 1);
    expect(articles[0].title, 'Test headline');
    expect(articles[0].source.name, 'BBC');
  });

  test('parseArticlesInIsolate filters out [Removed] articles', () async {
    final json = {
      'articles': [
        {
          'source': {'id': null, 'name': 'Unknown'},
          'title': '[Removed]',
          'url': 'https://example.com',
          'publishedAt': null,
        }
      ]
    };

    final articles = await parseArticlesInIsolate(json);
    expect(articles.isEmpty, true);
  });
}