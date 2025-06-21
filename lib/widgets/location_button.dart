import 'package:flutter/material.dart';
import '../models/access_point.dart';

class LocationButton extends StatelessWidget {
  final String locationName;
  final VoidCallback onPressed;

  const LocationButton({
    super.key,
    required this.locationName,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Navegar para $locationName',
      child: ElevatedButton(
        onPressed: onPressed,
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: AccessibilityUtils.accessibleText(
            locationName,
            style: const TextStyle(fontSize: 16.0),
          ),
        ),
      ),
    );
  }
}