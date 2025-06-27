import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sejoga2025_certo/screens/home_screen.dart';

void main() {
  testWidgets('home screen renders initial UI elements', (WidgetTester tester) async {
    await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

    expect(find.text('Navegação Indoor'), findsOneWidget);
    expect(find.text('Toque para começar a navegação'), findsOneWidget);
    expect(find.text('Detectar Localização Atual'), findsOneWidget);
  });
}
