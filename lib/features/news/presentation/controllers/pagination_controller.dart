import 'package:flutter/widgets.dart';

class PaginationController {
  final ScrollController scrollController = ScrollController();
  final double threshold;
  final VoidCallback onPaginate;

  PaginationController({
    this.threshold = 0.8,
    required this.onPaginate,
  }) {
    scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    final pos = scrollController.position;
    final scrollFraction = pos.pixels / pos.maxScrollExtent;
    if (scrollFraction >= threshold) {
      onPaginate();
    }
  }

  void dispose() {
    scrollController.removeListener(_onScroll);
    scrollController.dispose();
  }
}