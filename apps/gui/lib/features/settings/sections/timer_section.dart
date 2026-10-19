import "package:cube_timer/cube_timer.dart";
import "package:drift/drift.dart" show Value;
import "package:flutter/services.dart";
import "package:go_router/go_router.dart";
import "package:mochi_ui/mochi_ui.dart";

import "../../../shared/utils.dart";
import "../../../l10n/l10n.dart";
import "../../timer/alert.dart";
import "../settings_tile.dart";

class TimerSettingsSections extends StatelessWidget {
  final SettingsEntry settings;
  final SettingsDao dao;
  const TimerSettingsSections({super.key, required this.settings, required this.dao});

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final (firstAlertTime, secondAlertTime) = TimerConfig.alertTime(
      Duration(seconds: settings.inspectDuration),
    );

    return Column(
      spacing: groupSpacing,
      children: [
        MochiTileGroup(
          label: Text(l10n.timerInspection),
          children: [
            SettingsTile(
              title: l10n.timerInspection,
              suffix: MochiSwitch(value: settings.inspectionEnabled, onChanged: dao.setInspectionEnabled),
            ),
            SettingsTile(
              enabled: settings.inspectionEnabled,
              title: l10n.timerInspectionDuration,
              subtitle: l10n.timerInspectionDurationHint(15),
              suffix: Text(settings.inspectDuration.toString()),
              onPress: () => showMochiModal(
                context,
                title: Text(l10n.timerInspectionDuration),
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
          label: Text(l10n.timerAlert),
          children: [
            SettingsTile(
              title: l10n.timerAlertTimeLeft,
              subtitle: Text.rich(
                TextSpan(
                  text: l10n.timerAlertWhenPrefix,
                  children: [
                    TextSpan(
                      text: firstAlertTime.inSeconds.toString(),
                      style: TextStyle(fontWeight: .bold, color: context.colors.primary.base),
                    ),
                    TextSpan(text: l10n.timerAlertWhenAnd),
                    TextSpan(
                      text: secondAlertTime.inSeconds.toString(),
                      style: TextStyle(fontWeight: .bold, color: context.colors.primary.base),
                    ),
                    TextSpan(text: l10n.timerAlertWhenSuffix),
                  ],
                ),
              ),
              suffix: MochiSwitch(value: settings.alertEnabled, onChanged: dao.setAlertEnabled),
            ),
            SettingsTile(
              enabled: settings.alertEnabled,
              title: l10n.timerAlertType,
              subtitle: l10n.timerAlertTypeHint,
              suffix: MochiMultiSelect<AlertType>(
                enabled: settings.alertEnabled,
                hint: l10n.commonNone,
                // The default has vibration even where it is not offered.
                values: settings.alertTypes.where((e) => e.supported).toSet(),
                onChanged: dao.setAlertTypes,
                options: AlertType.values
                    .map((e) => MochiSelectOption(value: e, label: e.displayName(l10n), enabled: e.supported))
                    .toList(),
              ),
            ),
          ],
        ),

        MochiTileGroup(
          label: Text(l10n.timerRecords),
          children: [
            SettingsTile(
              title: l10n.timerBestAlert,
              subtitle: l10n.timerBestAlertHint,
              suffix: MochiSwitch(value: settings.recordBestAlert, onChanged: dao.setRecordBestAlert),
            ),
            SettingsTile(
              title: l10n.timerWorstAlert,
              subtitle: l10n.timerWorstAlertHint,
              suffix: MochiSwitch(value: settings.recordWorstAlert, onChanged: dao.setRecordWorstAlert),
            ),
            SettingsTile(
              title: l10n.timerAverageAlert,
              subtitle: l10n.timerAverageAlertHint,
              suffix: MochiSwitch(value: settings.recordAverageAlert, onChanged: dao.setRecordAverageAlert),
            ),
          ],
        ),

        MochiTileGroup(
          label: Text(l10n.timerDisplay),
          children: [
            SettingsTile(
              title: l10n.timerShowRunningTime,
              subtitle: l10n.timerShowRunningTimeHint,
              suffix: MochiSwitch(value: settings.showRunningTime, onChanged: dao.setShowRunningTime),
            ),
          ],
        ),

        MochiTileGroup(
          label: Text(l10n.timerColors),
          children: [
            ColorTile(
              title: l10n.timerColorPressed,
              color: settings.timerPressedColor.toColor(),
              defaultColor: DefaultColors.timerColors.pressed.toColor(),
              onSubmit: (c) => dao.save(SettingsCompanion(timerPressedColor: Value(c.toARGB32()))),
            ),
            ColorTile(
              title: l10n.timerColorHolding,
              color: settings.timerHoldingColor.toColor(),
              defaultColor: DefaultColors.timerColors.holding.toColor(),
              onSubmit: (c) => dao.save(SettingsCompanion(timerHoldingColor: Value(c.toARGB32()))),
            ),
            ColorTile(
              title: l10n.timerColorAccept,
              color: settings.timerAcceptColor.toColor(),
              defaultColor: DefaultColors.timerColors.accept.toColor(),
              onSubmit: (c) => dao.save(SettingsCompanion(timerAcceptColor: Value(c.toARGB32()))),
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
              child: Text(context.l10n.commonDefault),
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
                  child: Text(context.l10n.commonCancel),
                ),
                MochiButton(
                  size: .sm,
                  onPress: submitting ? null : _submit,
                  child: Text(context.l10n.commonSubmit),
                ),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
