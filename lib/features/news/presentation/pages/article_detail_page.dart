import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/article_entity.dart';
import '../widgets/highlighted_text_widget.dart';

class ArticleDetailPage extends StatelessWidget {
  final ArticleEntity article;
  const ArticleDetailPage({super.key, required this.article});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: Stack(
              children: [
                // Image
                SizedBox(
                  height: 380,
                  width: double.infinity,
                  child: CachedNetworkImage(
                    imageUrl: article.urlToImage ?? '',
                    fit: BoxFit.cover,
                    errorWidget: (_, _, _) =>
                        Container(color: const Color(0xFF1A1A2E)),
                  ),
                ),
                // Gradient overlay (bottom portion)
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  height: 380,
                  child: Container(
                    decoration: const BoxDecoration(
                      color: Color(0x44000000),
                    ),
                  ),
                ),
                // Back button
                Positioned(
                  top: MediaQuery.of(context).padding.top + 8,
                  left: 16,
                  child: GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.arrow_back,
                        size: 24, color: Colors.white),
                  ),
                ),
                // Category badge + headline on image
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 14, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.35),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                article.source.name,
                                style: GoogleFonts.roboto(
                                  color: Colors.white,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            Text(
                              article.title,
                              style: GoogleFonts.roboto(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.w800,
                                height: 1.25,
                                letterSpacing: -0.3,
                              ),
                              maxLines: 3,
                              overflow: TextOverflow.ellipsis,
                            ),
                            if (article.description != null) ...[
                              const SizedBox(height: 8),
                              Text(
                                article.description!,
                                style: GoogleFonts.roboto(
                                  color: Colors.white70,
                                  fontSize: 13,
                                  height: 1.4,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ],
                          ],
                        ),
                      ),
                      

                      Container(
                        height: 30,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(20)
                          )
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),

          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
              ),
              transform: Matrix4.translationValues(0, -20, 0),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(20, 24, 20, 32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── Author + read time + views row ──
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.fromLTRB(4, 4, 8, 4),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(20)
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 28,
                                height: 28,
                                decoration: const BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white,
                                ),
                                child: const Icon(Icons.person,
                                    color: Colors.grey, size: 20),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                article.author ?? 'Unknown Author',
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              )
                            ],
                          ),
                        ),

                        SizedBox(width: 10,),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F3F3),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              Icon(Icons.access_time_outlined,
                                  size: 14, color: Colors.black54),
                              SizedBox(width: 6),
                              Text(
                                '2 h',
                                style: GoogleFonts.roboto(
                                    fontSize: 12, fontWeight: FontWeight.w900, color: Colors.black87),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF3F3F3),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            children: [
                              const Icon(Icons.visibility_outlined,
                                  size: 14, color: Colors.black54),
                              const SizedBox(width: 6),
                              Text(
                                '${article.viewCount}',
                                style: GoogleFonts.roboto(
                                    fontSize: 12, fontWeight: FontWeight.w900, color: Colors.black87),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    Text(
                      article.title,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Colors.black,
                        height: 1.3,
                        letterSpacing: -0.2,
                      ),
                    ),

                    const SizedBox(height: 16),

                    HighlightedTextWidget(
                      text: article.content ??
                          article.description ??
                          'No content available for this article.',
                      highlight: '',
                      style: const TextStyle(
                        fontSize: 15,
                        color: Color(0xFF444444),
                        height: 1.7,
                        letterSpacing: 0.1,
                      ),
                    ),

                    const SizedBox(height: 24),

                    if (article.urlToImage != null)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Row(
                          children: [
                            Expanded(
                              child: CachedNetworkImage(
                                imageUrl: article.urlToImage!,
                                height: 120,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: CachedNetworkImage(
                                  imageUrl: article.urlToImage!,
                                  height: 120,
                                  fit: BoxFit.cover,
                                  color: Colors.black26,
                                  colorBlendMode: BlendMode.darken,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}