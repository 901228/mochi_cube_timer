import "package:flutter/widgets.dart";
import "package:forui/forui.dart";

import "adaptive_dialog.dart";

Future<bool> showConfirmDialog(
  BuildContext context, {
  required String title,
  required String message,
  required String confirmLabel,
  String cancelLabel = "Cancel",
  bool destructive = false,
}) async {
  final confirmed = await showFDialog<bool>(
    context: context,
    builder: (context, style, animation) => AdaptiveDialog(
      style: style,
      animation: animation,
      title: Text(title),
      body: Text(message),
      actions: [
        FButton(variant: .outline, onPress: () => Navigator.of(context).pop(false), child: Text(cancelLabel)),
        FButton(
          variant: destructive ? .destructive : .primary,
          onPress: () => Navigator.of(context).pop(true),
          child: Text(confirmLabel),
        ),
      ],
    ),
  );
  return confirmed ?? false; // 點 barrier 或按 Esc 關掉時是 null
}
