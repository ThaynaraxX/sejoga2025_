import 'package:flutter/material.dart';
import 'package:flutter/semantics.dart';

class AccessibilityUtils {
  /// Anuncia uma mensagem usando os serviços de acessibilidade do sistema.
  /// Ideal para feedback falado imediato.
  static void announce(BuildContext context, String message) {
    SemanticsService.announce(
      message,
      Directionality.of(context), // usa a direção atual da UI
    );
  }

  /// Retorna um widget de texto acessível com opção de customizar o que será falado
  static Widget accessibleText(
      String visualText, {
        TextStyle? style,
        String? semanticsLabel,
        TextDirection textDirection = TextDirection.ltr,
      }) {
    return Semantics(
      label: semanticsLabel ?? visualText,
      textDirection: textDirection,
      child: ExcludeSemantics(
        child: Text(
          visualText,
          style: style,
        ),
      ),
    );
  }
}

