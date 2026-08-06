import 'package:flutter_test/flutter_test.dart';

import 'package:universe/main.dart';

void main() {
  testWidgets('Splash screen shows the UniVerse logo', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const UniVerseApp());

    expect(find.text('UniVerse'), findsOneWidget);

    // Let the splash animation and its navigation timer fire so nothing
    // leaks into the next test.
    await tester.pump(const Duration(seconds: 4));
  });
}
