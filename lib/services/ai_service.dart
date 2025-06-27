import 'package:google_generative_ai/google_generative_ai.dart';

import '../utils/constants.dart';

class AIService {
  final GenerativeModel? _model;

  AIService() :
        _model = AppConstants.aiApiKey.isNotEmpty
            ? GenerativeModel(
          model: 'gemini-pro',
          apiKey: AppConstants.aiApiKey,
        )
            : null;

  Future<String> getNavigationInstructions(String from, String to) async {
    if (_model == null) {
      return 'Chave AI_API_KEY não configurada.';
    }

    final prompt =
        'Quais instruções simples eu posso dar para ir de "$from" até "$to"?';

    try {
      final response = await _model!.generateContent([
        Content.text(prompt),
      ]);
      return response.text ?? 'Nenhuma instrução encontrada.';
    } catch (_) {
      return 'Erro ao obter instruções.';
    }
  }
}