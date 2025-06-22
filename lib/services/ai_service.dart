import 'package:google_generative_ai/google_generative_ai.dart';

class AIService {
  final _model = GenerativeModel(
    model: 'gemini-pro',
    apiKey: 'AIzaSyDqAX0rvw7ogg2h8KAY2hZzlk9h6Xcsku8',
  );

  Future<String> getNavigationInstructions(String from, String to) async {
    final prompt = 'Quais instruções simples eu posso dar para ir de "$from" até "$to"?';
    final response = await _model.generateContent([
      Content.text(prompt),
    ]);

    return response.text ?? 'Nenhuma instrução encontrada.';
  }
}
