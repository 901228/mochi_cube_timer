import "package:cube_timer/cube_timer.dart";
import "package:flutter/services.dart";
import "package:flutter/widgets.dart";
import "package:forui/forui.dart";
import "package:go_router/go_router.dart";

import "../settings.page.dart";

class InspectionSettingsPage extends StatelessWidget {
  final SettingsEntry settings;
  final SettingsDao dao;
  const InspectionSettingsPage({super.key, required this.settings, required this.dao});

  @override
  Widget build(BuildContext context) {
    final (firstAlertTime, secondAlertTime) = TimerConfig.alertTime(
      Duration(seconds: settings.inspectDuration),
    );

    return Column(
      spacing: groupSpacing,
      children: [
        FTileGroup(
          label: const Text("Inpsection"),
          children: [
            SettingsTile(
              title: "Inspection",
              suffix: FSwitch(value: settings.inspectionEnabled, onChange: dao.setInspectionEnabled),
            ),
            SettingsTile(
              title: "Inspection duration (seconds)",
              subtitle: "Default duration: 15 seconds",
              suffix: Text(settings.inspectDuration.toString()),
              onPress: () => showFDialog(
                context: context,
                builder: (_, style, animation) => DurationDialog(
                  style: style,
                  animation: animation,
                  initial: settings.inspectDuration,
                  onSubmit: (value) async {
                    dao.setInspectionDuration(Duration(seconds: value));
                  },
                ),
              ),
            ),
          ],
        ),

        FTileGroup(
          label: const Text("Alert"),
          children: [
            // TODO: alert
            SettingsTile(
              title: "Alert time left",
              subtitle:
                  "Timer will alert you once ${firstAlertTime.inSeconds} and ${secondAlertTime.inSeconds} seconds of inspection have passed",
              suffix: FSwitch(value: settings.alertEnabled, onChange: dao.setAlertEnabled),
            ),
            SettingsTile(
              enabled: false,
              title: "Alert type",
              subtitle: "Choose how the timer will alert you",
              // TODO:
            ),
          ],
        ),
      ],
    );
  }
}

class DurationDialog extends StatefulWidget {
  final FDialogStyle style;
  final Animation<double> animation;
  final int initial;
  final Future<void> Function(int value) onSubmit;
  const DurationDialog({
    super.key,
    required this.style,
    required this.animation,
    required this.initial,
    required this.onSubmit,
  });

  @override
  State<DurationDialog> createState() => _DurationDialogState();
}

class _DurationDialogState extends State<DurationDialog> {
  late final _controller = TextEditingController(text: widget.initial.toString());
  bool submitting = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() async {
    final seconds = int.tryParse(_controller.text);
    if (seconds != null && seconds > 0) {
      setState(() {
        submitting = true;
      });
      await widget.onSubmit(seconds);
    }
    if (mounted) {
      context.pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FDialog(
      style: widget.style,
      animation: widget.animation,
      builder: (context, style) {
        return Padding(
          padding: const .symmetric(horizontal: 16, vertical: 18),
          child: Column(
            mainAxisSize: .min,
            spacing: 16,
            children: [
              Padding(
                padding: const .all(8),
                child: DefaultTextStyle.merge(
                  style: style.titleTextStyle,
                  child: const Text("Inspection duration (seconds)"),
                ),
              ),
              FTextField(
                keyboardType: .numberWithOptions(decimal: false, signed: false),
                control: .managed(controller: _controller),
                inputFormatters: [FilteringTextInputFormatter.digitsOnly],
              ),
              Row(
                mainAxisSize: .max,
                mainAxisAlignment: .spaceBetween,
                children: [
                  FButton(
                    variant: .outline,
                    size: .sm,
                    onPress: submitting
                        ? null
                        : () {
                            setState(() {
                              _controller.text = "15";
                            });
                          },
                    child: const Text("Default"),
                  ),
                  Row(
                    mainAxisSize: .min,
                    spacing: 8,
                    children: [
                      FButton(
                        variant: .ghost,
                        size: .sm,
                        onPress: submitting
                            ? null
                            : () {
                                context.pop();
                              },
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
