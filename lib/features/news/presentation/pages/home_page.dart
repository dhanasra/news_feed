import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app/core/utils/extensions.dart';
import '../bloc/news_bloc.dart';
import '../bloc/news_event.dart';
import '../bloc/news_state.dart';
import '../controllers/pagination_controller.dart';
import '../widgets/breaking_card.dart';
import '../widgets/hero_banner.dart';
import '../widgets/loading_shimmer.dart';
import '../../../../core/widgets/app_error_widget.dart';
import '../../domain/entities/article_entity.dart';
import 'article_detail_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late PaginationController _paginationController;

  @override
  void initState() {
    super.initState();
    context.read<NewsBloc>().add(LoadArticles());
    _paginationController = PaginationController(
      onPaginate: () {
        final state = context.read<NewsBloc>().state;
        if (state is NewsLoaded && state.hasMore) {
          context.read<NewsBloc>().add(LoadMoreArticles());
        }
      },
    );
  }

  @override
  void dispose() {
    _paginationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: BlocBuilder<NewsBloc, NewsState>(
        builder: (context, state) {
          if (state is NewsLoading) return const LoadingShimmer();
          if (state is NewsError) {
            return AppErrorWidget(
              message: state.message,
              onRetry: () => context.read<NewsBloc>().add(LoadArticles()),
            );
          }

          final articles = state is NewsLoaded
              ? state.articles
              : state is NewsPaginating
                  ? state.articles
                  : <ArticleEntity>[];

          if (articles.isEmpty) return const Center(child: Text('No articles found.'));

          return RefreshIndicator(
            onRefresh: () async => context.read<NewsBloc>().add(RefreshArticles()),
            child: CustomScrollView(
              controller: _paginationController.scrollController,
              slivers: [

                SliverToBoxAdapter(
                  child: HeroCard(
                    article: articles[0],
                    onTap: () => _openDetail(context, articles[0]),
                  ),
                ),

                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(20, 28, 20, 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                         Text(
                          'Breaking News',
                          style: GoogleFonts.roboto(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: Colors.black,
                            letterSpacing: -0.3,
                          ),
                        ),
                        GestureDetector(
                          onTap: () {},
                          child: const Text(
                            'More',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.black54,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                if (articles.length > 1)
                  SliverToBoxAdapter(
                    child: SizedBox(
                      height: 260,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        itemCount: (articles.length - 1).clamp(0, 6),
                        separatorBuilder: (_, _) => const SizedBox(width: 14),
                        itemBuilder: (context, i) {
                          final article = articles[i + 1];
                          return BreakingCard(
                            article: article,
                            onTap: () => _openDetail(context, article),
                          );
                        },
                      ),
                    ),
                  ),

                if (articles.length > 7)
                  SliverPadding(
                    padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, i) {
                          if (i >= articles.length - 7) {
                            return state is NewsPaginating
                                ? const Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Center(child: CircularProgressIndicator()),
                                  )
                                : const SizedBox.shrink();
                          }
                          final article = articles[i + 7];
                          return _ListArticleRow(
                            article: article,
                            onTap: () => _openDetail(context, article),
                          );
                        },
                        childCount: articles.length - 7 + (state is NewsPaginating ? 1 : 0),
                      ),
                    ),
                  ),

                const SliverToBoxAdapter(child: SizedBox(height: 32)),
              ],
            ),
          );
        },
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

class _ListArticleRow extends StatelessWidget {
  final ArticleEntity article;
  final VoidCallback onTap;
  const _ListArticleRow({required this.article, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 18),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: CachedNetworkImage(
                imageUrl: article.urlToImage ?? '',
                width: 76,
                height: 76,
                fit: BoxFit.cover,
                errorWidget: (_, _, _) =>
                    Container(width: 76, height: 76, color: const Color(0xFFEEEEEE)),
              ),
            ),
            const SizedBox(width: 12),
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
                      height: 1.3,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    article.publishedAt != null ? article.publishedAt!.timeAgo : '',
                    style: GoogleFonts.roboto(fontSize: 12, color: Colors.black45),
                  ),
                  if (article.author != null)
                    Text(
                      'By ${article.author}',
                      style: GoogleFonts.roboto(fontSize: 12, color: Colors.black45),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
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