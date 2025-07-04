import 'package:google_generative_ai/google_generative_ai.dart';

import '../utils/constants.dart';

class AIService {
  final GenerativeModel? _model;

  AIService()
      : _model = AppConstants.aiApiKey.isNotEmpty
      ? GenerativeModel(
    // *** ALTERAÇÃO PRINCIPAL AQUI ***
    // Voltamos para o nome de modelo mais universal.
    model: 'gemini-1.5-pro-latest',
    apiKey: AppConstants.aiApiKey,
  )
      : null;

  Future<String> getNavigationInstructions(String from, String to) async {
      if (_model == null) {
        return 'Erro: modelo de IA não inicializado.';
      }
    final prompt =
        'Em português, dê instruções de navegação curtas e claras para deficientes visuais irem de "$from" até "$to".';

    try {
      final response = await _model!.generateContent([
        Content.text(prompt),
      ]);
      return response.text ?? 'Não foi possível gerar as instruções. Tente novamente.';
    } catch (e) {

      print('----------- ERRO DA API GEMINI -----------');
      print(e);
      print('-----------------------------------------');

      if (e.toString().contains('API key not valid')) {
        return 'Erro: A sua chave de API é inválida. Por favor, gere uma nova.';
      }
      if (e.toString().contains('403')) {
        return 'Erro: A API não está ativada no seu projeto Google. Verifique o link que foi enviado no chat.';
      }

      return 'Erro ao obter instruções. Verifique sua conexão com a internet e as configurações da API.';
    }
  }
}