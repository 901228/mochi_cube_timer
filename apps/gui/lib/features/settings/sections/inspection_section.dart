import "package:cube_timer/cube_timer.dart";
import "package:flutter/services.dart";
import "package:go_router/go_router.dart";
import "package:mochi_ui/mochi_ui.dart";

import "../../timer/alert.dart";
import "../settings_tile.dart";

class InspectionSettingsSections extends StatelessWidget {
  final SettingsEntry settings;
  final SettingsDao dao;
  const InspectionSettingsSections({super.key, required this.settings, required this.dao});

  @override
  Widget build(BuildContext context) {
    final (firstAlertTime, secondAlertTime) = TimerConfig.alertTime(
      Duration(seconds: settings.inspectDuration),
    );

    return Column(
      spacing: groupSpacing,
      children: [
        MochiTileGroup(
          label: const Text("Inpsection"),
          children: [
            SettingsTile(
              title: "Inspection",
              suffix: MochiSwitch(value: settings.inspectionEnabled, onChanged: dao.setInspectionEnabled),
            ),
            SettingsTile(
              enabled: settings.inspectionEnabled,
              title: "Inspection duration (seconds)",
              subtitle: "Default duration: 15 seconds",
              suffix: Text(settings.inspectDuration.toString()),
              onPress: () => showMochiModal(
                context,
                title: const Text("Inspection duration (seconds)"),
                body: DurationModal(
                  initial: settings.inspectDuration,
                  onSubmit: (value) async {
                    dao.setInspectionDuration(Duration(seconds: value));
                  },
                ),
              ),
            ),
          ],
        ),

        MochiTileGroup(
          label: const Text("Alert"),
          children: [
            SettingsTile(
              title: "Alert time left",
              subtitle: Text.rich(
                TextSpan(
                  text: "Timer will alert you once ",
                  children: [
                    TextSpan(
                      text: firstAlertTime.inSeconds.toString(),
                      style: TextStyle(fontWeight: .bold, color: context.colors.primary.base),
                    ),
                    const TextSpan(text: " and "),
                    TextSpan(
                      text: secondAlertTime.inSeconds.toString(),
                      style: TextStyle(fontWeight: .bold, color: context.colors.primary.base),
                    ),
                    const TextSpan(text: " seconds of inspection have passed"),
                  ],
                ),
              ),
              suffix: MochiSwitch(value: settings.alertEnabled, onChanged: dao.setAlertEnabled),
            ),
            SettingsTile(
              enabled: settings.alertEnabled,
              title: "Alert type",
              subtitle: "Choose how the timer will alert you",
              suffix: MochiMultiSelect<AlertType>(
                enabled: settings.alertEnabled,
                hint: "None",
                // The default has vibration even where it is not offered.
                values: settings.alertTypes.where((e) => e.supported).toSet(),
                onChanged: dao.setAlertTypes,
                options: AlertType.values
                    .map((e) => MochiSelectOption(value: e, label: e.displayName, enabled: e.supported))
                    .toList(),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class DurationModal extends StatefulWidget {
  final int initial;
  final Future<void> Function(int value) onSubmit;
  const DurationModal({super.key, required this.initial, required this.onSubmit});

  @override
  State<DurationModal> createState() => _DurationModalState();
}

class _DurationModalState extends State<DurationModal> {
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
    return Column(
      mainAxisSize: .min,
      spacing: 16,
      children: [
        MochiTextField(
          keyboardType: .numberWithOptions(decimal: false, signed: false),
          controller: _controller,
          inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        ),
        Row(
          mainAxisSize: .max,
          mainAxisAlignment: .spaceBetween,
          children: [
            MochiButton(
              appearance: .outlined,
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
                MochiButton(
                  appearance: .ghost,
                  size: .sm,
                  onPress: submitting
                      ? null
                      : () {
                          context.pop();
                        },
                  child: const Text("Cancel"),
                ),
                MochiButton(size: .sm, onPress: submitting ? null : _submit, child: const Text("Submit")),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
