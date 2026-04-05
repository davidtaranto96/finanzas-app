import 'package:flutter_test/flutter_test.dart';
import 'package:sencillo/app/app.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const SencilloApp());
    expect(find.byType(SencilloApp), findsOneWidget);
  });
}
