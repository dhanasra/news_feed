import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app/core/utils/extensions.dart';
import '../bloc/news_bloc.dart';
import '../bloc/news_event.dart';
import '../bloc/news_state.dart';
import '../bloc/search_bloc.dart';
import '../bloc/search_event.dart';
import '../bloc/search_state.dart';
import '../widgets/loading_shimmer.dart';
import '../../domain/entities/article_entity.dart';
import 'article_detail_page.dart';

const _categories = ['Health', 'Politics', 'Art', 'Food', 'Technology', 'Sports'];

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({super.key});
  @override
  State<DiscoverPage> createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    context.read<NewsBloc>().add(LoadArticles(category: 'health'));
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Row(
                children: [
                  const Icon(Icons.menu, size: 26),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 4),
              child: Text(
                'Discover',
                style: GoogleFonts.roboto(
                  fontSize: 32,
                  fontWeight: FontWeight.w900,
                  color: Colors.black,
                  letterSpacing: -0.5,
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(20, 0, 20, 16),
              child: Text(
                'News from all over the world',
                style: GoogleFonts.roboto(fontSize: 14, color: Colors.black45),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3F3F3),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    const SizedBox(width: 14),
                    const Icon(Icons.search, color: Colors.black38, size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: TextField(
                        controller: _searchController,
                        decoration: const InputDecoration(
                          hintText: 'Search',
                          hintStyle: TextStyle(color: Colors.black38, fontSize: 15),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                        style: const TextStyle(fontSize: 15),
                        onChanged: (q) =>
                            context.read<SearchBloc>().add(SearchQueryChanged(q)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(right: 14),
                      child: Icon(Icons.tune, color: Colors.black45, size: 20),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            DefaultTabController(
              length: _categories.length,
              child: TabBar(
                isScrollable: true,
                tabAlignment: TabAlignment.start,

                indicatorSize: TabBarIndicatorSize.label,

                indicatorColor: Colors.black,
                indicatorWeight: 2.5,

                dividerColor: Colors.transparent,

                labelPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                ),

                labelStyle: GoogleFonts.roboto(
                  fontSize: 18,
                  fontWeight: FontWeight.w900,
                ),

                unselectedLabelStyle: GoogleFonts.roboto(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),

                labelColor: Colors.black,
                unselectedLabelColor: Colors.black38,

                onTap: (index) {
                  final category = _categories[index];
                  context.read<NewsBloc>().add(
                    LoadArticles(
                      category: category.toLowerCase(),
                    ),
                  );
                },
                tabs: _categories.map((cat) {
                  return Tab(text: cat);
                }).toList(),
              ),
            ),

            const Divider(height: 1, color: Color(0xFFEEEEEE)),
            const SizedBox(height: 8),

            // ── Article list ──
            Expanded(
              child: BlocBuilder<SearchBloc, SearchState>(
                builder: (context, searchState) {
                  if (searchState is SearchLoading) return const LoadingShimmer();

                  if (searchState is SearchLoaded) {
                    return _ArticleList(
                      articles: searchState.articles,
                      onTap: (a) => _openDetail(context, a),
                    );
                  }

                  return BlocBuilder<NewsBloc, NewsState>(
                    builder: (context, state) {
                      if (state is NewsLoading) return const LoadingShimmer();

                      final articles = state is NewsLoaded
                          ? state.articles
                          : state is NewsPaginating
                              ? state.articles
                              : <ArticleEntity>[];

                      return _ArticleList(
                        articles: articles,
                        onTap: (a) => _openDetail(context, a),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _openDetail(BuildContext context, ArticleEntity article) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => ArticleDetailPage(article: article)),
    );
  }
}

class _ArticleList extends StatelessWidget {
  final List<ArticleEntity> articles;
  final void Function(ArticleEntity) onTap;
  const _ArticleList({required this.articles, required this.onTap});

  @override
  Widget build(BuildContext context) {
    if (articles.isEmpty) {
      return const Center(child: Text('No articles found.'));
    }
    return ListView.separated(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      itemCount: articles.length,
      separatorBuilder: (_, _) => const Divider(height: 1, color: Color(0xFFF0F0F0)),
      itemBuilder: (context, i) => _DiscoverRow(
        article: articles[i],
        onTap: () => onTap(articles[i]),
      ),
    );
  }
}

class _DiscoverRow extends StatelessWidget {
  final ArticleEntity article;
  final VoidCallback onTap;
  const _DiscoverRow({required this.article, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Thumbnail
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: article.urlToImage ?? '',
                width: 72,
                height: 72,
                fit: BoxFit.cover,
                errorWidget: (_, _, _) => Container(
                  width: 72,
                  height: 72,
                  color: const Color(0xFFEEEEEE),
                  child: const Icon(Icons.image_not_supported_outlined,
                      color: Colors.black26),
                ),
              ),
            ),
            const SizedBox(width: 14),
            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    article.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.roboto(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Colors.black,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Row(
                    children: [
                      const Icon(Icons.access_time_outlined,
                          size: 12, color: Colors.black38),
                      const SizedBox(width: 3),
                      Text(
                        article.publishedAt != null
                            ? article.publishedAt!.timeAgo
                            : '',
                        style: GoogleFonts.roboto(
                            fontSize: 12, color: Colors.black38),
                      ),
                      const SizedBox(width: 12),
                      const Icon(Icons.visibility_outlined,
                          size: 12, color: Colors.black38),
                      const SizedBox(width: 3),
                      Text(
                        '${article.viewCount} views',
                        style: GoogleFonts.roboto(
                            fontSize: 12, color: Colors.black38),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
