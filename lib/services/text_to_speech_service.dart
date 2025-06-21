import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeechService {
    final FlutterTts tts = FlutterTts();

    Future<void> speak(String text) async {
        await tts.setLanguage('pt-BR');
        await tts.setPitch(1.0);
        await tts.setSpeechRate(0.5);
        await tts.speak(text);
    }

    Future<void> stop() async {
        await tts.stop();
    }
}