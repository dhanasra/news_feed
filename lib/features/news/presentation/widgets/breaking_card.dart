import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:news_app/core/utils/extensions.dart';

import '../../domain/entities/article_entity.dart';

class BreakingCard extends StatelessWidget {
  final ArticleEntity article;
  final VoidCallback onTap;
  const BreakingCard({super.key, required this.article, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: 160,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: CachedNetworkImage(
                imageUrl: article.urlToImage ?? '',
                width: 160,
                height: 160,
                fit: BoxFit.cover,
                errorWidget: (_, _, _) =>
                    Container(width: 160, height: 160, color: const Color(0xFFEEEEEE)),
              ),
            ),
            const SizedBox(height: 8),
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
            const SizedBox(height: 4),
            Text(
              article.publishedAt != null
                  ? article.publishedAt!.timeAgo
                  : '',
              style: GoogleFonts.roboto(fontSize: 12, color: Colors.black45),
            ),
            if (article.author != null)
              Text(
                'By ${article.author}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.roboto(fontSize: 12, color: Colors.black45),
              ),
          ],
        ),
      ),
    );
  }
}