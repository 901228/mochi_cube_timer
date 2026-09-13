import "package:flutter/widgets.dart";
import "package:forui/forui.dart";

import "../../shared/widgets.dart";

const groupSpacing = 16.0;

class SettingsTile extends StatelessWidget with FTileMixin {
  static const _contentHeight = 32.0;

  const SettingsTile({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.suffix,
    this.onPress,
    this.enabled,
  });

  final String title;
  final String? subtitle;
  final Icon? icon;
  final Widget? suffix;
  final VoidCallback? onPress;
  final bool? enabled;

  @override
  Widget build(BuildContext context) => FTile(
    enabled: enabled,
    prefix: icon,
    title: SizedBox(
      height: _contentHeight,
      child: Align(alignment: Alignment.centerLeft, child: Text(title)),
    ),
    subtitle: subtitle != null ? Text(subtitle!) : null,
    suffix: suffix is Text
        ? Padding(padding: const EdgeInsetsGeometry.directional(end: 4.0), child: suffix)
        : suffix,
    onPress: onPress,
  );
}

class ColorTile extends StatelessWidget with FTileMixin {
  final String title;
  final Color color;
  final Color defaultColor;
  final Future<void> Function(Color color) onSubmit;
  final List<Color> presets;
  const ColorTile({
    super.key,
    required this.title,
    required this.color,
    required this.defaultColor,
    required this.onSubmit,
    this.presets = _presets,
  });

  // Common sticker colors offered as quick picks.
  static const _presets = [
    Color(0xFFFFFFFF),
    Color(0xFFFFFF00),
    Color(0xFFFFC13D),
    Color(0xFFEE6B6B),
    Color(0xFF00FF7F),
    Color(0xFF1E90FF),
    Color(0xFF9B59B6),
    Color(0xFF000000),
  ];

  @override
  Widget build(BuildContext context) => SettingsTile(
    title: title,
    suffix: Row(
      mainAxisSize: .min,
      spacing: 8,
      children: [
        Text("#${colorToHex(color)}"),
        ColorSwatchBox(color: color),
      ],
    ),
    onPress: () => showFDialog(
      context: context,
      builder: (_, style, animation) => ColorPickerDialog(
        style: style,
        animation: animation,
        title: title,
        initial: color,
        defaultColor: defaultColor,
        presets: presets,
        onSubmit: onSubmit,
      ),
    ),
  );
}
