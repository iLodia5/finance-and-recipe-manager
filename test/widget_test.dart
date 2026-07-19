import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:finance_track/main.dart';

void main() {
  testWidgets('App loads smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const FinanceTrackApp(initialScreen: Scaffold(body: Text('Test'))),
    );

    // Verify that our app loads successfully.
    expect(find.text('Test'), findsOneWidget);
  });
}
