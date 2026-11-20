
import 'package:flutter_test/flutter_test.dart';
import 'package:pizzamine/app/app.dart';

void main() {
  testWidgets('Pizzamine home screen loads successfully', (tester) async {
    await tester.pumpWidget(const PizzamineApp());

    expect(find.text('Pizzamine'), findsOneWidget);
    expect(find.text('Welcome to Pizzamine!'), findsOneWidget);
  });
}