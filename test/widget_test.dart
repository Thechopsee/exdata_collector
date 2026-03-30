import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:exdata_collector/main.dart';
import 'package:exdata_collector/Services/ConfigProvider.dart';
import 'package:provider/provider.dart';

void main() {
  testWidgets('App starts smoke test', (WidgetTester tester) async {
    final configProvider = ConfigProvider();
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ChangeNotifierProvider(
        create: (context) => configProvider,
        child: const MyApp(),
      ),
    );

    // Verify that our app title is present.
    expect(find.text('EXCategory Data Saver'), findsAtLeastNWidgets(1));
  });
}
