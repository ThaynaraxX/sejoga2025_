import 'package:flutter/material.dart';

import 'package:sejoga2025_certo/models/access_point.dart';
import 'package:sejoga2025_certo/models/beacon_location.dart';
import 'package:sejoga2025_certo/services/ai_service.dart';
import 'package:sejoga2025_certo/services/beacon_service.dart';
import 'package:sejoga2025_certo/services/localization_service.dart';
import 'package:sejoga2025_certo/services/text_to_speech_service.dart';
import 'package:sejoga2025_certo/services/wifi_service.dart';
import 'package:sejoga2025_certo/utils/accessibility_utils.dart';
import 'package:sejoga2025_certo/widgets/instruction_card.dart';
import 'package:sejoga2025_certo/widgets/location_button.dart';

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

  String currentInstruction = 'Toque para começar a navegação';
  String currentLocation = 'Local desconhecido';
  String selectedMethod = 'bluetooth';
  List<BeaconLocation> beaconLocations = [];
  List<AccessPoint> accessPoints = [];

  @override
  void initState() {
    super.initState();
    aiService = AIService();
    ttsService = TextToSpeechService();
    localizationService = LocalizationService();
    wifiService = WifiService();
    _initializeServices();
  }

  Future<void> _initializeServices() async {
    beaconLocations = await localizationService.loadBeaconLocations();
    accessPoints = await localizationService.loadAccessPoints();
    beaconService = BeaconService(beaconLocations: beaconLocations);
  }

  Future<void> _detectLocation() async {
    if (selectedMethod == 'bluetooth') {
      final beacon = await beaconService.scanBeacons().first;
      setState(() => currentLocation = beacon.name);
      _getInstructions('Posição atual', beacon.name);
    } else {
      final aps = await wifiService.scanWifiNetworks();
      if (aps.isNotEmpty) {
        setState(() => currentLocation = 'Perto do ${aps[0].ssid}');
        _getInstructions('Posição atual', 'Perto do ${aps[0].ssid}');
      }
    }
  }

  Future<void> _getInstructions(String from, String to) async {
    final instructions = await aiService.getNavigationInstructions(from, to);
    setState(() => currentInstruction = instructions);
    await ttsService.speak(instructions);
    AccessibilityUtils.announce(context, instructions);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Navegação Indoor'),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: _showMethodDialog,
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
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
              ElevatedButton(
                onPressed: _detectLocation,
                child: const Text('Detectar Localização Atual'),
              ),
              const SizedBox(height: 20),
              ...beaconLocations.map(
                (location) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: LocationButton(
                    locationName: location.name,
                    onPressed: () =>
                        _getInstructions(currentLocation, location.name),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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

    if (method != null) {
      setState(() => selectedMethod = method);
    }
  }

  @override
  void dispose() {
    beaconService.stopScan();
    ttsService.stop();
    super.dispose();
  }
}
