import 'package:flutter_tts/flutter_tts.dart';

class TextToSpeechService {
    final FlutterTts _tts = FlutterTts();

    TextToSpeechService() {
        _initializeTTS();
    }

    Future<void> _initializeTTS() async {
        await _tts.setLanguage('pt-BR');
        await _tts.setSpeechRate(0.9);
        await _tts.setPitch(1.0);
        await _tts.setVolume(1.0);

        // Essencial para Android com TalkBack ativado
        await _tts.awaitSpeakCompletion(true);
    }

    Future<void> speak(String text) async {
        await stop(); // Garante que a fala anterior seja interrompida
        await _tts.speak(text);
    }

    Future<void> stop() async {
        await _tts.stop();
    }
}
