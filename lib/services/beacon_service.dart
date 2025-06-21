import 'package:flutter_blue_plus/flutter_blue_plus.dart';
import '../models/beacon_location.dart';

class BeaconService {
    final List<BeaconLocation> beaconLocations;

    BeaconService({required this.beaconLocations});

    Stream<BeaconLocation> scanBeacons() async* {
        await FlutterBluePlus.adapterState
            .where((state) => state == BluetoothAdapterState.on)
            .first;

        await FlutterBluePlus.startScan(timeout: const Duration(seconds: 10));

        await for (final results in FlutterBluePlus.scanResults) {
            for (final result in results) {
                for (final beacon in beaconLocations) {
                    if (result.device.remoteId.toString() == beacon.id) {
                        yield beacon;
                    }
                }
            }
        }
    }

    Future<void> stopScan() async {
        await FlutterBluePlus.stopScan();
    }
}
