import 'package:flutter_test/flutter_test.dart';
import 'package:human_heal/main.dart';

void main() {
  testWidgets('HumanHealApp basic smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const HumanHealApp());

    // Verify that the app widget is pumped successfully
    expect(find.byType(HumanHealApp), findsOneWidget);
  });
}
