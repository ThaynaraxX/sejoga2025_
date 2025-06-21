import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import 'package:navegacao_indoor_visual/models/beacon_location.dart';

class BeaconService {
    final List<BeaconLocation> beaconLocations;

    BeaconService({required this.beaconLocations});

    Stream<BeaconLocation> scanBeacons() async* {
        await FlutterBluePlus.adapterState
            .where((state) => state == BluetoothAdapterState.on)
            .first;

        await FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));

        var flutterBluePlus = FlutterBluePlus;
        await for (ScanResult result in flutterBluePlus.scanResults) {
            for (var beacon in beaconLocations) {
                if (result.device.remoteId.toString() == beacon.id) {
                    yield beacon;
                }
            }
        }
    }

    Future<void> stopScan() async {
        await FlutterBluePlus.stopScan();
    }
}

extension on Type {
  get scanResults => null;
}