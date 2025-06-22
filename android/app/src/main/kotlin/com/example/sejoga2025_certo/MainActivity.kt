package com.example.sejoga2025_certo

import android.content.Context
import android.net.wifi.ScanResult
import android.net.wifi.WifiManager
import android.os.Bundle
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity: FlutterActivity() {
    private val CHANNEL = "wifi_service"

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)

        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, CHANNEL).setMethodCallHandler {
                call, result ->
            if (call.method == "scanWifi") {
                val wifiManager = applicationContext.getSystemService(Context.WIFI_SERVICE) as WifiManager
                val success = wifiManager.startScan()
                if (success) {
                    val scanResults: List<ScanResult> = wifiManager.scanResults
                    val wifiList = scanResults.map {
                        mapOf("ssid" to it.SSID, "bssid" to it.BSSID)
                    }
                    result.success(wifiList)
                } else {
                    result.error("UNAVAILABLE", "Falha ao escanear redes Wi-Fi", null)
                }
            } else {
                result.notImplemented()
            }
        }
    }
}
