import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sejoga2025_certo/main.dart';
import 'package:sejoga2025_certo/widgets/location_button.dart';

void main() {
  testWidgets('home screen shows initial instruction', (WidgetTester tester) async {
    await tester.pumpWidget(const SeJogaApp()); // Use const se o construtor for const

    expect(find.text('Toque para começar a navegação'), findsOneWidget);
    expect(find.text('Detectar Localização Atual'), findsOneWidget);
  });

  testWidgets('tts is called when detecting current location', (WidgetTester tester) async {
    const channel = MethodChannel('flutter_tts');
    final calls = <MethodCall>[];
    channel.setMockMethodCallHandler((MethodCall call) async {
      calls.add(call);
      return null;
    });

    await tester.pumpWidget(const SeJogaApp());

    await tester.tap(find.text('Detectar Localização Atual'));
    await tester.pump();

    expect(calls.where((c) => c.method == 'speak').isNotEmpty, isTrue);

    channel.setMockMethodCallHandler(null);
  });

  testWidgets('tts is called when pressing a location button', (WidgetTester tester) async {
    const channel = MethodChannel('flutter_tts');
    final calls = <MethodCall>[];
    channel.setMockMethodCallHandler((MethodCall call) async {
      calls.add(call);
      return null;
    });

    await tester.pumpWidget(const SeJogaApp());
    await tester.pumpAndSettle();

    // Tap the first location button
    final locationButton = find.byType(LocationButton).first;
    await tester.tap(locationButton);
    await tester.pump();

    expect(calls.where((c) => c.method == 'speak').isNotEmpty, isTrue);

    channel.setMockMethodCallHandler(null);
  });
}


