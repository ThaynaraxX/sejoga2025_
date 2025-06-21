import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

class AccessibilityUtils {
  static void announce(BuildContext context, String message) {
    SemanticsService.announce(message, TextDirection.ltr);
  }

  static Widget accessibleText(String text, {TextStyle? style}) {
    return Semantics(
      label: text,
      child: Text(
        text,
        style: style,
      ),
    );
  }
}