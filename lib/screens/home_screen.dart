import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import '../models/access_point.dart';
import '../models/beacon_location.dart';
import '../services/ai_service.dart';
import '../services/beacon_service.dart';
import '../services/localization_service.dart';
import '../services/text_to_speech_service.dart';
import '../services/wifi_service.dart';
import '../utils/accessibility_utils.dart';
import '../widgets/instruction_card.dart';
import '../widgets/location_button.dart';
import '../services/stt_service.dart'; // Adicione esta linha

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final AIService aiService;
  late final TextToSpeechService ttsService;
  late final LocalizationService localizationService;
  late final WifiService wifiService;
  late BeaconService beaconService;
  late final STTService sttService; // Adicione esta linha

  String currentInstruction = 'Toque para começar a navegação';
  String currentLocation = 'Local desconhecido';
  String selectedMethod = 'bluetooth';
  List<BeaconLocation> beaconLocations = [];
  List<AccessPoint> accessPoints = [];

  bool _isRecording = false; // Adicione esta linha para controlar o estado da gravação
  String _transcribedText = ''; // Adicione esta linha para armazenar o texto transcrito

  @override
  void initState() {
    super.initState();
    aiService = AIService();
    ttsService = TextToSpeechService();
    localizationService = LocalizationService();
    wifiService = WifiService();
    sttService = STTService(); // Inicialize o novo serviço STT aqui
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    beaconLocations = await localizationService.loadBeaconLocations();
    accessPoints = await localizationService.loadAccessPoints();
    beaconService = BeaconService(beaconLocations: beaconLocations);
    if (mounted) {
      setState(() {});
    }
  }

  Future<void> _detectLocation() async {
    final status = await Permission.location.request();

    if (!status.isGranted) {
      await ttsService.speak('Permissão de localização negada. Por favor, permita nas configurações.');
      setState(() => currentLocation = 'Permissão negada');
      return;
    }

    final aps = await wifiService.scanWifiNetworks();
    print('REDES ENCONTRADAS: ${aps.map((e) => e.bssid).toList()}');

    for (final ap in aps) {
      final matches = accessPoints.where(
            (a) => a.bssid.toLowerCase() == ap.bssid.toLowerCase(),
      ).toList();

      if (matches.isNotEmpty) {
        final match = matches.first;
        final location = match.room ?? 'Perto do ${match.ssid}';
        setState(() => currentLocation = location);
        await _getInstructions('Posição atual', location);
        break;
      }
    }
  }

  Future<void> _getInstructions(String from, String to) async {
    final instructions = await aiService.getNavigationInstructions(from, to);
    setState(() => currentInstruction = instructions);
    await ttsService.speak(instructions);
    AccessibilityUtils.announce(context, instructions);
  }

  Future<void> _showMethodDialog() async {
    final method = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Selecione o método'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('Bluetooth (Beacons)'),
              leading: const Icon(Icons.bluetooth),
              onTap: () => Navigator.pop(context, 'bluetooth'),
            ),
            ListTile(
              title: const Text('WiFi'),
              leading: const Icon(Icons.wifi),
              onTap: () => Navigator.pop(context, 'wifi'),
            ),
          ],
        ),
      ),
    );

    if (method != null && method != selectedMethod) {
      setState(() => selectedMethod = method);
      await ttsService.speak(
        'Método selecionado: ${method == 'bluetooth' ? 'Bluetooth' : 'Wi-Fi'}',
      );
    }
  }

  // FUNÇÃO _toggleRecording MOVIDA PARA O LOCAL CORRETO DENTRO DA CLASSE _HomeScreenState
  Future<void> _toggleRecording() async {
    if (_isRecording) {
      // Parar gravação e transcrever
      final String? text = await sttService.stopRecordingAndTranscribe();
      if (text != null) {
        setState(() {
          _transcribedText = text;
          currentInstruction = 'Texto Transcrito: $text'; // Atualiza a instrução principal
          // Aqui você passaria o 'text' para o seu AIService para obter instruções
          _getInstructions(currentLocation, text); // Adapte para o seu AIService
        });
        AccessibilityUtils.announce(context, 'Transcrição: $text');
      } else {
        setState(() {
          currentInstruction = 'Não foi possível transcrever.';
        });
      }
    } else {
      // Iniciar gravação
      final String? path = await sttService.startRecording();
      if (path != null) {
        setState(() {
          currentInstruction = 'Gravando... Fale seu comando.';
        });
        AccessibilityUtils.announce(context, 'Gravando. Fale seu comando.');
      } else {
        setState(() {
          currentInstruction = 'Erro ao iniciar gravação.';
        });
      }
    }
    setState(() {
      _isRecording = !_isRecording;
    });
  }

  @override
  void dispose() {
    beaconService.stopScan();
    ttsService.stop();
    sttService.dispose(); // Não esqueça de liberar os recursos do gravador!
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lumen'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            tooltip: 'Configurações',
            onPressed: () {
              ttsService.speak('Configurações');
              _showMethodDialog();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            InstructionCard(
              instruction: currentInstruction,
              onTap: () => ttsService.speak(currentInstruction),
            ),
            const SizedBox(height: 20),
            Text(
              'Método: ${selectedMethod == 'bluetooth' ? 'Bluetooth' : 'WiFi'}',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 10),
            Text(
              'Localização: $currentLocation',
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 30),
            // Botão "Detectar Localização Atual" - REMOVIDA A DUPLICAÇÃO
            ElevatedButton(
              onPressed: () async {
                await ttsService.speak('Detectar Localização Atual');
                await _detectLocation();
              },
              child: const Text('Detectar Localização Atual'),
            ),
            const SizedBox(height: 20),
            // Botão para iniciar/parar gravação
            ElevatedButton(
              onPressed: _toggleRecording,
              style: ElevatedButton.styleFrom(
                backgroundColor: _isRecording ? Colors.red : Colors.green,
              ),
              child: Text(_isRecording ? 'Parar Gravação e Transcrever' : 'Iniciar Comando de Voz'),
            ),
            if (_transcribedText.isNotEmpty) ...[
              const SizedBox(height: 20),
              Text(
                'Último Comando Transcrito: "$_transcribedText"',
                style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
            ],
            const SizedBox(height: 20),
            // Lista de botões de localização - REMOVIDA A DUPLICAÇÃO
            ...beaconLocations.map(
              (location) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8.0),
                child: LocationButton(
                  locationName: location.name,
                  onPressed: () async {
                    await ttsService.speak(location.name);
                    await _getInstructions(currentLocation, location.name);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}