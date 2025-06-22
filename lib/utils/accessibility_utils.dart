import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

class AccessibilityUtils {
  /// Anuncia uma mensagem usando os serviços de acessibilidade do sistema
  static void announce(BuildContext context, String message) {
    SemanticsService.announce(
      message,
      TextDirection.ltr,
    );
  }

  /// Retorna um widget de texto com suporte para leitores de tela
  static Widget accessibleText(String text, {TextStyle? style}) {
    return Semantics(
      label: text,
      child: Text(text, style: style),
    );
  }
}
