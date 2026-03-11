// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:liveness_app/main.dart';

void main() {
  testWidgets('LivenessAIApp smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const LivenessAIApp());

    // Wait for splash screen to complete and navigate to main screen
    await tester.pumpAndSettle(const Duration(seconds: 4));

    // Verify that our app shows the main screen with camera preview
    expect(find.text('LivenessAI'), findsOneWidget);
    expect(find.text('Verify Liveness'), findsOneWidget);
    expect(find.text('Upload Photo'), findsOneWidget);
  });
}
