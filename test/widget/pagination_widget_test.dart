import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:news_app/features/news/presentation/controllers/pagination_controller.dart';

void main() {
  testWidgets('pagination callback triggers at 80% scroll depth', (tester) async {
    bool paginateCalled = false;

    late PaginationController controller;
    controller = PaginationController(
      threshold: 0.8,
      onPaginate: () => paginateCalled = true,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ListView.builder(
            controller: controller.scrollController,
            itemCount: 50,
            itemExtent: 100,
            itemBuilder: (_, i) => ListTile(title: Text('Item $i')),
          ),
        ),
      ),
    );

    // Scroll to 85% of list
    await tester.drag(
      find.byType(ListView),
      const Offset(0, -3400), // 85% of 50 * 100 = 4250px total
    );
    await tester.pump();

    expect(paginateCalled, isTrue);
    controller.dispose();
  });
}