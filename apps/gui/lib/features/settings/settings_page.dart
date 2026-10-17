import "package:cube_timer/cube_timer.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:go_router/go_router.dart";
import "package:mochi_ui/mochi_ui.dart";

import "../../l10n/l10n.dart";
import "../../shared/utils.dart";
import "sections/about_section.dart";
import "sections/general_section.dart";
import "sections/puzzle_section.dart";
import "sections/root_section.dart";
import "sections/timer_section.dart";

final Map<String, Widget Function(SettingsEntry, SettingsDao)> settingsSections = {
  "root": (settings, dao) => RootSettingsSections(settings: settings, dao: dao),
  "general": (settings, dao) => GeneralSettingsSections(settings: settings, dao: dao),
  "timer": (settings, dao) => TimerSettingsSections(settings: settings, dao: dao),
  "puzzle": (settings, dao) => PuzzleSettingsSections(settings: settings, dao: dao),
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
      header: MochiHeader(
        variant: .bordered,
        title: IntrinsicWidth(
          child: MochiBreadcrumb(
            items: [
              MochiBreadcrumbItem(
                // HACK: only correct for 2 layers structure
                onPress: section == "root" ? null : () => context.pop(),
                label: Text(context.l10n.commonSettings),
              ),
              ?(section != "root"
                  ? MochiBreadcrumbItem(
                      label: Text(switch (section) {
                        "general" => context.l10n.settingsGeneral,
                        "timer" => context.l10n.settingsTimer,
                        "puzzle" => context.l10n.settingsPuzzle,
                        _ => context.l10n.settingsAbout,
                      }),
                    )
                  : null),
            ],
          ),
        ),
        prefixes: [.back(onPress: () => context.pop())],
      ),
      child: StreamBuilder<SettingsEntry>(
        stream: dao.watch(),
        builder: (context, snapshot) {
          final w = streamHandler(
            context,
            snapshot,
            description: "watching the settings for the settings page",
          );
          if (w != null) return w;

          final settings = snapshot.data!;
          return SingleChildScrollView(
            padding: MediaQuery.paddingOf(context),
            child: settingsSections[section]!(settings, dao),
          );
        },
      ),
    );
  }
}
