import 'package:flutter_test/flutter_test.dart';

import 'package:vendion/main.dart';

void main() {
  testWidgets('App shows the login screen', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump();

    expect(find.text('Login'), findsNWidgets(2));
    expect(find.text('Bienvenido a VenDion'), findsOneWidget);
  });
}
