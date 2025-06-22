import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../models/beacon_location.dart';

class BeaconService {
    final List<BeaconLocation> beaconLocations;

    BeaconService({required this.beaconLocations});

    Stream<BeaconLocation> scanBeacons() async* {
        await FlutterBluePlus.startScan(timeout: const Duration(seconds: 4));

        await for (var scanResult in FlutterBluePlus.scanResults) {
            for (var result in scanResult) {
                final beacon = beaconLocations.firstWhere(
                        (b) => result.device.name == b.id,
                    orElse: () => BeaconLocation(id: '0', name: 'Desconhecido'),
                );
                yield beacon;
                return; // interrompe após o primeiro achado
            }
        }
    }

    void stopScan() {
        FlutterBluePlus.stopScan();
    }
}
