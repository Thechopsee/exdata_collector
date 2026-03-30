import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:exdata_collector/main.dart';

void main() {
  testWidgets('App starts smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp(initialLocale: Locale('cs')));

    // Verify that our app title is present.
    expect(find.text('EXCategory Data Saver'), findsAtLeastNWidgets(1));
  });
}
