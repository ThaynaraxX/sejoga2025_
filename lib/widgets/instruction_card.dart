import 'package:flutter/material.dart';
import '../models/access_point.dart';

class InstructionCard extends StatelessWidget {
  final String instruction;
  final VoidCallback? onTap;

  const InstructionCard({
    super.key,
    required this.instruction,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        margin: const EdgeInsets.all(16.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: AccessibilityUtils.accessibleText(
            instruction,
            style: const TextStyle(fontSize: 18.0),
          ),
        ),
      ),
    );
  }
}