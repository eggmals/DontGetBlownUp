import 'package:flutter_test/flutter_test.dart';
import 'package:uas_pemrogramanbergerak/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const DontGetBlownUpApp());
    expect(find.byType(DontGetBlownUpApp), findsOneWidget);
  });
}