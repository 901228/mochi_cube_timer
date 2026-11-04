import "package:cube_timer/cube_timer.dart";
import "package:mochi_ui/mochi_ui.dart";

import "../../l10n/l10n.dart";
import "../settings/settings_tile.dart";

/// The speeds the simulator's slider stops at, as multiples of its usual pace.
const simulatorSpeeds = [0.25, 0.5, 0.75, 1.0, 1.25, 1.5, 2.0, 3.0, 4.0];

/// The simulator's settings, in the settings page and in the simulator's own panel; [onResetView], when
/// given, adds a row putting the camera back.
class SimulatorSettingsGroup extends StatelessWidget {
  const SimulatorSettingsGroup({super.key, required this.settings, required this.dao, this.onResetView});

  final SettingsEntry settings;
  final SettingsDao dao;
  final VoidCallback? onResetView;

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    final distance = settings.simulatorHintDistance;
    final speed = _nearest(settings.simulatorSpeed);

    return MochiTileGroup(
      children: [
        SettingsTile(
          title: l10n.simulatorHintDistance,
          suffix: Text(distance == 0 ? l10n.simulatorHintOff : distance.toStringAsFixed(1)),
          subtitle: MochiSlider(
            value: distance.clamp(0, 4),
            max: 4,
            divisions: 8,
            onChanged: dao.setSimulatorHintDistance,
          ),
        ),
        SettingsTile(
          title: l10n.simulatorCubeSize,
          suffix: Text("${settings.simulatorCubeSize.toStringAsFixed(2)}x"),
          subtitle: MochiSlider(
            value: settings.simulatorCubeSize.clamp(0.5, 1.5),
            min: 0.5,
            max: 1.5,
            divisions: 20,
            onChanged: dao.setSimulatorCubeSize,
          ),
        ),
        SettingsTile(
          title: l10n.simulatorSpeed,
          suffix: Text("${simulatorSpeeds[speed]}x"),
          subtitle: MochiSlider(
            value: speed.toDouble(),
            max: simulatorSpeeds.length - 1.0,
            divisions: simulatorSpeeds.length - 1,
            onChanged: (i) => dao.setSimulatorSpeed(simulatorSpeeds[i.round()]),
          ),
        ),
        SettingsTile(
          title: l10n.simulatorHintLabels,
          suffix: MochiSwitch(value: settings.simulatorHintLabels, onChanged: dao.setSimulatorHintLabels),
        ),
        SettingsTile(
          title: l10n.simulatorStickerless,
          suffix: MochiSwitch(value: settings.simulatorStickerless, onChanged: dao.setSimulatorStickerless),
        ),
        SettingsTile(
          title: l10n.simulatorLoop,
          subtitle: l10n.simulatorLoopHint,
          suffix: MochiSwitch(value: settings.simulatorLoop, onChanged: dao.setSimulatorLoop),
        ),
        SettingsTile(
          title: l10n.simulatorResetSettings,
          icon: Icon(TablerIcons.restore),
          onPress: dao.resetSimulator,
        ),
        if (onResetView != null)
          SettingsTile(title: l10n.simulatorResetView, icon: Icon(TablerIcons.view360), onPress: onResetView),
      ],
    );
  }
}

int _nearest(double speed) {
  var best = 0;
  for (var i = 1; i < simulatorSpeeds.length; i++) {
    if ((simulatorSpeeds[i] - speed).abs() < (simulatorSpeeds[best] - speed).abs()) best = i;
  }
  return best;
}
