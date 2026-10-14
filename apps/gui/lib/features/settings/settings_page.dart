import "package:cube_timer/cube_timer.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:go_router/go_router.dart";
import "package:mochi_ui/mochi_ui.dart";

import "../../shared/utils.dart";
import "sections/cube_colors_section.dart";
import "sections/inspection_section.dart";
import "sections/root_section.dart";
import "sections/timer_colors_section.dart";

final Map<String, Widget Function(SettingsEntry, SettingsDao)> settingsSections = {
  "root": (settings, dao) => RootSettingsSections(settings: settings, dao: dao),
  "inspection": (settings, dao) => InspectionSettingsSections(settings: settings, dao: dao),
  "cube-colors": (settings, dao) => CubeColorsSettingsSections(settings: settings, dao: dao),
  "timer-colors": (settings, dao) => TimerColorsSettingsSections(settings: settings, dao: dao),
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
                label: const Text("Settings"),
              ),
              ?(section != "root"
                  ? MochiBreadcrumbItem(label: Text(section.capitalized.replaceAll(RegExp(r"[-_]"), " ")))
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
