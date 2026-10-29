import "package:cube_timer/cube_timer.dart";
import "package:go_router/go_router.dart";
import "package:mochi_ui/mochi_ui.dart";

import "../../../l10n/l10n.dart";
import "../settings_tile.dart";

class RootSettingsSections extends StatelessWidget {
  final SettingsEntry settings;
  final SettingsDao dao;
  const RootSettingsSections({super.key, required this.settings, required this.dao});

  Widget _sectionCardGroup(BuildContext context, {required String title, required List<Widget> children}) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: context.theme.geometry.space.xs,
        children: [
          DefaultTextStyle(
            style: context.theme.typography.title.md.copyWith(color: context.colors.mutedForeground),
            child: Text(title),
          ),
          Wrap(spacing: groupSpacing, runSpacing: groupSpacing, children: children),
        ],
      );

  Widget _sectionCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required String link,
  }) => SizedBox.square(
    dimension: 160,
    child: MochiCard(
      footer: Text(title, style: context.theme.typography.body.sm),
      child: Center(child: Icon(icon, size: context.theme.typography.title.xl6.fontSize)),
      onPress: () => context.push(link),
    ),
  );

  @override
  Widget build(BuildContext context) {
    final isMobile = context.responsive(mobile: true, tablet: false);

    return Column(
      spacing: groupSpacing,
      children: isMobile
          ? [
              MochiTileGroup(
                label: Text(context.l10n.settingsTimer),
                children: [
                  SettingsTile(
                    title: context.l10n.settingsInspection,
                    icon: Icon(TablerIcons.stopwatch),
                    suffix: Icon(TablerIcons.chevronRight),
                    onPress: () => context.push("/settings/inspection"),
                  ),
                  SettingsTile(
                    title: context.l10n.settingsTimerBehavior,
                    icon: Icon(TablerIcons.clockHour4),
                    suffix: Icon(TablerIcons.chevronRight),
                    onPress: () => context.push("/settings/timer"),
                  ),
                  SettingsTile(
                    title: context.l10n.settingsTimerAppearance,
                    icon: Icon(TablerIcons.clockRecord),
                    suffix: Icon(TablerIcons.chevronRight),
                    onPress: () => context.push("/settings/timerAppearance"),
                  ),
                  SettingsTile(
                    title: context.l10n.settingsPuzzle,
                    icon: Icon(TablerIcons.cube),
                    suffix: Icon(TablerIcons.chevronRight),
                    onPress: () => context.push("/settings/puzzle"),
                  ),
                ],
              ),
              MochiTileGroup(
                label: Text(context.l10n.settingsOther),
                children: [
                  SettingsTile(
                    title: context.l10n.settingsGeneral,
                    icon: Icon(TablerIcons.settings),
                    suffix: Icon(TablerIcons.chevronRight),
                    onPress: () => context.push("/settings/general"),
                  ),
                  SettingsTile(
                    title: context.l10n.settingsStats,
                    icon: Icon(TablerIcons.chartLine),
                    suffix: Icon(TablerIcons.chevronRight),
                    onPress: () => context.push("/settings/stats"),
                  ),
                  SettingsTile(
                    title: context.l10n.settingsAbout,
                    icon: Icon(TablerIcons.infoCircle),
                    suffix: Icon(TablerIcons.chevronRight),
                    onPress: () => context.push("/settings/about"),
                  ),
                ],
              ),
            ]
          : [
              _sectionCardGroup(
                context,
                title: context.l10n.settingsTimer,
                children: [
                  _sectionCard(
                    context,
                    title: context.l10n.settingsInspection,
                    icon: TablerIcons.stopwatch,
                    link: "/settings/inspection",
                  ),
                  _sectionCard(
                    context,
                    title: context.l10n.settingsTimerBehavior,
                    icon: TablerIcons.clockHour4,
                    link: "/settings/timer",
                  ),
                  _sectionCard(
                    context,
                    title: context.l10n.settingsTimerAppearance,
                    icon: TablerIcons.clockRecord,
                    link: "/settings/timerAppearance",
                  ),
                  _sectionCard(
                    context,
                    title: context.l10n.settingsPuzzle,
                    icon: TablerIcons.cube,
                    link: "/settings/puzzle",
                  ),
                ],
              ),
              _sectionCardGroup(
                context,
                title: context.l10n.settingsOther,
                children: [
                  _sectionCard(
                    context,
                    title: context.l10n.settingsGeneral,
                    icon: TablerIcons.settings,
                    link: "/settings/general",
                  ),
                  _sectionCard(
                    context,
                    title: context.l10n.settingsStats,
                    icon: TablerIcons.chartLine,
                    link: "/settings/stats",
                  ),
                  _sectionCard(
                    context,
                    title: context.l10n.settingsAbout,
                    icon: TablerIcons.infoCircle,
                    link: "/settings/about",
                  ),
                ],
              ),
            ],
    );
  }
}
