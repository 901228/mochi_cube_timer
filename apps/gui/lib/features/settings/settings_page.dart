import "package:cube_timer/cube_timer.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:go_router/go_router.dart";
import "package:mochi_ui/mochi_ui.dart";

import "../../database/dao_provider.dart";
import "../../l10n/l10n.dart";
import "sections/about_section.dart";
import "sections/general_section.dart";
import "sections/inspection_section.dart";
import "sections/puzzle_section.dart";
import "sections/root_section.dart";
import "sections/stats_section.dart";
import "sections/timer_appearance_section.dart";
import "sections/timer_section.dart";

final Map<String, Widget Function(SettingsEntry settings, SettingsDao dao)> settingsSections = {
  "root": (settings, dao) => RootSettingsSections(settings: settings, dao: dao),
  "inspection": (settings, dao) => InspectionSettingsSections(settings: settings, dao: dao),
  "timer": (settings, dao) => TimerSettingsSections(settings: settings, dao: dao),
  "timerAppearance": (settings, dao) => TimerAppearanceSettingsSections(settings: settings, dao: dao),
  "puzzle": (settings, dao) => PuzzleSettingsSections(settings: settings, dao: dao),
  "general": (settings, dao) => GeneralSettingsSections(settings: settings, dao: dao),
  "stats": (settings, dao) => StatsSettingsSections(settings: settings, dao: dao),
  "about": (settings, dao) => const AboutSettingsSections(),
};

class SettingsPage extends StatelessWidget {
  final String section;
  const SettingsPage({super.key, this.section = "root"});

  @override
  Widget build(BuildContext context) {
    final dao = context.read<AppDatabase>().settingsDao;

    return MochiScaffold(
      extendBody: true,
      padding: .zero,
      header: MochiHeader(
        variant: .bordered,
        title: IntrinsicWidth(
          child: MochiBreadcrumb(
            items: [
              MochiBreadcrumbItem(
                onPress: section == "root" ? null : () => context.pop(),
                label: Text(context.l10n.commonSettings),
              ),
              ?(section != "root"
                  ? MochiBreadcrumbItem(
                      label: Text(switch (section) {
                        "inspection" => context.l10n.settingsInspection,
                        "timer" => context.l10n.settingsTimerBehavior,
                        "timerAppearance" => context.l10n.settingsTimerAppearance,
                        "puzzle" => context.l10n.settingsPuzzle,
                        "general" => context.l10n.settingsGeneral,
                        "stats" => context.l10n.settingsStats,
                        _ => context.l10n.settingsAbout,
                      }),
                    )
                  : null),
            ],
          ),
        ),
        prefixes: [.back(onPress: () => context.pop())],
      ),
      // A Builder, so the padding is read from under the scaffold, which adds the header's height to it.
      child: Builder(
        builder: (context) => SingleChildScrollView(
          padding: MediaQuery.paddingOf(context) + context.theme.geometry.pagePadding,
          child: settingsSections[section]!(SettingsProvider.of(context), dao),
        ),
      ),
    );
  }
}
