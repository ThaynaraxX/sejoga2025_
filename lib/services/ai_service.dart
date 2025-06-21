import 'package:google_generative_ai/google_generative_ai.dart';
import '../utils/constants.dart';

class AIService {
  late final GenerativeModel model;

  AIService() {
    model = GenerativeModel(
      model: 'gemini-pro',
      apiKey: ApiKey(AppConstants.aiApiKey), // Corrigido aqui
    );
  }

  Future<String> getNavigationInstructions(String from, String to) async {
    final prompt = """
Você é um assistente de navegação para deficientes visuais.
Forneça instruções claras e concisas para ir de '$from' para '$to'.
Use referências táteis, sonoras e distâncias aproximadas em passos.
Seja específico sobre direções e pontos de referência.
""";

    try {
      final response = await model.generateContent([Content.text(prompt)]);
      return response.text ?? 'Não foi possível gerar instruções.';
    } catch (e) {
      return 'Erro ao conectar com o serviço de IA: $e';
    }
  }
}
