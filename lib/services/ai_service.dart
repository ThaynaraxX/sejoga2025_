import 'package:google_generative_ai/google_generative_ai.dart';
import '../utils/constants.dart';

class AIService {
  late final GenerativeModel model;

  AIService() {
    model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: AppConstants.aiApiKey,
    );
  }

  Future<String> getNavigationInstructions(String from, String to) async {
    final prompt = """
    Você é um assistente de navegação para deficientes visuais.
    Forneça instruções claras e concisas para ir de '$from' para '$to'.
    """;

    final content = [Content.text(prompt)];
    final response = await model.generateContent(content);

    return response.text ?? 'Não foi possível gerar instruções.';
  }
}
