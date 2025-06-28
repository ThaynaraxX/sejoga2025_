import 'dart:io';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:record/record.dart'; // Importa o pacote de gravação
import 'package:path_provider/path_provider.dart'; // Para obter o caminho temporário
import 'package:permission_handler/permission_handler.dart'; // Para pedir permissões

class STTService {
  final Record _audioRecorder = Record();
  // SUBSTITUA PELA URL DA SUA API GATEWAY PARA TRANSCRIBE
  static const String _transcribeApiUrl = 'https://41u50sh4y5.execute-api.us-east-2.amazonaws.com/dev';

  Future<bool> _checkAndRequestPermissions() async {
    if (await Permission.microphone.isDenied) {
      final status = await Permission.microphone.request();
      if (status.isDenied) {
        print('Permissão de microfone negada.');
        return false;
      }
    }
    return true;
  }

  Future<String?> startRecording() async {
    if (!await _checkAndRequestPermissions()) {
      return null;
    }

    try {
      // Verifica se o microfone está disponível
      if (await _audioRecorder.hasPermission()) {
        // Obter diretório de cache para salvar o áudio temporariamente
        final Directory appDocDir = await getTemporaryDirectory();
        final String filePath = '${appDocDir.path}/audio_record.webm'; // Formato WEBM com Opus é bom para a web, mas MP3 ou WAV também funcionam

        await _audioRecorder.start(
          path: filePath,
          encoder: AudioEncoder.opus, // WEBM com Opus é um bom formato
          numChannels: 1, // Mono
          samplingRate: 16000, // 16kHz é um bom padrão para voz
        );
        print('Gravação iniciada em: $filePath');
        return filePath;
      }
    } catch (e) {
      print('Erro ao iniciar gravação: $e');
    }
    return null;
  }

  Future<String?> stopRecordingAndTranscribe() async {
    try {
      final String? audioPath = await _audioRecorder.stop();
      if (audioPath == null) {
        print('Nenhum áudio foi gravado.');
        return null;
      }
      print('Gravação parada. Arquivo salvo em: $audioPath');

      // Ler o arquivo de áudio como bytes
      final File audioFile = File(audioPath);
      final List<int> audioBytes = await audioFile.readAsBytes();

      // Codificar os bytes em Base64
      final String audioBase64 = base64Encode(audioBytes);

      // Extrair a extensão do arquivo
      final String fileExtension = audioPath.split('.').last;

      // Enviar para o backend AWS
      final response = await http.post(
        Uri.parse(_transcribeApiUrl),
        headers: {
          'Content-Type': 'application/json',
          // 'x-api-key': 'SUA_API_KEY_AQUI' // Se você configurar API Key no API Gateway
        },
        body: json.encode({
          'audioContent': audioBase64,
          'fileExtension': fileExtension,
        }),
      );

      // Lidar com a resposta
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseBody = json.decode(response.body);
        final String transcribedText = responseBody['transcribedText'];
        print('Texto Transcrito: $transcribedText');
        return transcribedText;
      } else {
        final errorBody = json.decode(response.body);
        print('Erro na API de Transcrição: ${response.statusCode} - ${errorBody['error']}');
        return null;
      }
    } catch (e) {
      print('Erro ao parar gravação ou transcrever: $e');
      return null;
    } finally {
      // Limpar o arquivo temporário após o envio
      final String? audioPath = await _audioRecorder.getPath();
      if (audioPath != null && await File(audioPath).exists()) {
         await File(audioPath).delete();
      }
    }
  }

  Future<void> dispose() async {
    await _audioRecorder.dispose();
  }
}