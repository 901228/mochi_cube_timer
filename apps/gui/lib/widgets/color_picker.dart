import "package:flutter/services.dart";
import "package:flutter/widgets.dart";
import "package:forui/forui.dart";
import "package:go_router/go_router.dart";

/// Formats [color] as an uppercase `RRGGBB` hex string, dropping alpha.
String colorToHex(Color color) =>
    (color.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, "0").toUpperCase();

/// Parses a `RRGGBB` hex string (optionally prefixed with `#`) into an opaque color.
Color? colorFromHex(String hex) {
  final digits = hex.startsWith("#") ? hex.substring(1) : hex;
  if (digits.length != 6) return null;
  final value = int.tryParse(digits, radix: 16);
  return value == null ? null : Color(0xFF000000 | value);
}

/// A small rounded square that previews a color, meant for tile suffixes.
class ColorSwatchBox extends StatelessWidget {
  final Color color;
  final double size;
  const ColorSwatchBox({super.key, required this.color, this.size = 24});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        borderRadius: theme.style.borderRadius.xs,
        border: Border.all(color: theme.colors.border, width: theme.style.borderWidth),
      ),
    );
  }
}

/// An HSV color picker styled with the current forui theme.
///
/// Consists of a saturation/value panel, a hue slider, a hex text field and
/// an optional row of preset swatches.
class ColorPicker extends StatefulWidget {
  final Color value;
  final ValueChanged<Color> onChange;
  final List<Color> presets;
  final bool enabled;

  const ColorPicker({
    super.key,
    required this.value,
    required this.onChange,
    this.presets = const [],
    this.enabled = true,
  });

  @override
  State<ColorPicker> createState() => _ColorPickerState();
}

class _ColorPickerState extends State<ColorPicker> {
  late HSVColor _hsv = HSVColor.fromColor(widget.value);
  late final _hexController = TextEditingController(text: colorToHex(widget.value));

  @override
  void didUpdateWidget(covariant ColorPicker oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Only resync when the parent pushes a color we did not produce, so the hue
    // survives dragging through grayscale (where HSV loses it).
    if (widget.value.toARGB32() != _hsv.toColor().toARGB32()) {
      _hsv = HSVColor.fromColor(widget.value);
      _syncHex();
    }
  }

  @override
  void dispose() {
    _hexController.dispose();
    super.dispose();
  }

  void _syncHex() {
    final hex = colorToHex(_hsv.toColor());
    if (_hexController.text.toUpperCase() != hex) _hexController.text = hex;
  }

  void _update(HSVColor hsv) {
    setState(() => _hsv = hsv);
    _syncHex();
    widget.onChange(hsv.toColor());
  }

  void _onHexChange(TextEditingValue value) {
    final color = colorFromHex(value.text);
    if (color == null || color.toARGB32() == _hsv.toColor().toARGB32()) return;
    setState(() => _hsv = HSVColor.fromColor(color));
    widget.onChange(color);
  }

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final color = _hsv.toColor();

    return Column(
      mainAxisSize: .min,
      crossAxisAlignment: .stretch,
      spacing: 16,
      children: [
        AspectRatio(
          aspectRatio: 4 / 3,
          child: _SaturationValuePanel(hsv: _hsv, enabled: widget.enabled, onChange: _update),
        ),
        _HueSlider(hsv: _hsv, enabled: widget.enabled, onChange: _update),
        Row(
          spacing: 12,
          children: [
            ColorSwatchBox(color: color, size: 36),
            Expanded(
              child: FTextField(
                enabled: widget.enabled,
                control: .managed(controller: _hexController, onChange: _onHexChange),
                hint: "RRGGBB",
                maxLength: 6,
                textCapitalization: .characters,
                inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9a-fA-F]"))],
                counterBuilder: (_, _, _, _) => null,
              ),
            ),
          ],
        ),
        if (widget.presets.isNotEmpty)
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final preset in widget.presets)
                FTappable(
                  semanticsLabel: "#${colorToHex(preset)}",
                  onPress: widget.enabled ? () => _update(HSVColor.fromColor(preset)) : null,
                  child: Container(
                    width: 28,
                    height: 28,
                    padding: const .all(2),
                    decoration: BoxDecoration(
                      borderRadius: theme.style.borderRadius.sm,
                      border: Border.all(
                        color: preset.toARGB32() == color.toARGB32()
                            ? theme.colors.primary
                            : const Color(0x00000000),
                        width: 2,
                      ),
                    ),
                    child: ColorSwatchBox(color: preset),
                  ),
                ),
            ],
          ),
      ],
    );
  }
}

class _PickerThumb extends StatelessWidget {
  final Color color;
  const _PickerThumb({required this.color});

  @override
  Widget build(BuildContext context) => Container(
    width: 18,
    height: 18,
    decoration: BoxDecoration(
      color: color,
      shape: .circle,
      border: Border.all(color: const Color(0xFFFFFFFF), width: 2),
      boxShadow: const [BoxShadow(color: Color(0x40000000), blurRadius: 4, offset: Offset(0, 1))],
    ),
  );
}

class _SaturationValuePanel extends StatelessWidget {
  final HSVColor hsv;
  final bool enabled;
  final ValueChanged<HSVColor> onChange;
  const _SaturationValuePanel({required this.hsv, required this.enabled, required this.onChange});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return LayoutBuilder(
      builder: (context, constraints) {
        final size = constraints.biggest;

        void pick(Offset position) {
          final s = (position.dx / size.width).clamp(0.0, 1.0);
          final v = 1 - (position.dy / size.height).clamp(0.0, 1.0);
          onChange(hsv.withSaturation(s).withValue(v));
        }

        return GestureDetector(
          onPanDown: enabled ? (details) => pick(details.localPosition) : null,
          onPanUpdate: enabled ? (details) => pick(details.localPosition) : null,
          child: Stack(
            clipBehavior: .none,
            children: [
              Positioned.fill(
                child: Container(
                  foregroundDecoration: BoxDecoration(
                    borderRadius: theme.style.borderRadius.md,
                    border: Border.all(color: theme.colors.border, width: theme.style.borderWidth),
                  ),
                  child: ClipRRect(
                    borderRadius: theme.style.borderRadius.md,
                    child: DecoratedBox(
                      decoration: BoxDecoration(color: HSVColor.fromAHSV(1, hsv.hue, 1, 1).toColor()),
                      child: const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(colors: [Color(0xFFFFFFFF), Color(0x00FFFFFF)]),
                        ),
                        child: DecoratedBox(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: .topCenter,
                              end: .bottomCenter,
                              colors: [Color(0x00000000), Color(0xFF000000)],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Positioned(
                left: hsv.saturation * size.width - 9,
                top: (1 - hsv.value) * size.height - 9,
                child: IgnorePointer(child: _PickerThumb(color: hsv.toColor())),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _HueSlider extends StatelessWidget {
  static const _height = 14.0;
  static final _hues = [
    for (var h = 0; h <= 360; h += 60) HSVColor.fromAHSV(1, h.toDouble(), 1, 1).toColor(),
  ];

  final HSVColor hsv;
  final bool enabled;
  final ValueChanged<HSVColor> onChange;
  const _HueSlider({required this.hsv, required this.enabled, required this.onChange});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    return LayoutBuilder(
      builder: (context, constraints) {
        // Keep the thumb inside the track at both ends.
        const inset = 9.0;
        final track = constraints.maxWidth - inset * 2;

        void pick(Offset position) {
          final t = ((position.dx - inset) / track).clamp(0.0, 1.0);
          // 360 is red just like 0, but wrapping it would jump the thumb back to
          // the left end whenever the drag reaches the right one.
          onChange(hsv.withHue(t * 360));
        }

        return GestureDetector(
          onPanDown: enabled ? (details) => pick(details.localPosition) : null,
          onPanUpdate: enabled ? (details) => pick(details.localPosition) : null,
          child: SizedBox(
            height: 18,
            child: Stack(
              alignment: .centerLeft,
              children: [
                Container(
                  height: _height,
                  decoration: BoxDecoration(
                    borderRadius: theme.style.borderRadius.pill,
                    border: Border.all(color: theme.colors.border, width: theme.style.borderWidth),
                    gradient: LinearGradient(colors: _hues),
                  ),
                ),
                Positioned(
                  left: hsv.hue / 360 * track,
                  child: IgnorePointer(
                    child: _PickerThumb(color: HSVColor.fromAHSV(1, hsv.hue, 1, 1).toColor()),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

/// A forui dialog wrapping [ColorPicker] with Default / Cancel / Submit actions.
class ColorPickerDialog extends StatefulWidget {
  final FDialogStyle style;
  final Animation<double> animation;
  final String title;
  final Color initial;
  final Color? defaultColor;
  final List<Color> presets;
  final Future<void> Function(Color value) onSubmit;

  const ColorPickerDialog({
    super.key,
    required this.style,
    required this.animation,
    required this.title,
    required this.initial,
    required this.onSubmit,
    this.defaultColor,
    this.presets = const [],
  });

  @override
  State<ColorPickerDialog> createState() => _ColorPickerDialogState();
}

class _ColorPickerDialogState extends State<ColorPickerDialog> {
  late Color _color = widget.initial;
  bool submitting = false;

  Future<void> _submit() async {
    setState(() => submitting = true);
    try {
      await widget.onSubmit(_color);
    } catch (error, stack) {
      // Without this the buttons stay disabled and the dialog can never close.
      FlutterError.reportError(
        FlutterErrorDetails(
          exception: error,
          stack: stack,
          library: "mochi cube timer",
          context: ErrorDescription("saving the color picked in the color picker"),
        ),
      );
      if (mounted) setState(() => submitting = false);
      return;
    }
    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return FDialog(
      style: widget.style,
      animation: widget.animation,
      constraints: const BoxConstraints(minWidth: 280, maxWidth: 360),
      builder: (context, style) {
        return Padding(
          padding: const .symmetric(horizontal: 16, vertical: 18),
          child: Column(
            mainAxisSize: .min,
            crossAxisAlignment: .stretch,
            spacing: 16,
            children: [
              Padding(
                padding: const .all(8),
                child: DefaultTextStyle.merge(style: style.titleTextStyle, child: Text(widget.title)),
              ),
              ColorPicker(
                value: _color,
                enabled: !submitting,
                presets: widget.presets,
                onChange: (color) => setState(() => _color = color),
              ),
              Row(
                mainAxisAlignment: .spaceBetween,
                children: [
                  if (widget.defaultColor case final defaultColor?)
                    FButton(
                      variant: .outline,
                      size: .sm,
                      onPress: submitting ? null : () => setState(() => _color = defaultColor),
                      child: const Text("Default"),
                    )
                  else
                    const SizedBox.shrink(),
                  Row(
                    mainAxisSize: .min,
                    spacing: 8,
                    children: [
                      FButton(
                        variant: .ghost,
                        size: .sm,
                        onPress: submitting ? null : () => context.pop(),
                        child: const Text("Cancel"),
                      ),
                      FButton(size: .sm, onPress: submitting ? null : _submit, child: const Text("Submit")),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
