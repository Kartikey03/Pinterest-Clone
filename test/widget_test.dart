/*
 * Smoke test verifying the Pinterest app boots without errors.
 */

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pinterest/app/app.dart';

void main() {
  testWidgets('App renders without crashing', (WidgetTester tester) async {
    await tester.pumpWidget(const ProviderScope(child: PinterestApp()));
    await tester.pump();
    expect(find.byType(PinterestApp), findsOneWidget);
  });
}
