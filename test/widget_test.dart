import 'package:flutter_test/flutter_test.dart';
import 'package:sejoga2025_certo/main.dart';

void main() {
  testWidgets('home screen shows initial instruction', (WidgetTester tester) async {
    await tester.pumpWidget(const SeJogaApp()); // Use const se o construtor for const

    expect(find.text('Toque para começar a navegação'), findsOneWidget);
    expect(find.text('Detectar Localização Atual'), findsOneWidget);
  });
}

