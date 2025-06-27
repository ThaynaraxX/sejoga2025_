import 'package:flutter/material.dart';
import '../utils/accessibility_utils.dart';
import '../services/text_to_speech_service.dart';

class LocationButton extends StatelessWidget {
  final String locationName;
  final VoidCallback onPressed;

  const LocationButton({
    super.key,
    required this.locationName,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Navegar para $locationName',
      child: ElevatedButton(
        onPressed: () async {
          // Fala o nome do botão ao pressionar
          final tts = TextToSpeechService(); // novo a cada vez ou use Singleton se preferir
          await tts.speak(locationName);

          AccessibilityUtils.announce(context, 'Navegar para $locationName');
          onPressed();
        },
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: AccessibilityUtils.accessibleText(
            locationName,
            style: const TextStyle(fontSize: 16.0),
          ),
        ),
      ),
    );
  }
}
