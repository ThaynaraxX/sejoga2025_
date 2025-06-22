import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeechService {
    final FlutterTts _tts = FlutterTts();

    TextToSpeechService() {
        _tts.setLanguage('pt-BR');
        _tts.setSpeechRate(0.9);
    }

    Future<void> speak(String text) async {
        await _tts.speak(text);
    }

    Future<void> stop() async {
        await _tts.stop();
    }
}
