import "package:mochi_ui/mochi_ui.dart";

const groupSpacing = 16.0;

class SettingsTile extends StatelessWidget {
  static const _contentHeight = 32.0;

  const SettingsTile({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.suffix,
    this.onPress,
    this.enabled = true,
  });

  final String title;
  final String? subtitle;
  final Icon? icon;
  final Widget? suffix;
  final VoidCallback? onPress;
  final bool enabled;

  @override
  Widget build(BuildContext context) => MochiTile(
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

class ColorTile extends StatelessWidget {
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

  /// Formats [color] as an uppercase `RRGGBB` hex string, dropping alpha.
  String get _colorText => (color.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, "0").toUpperCase();

  @override
  Widget build(BuildContext context) => SettingsTile(
    title: title,
    suffix: Row(
      mainAxisSize: .min,
      spacing: 8,
      children: [
        Text("#$_colorText"),
        ColorSwatchBox(color: color),
      ],
    ),
    onPress: () async {
      final newColor = await showMochiColorPicker(
        context,
        title: title,
        initial: color,
        defaultColor: defaultColor,
        swatches: presets,
      );
      if (newColor != null) await onSubmit(newColor);
    },
  );
}

/// A colour as a small box: what a swatch, a legend row or a picker's field shows.
class ColorSwatchBox extends StatelessWidget {
  const ColorSwatchBox({super.key, required this.color, this.size = 24});

  final Color color;
  final double size;

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final g = theme.geometry;

    return SizedBox.square(
      dimension: size,
      child: DecoratedBox(
        decoration: ShapeDecoration(
          color: color,
          shape: RoundedSuperellipseBorder(
            borderRadius: g.radius.xs,
            side: BorderSide(color: theme.colors.border, width: g.borderWidth),
          ),
        ),
      ),
    );
  }
}
