import "package:cube_timer/cube_timer.dart";
import "package:flutter/widgets.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:forui/forui.dart";
import "package:go_router/go_router.dart";

import "../../shared/utils.dart";
import "sections/cube_colors_section.dart";
import "sections/inspection_section.dart";
import "sections/root_section.dart";

final Map<String, Widget Function(SettingsEntry, SettingsDao)> settingsSections = {
  "root": (settings, dao) => RootSettingsSections(settings: settings, dao: dao),
  "inspection": (settings, dao) => InspectionSettingsSections(settings: settings, dao: dao),
  "cube-colors": (settings, dao) => CubeColorsSettingsSections(settings: settings, dao: dao),
};

class SettingsPage extends StatelessWidget {
  final String section;
  const SettingsPage({super.key, this.section = "root"});

  @override
  Widget build(BuildContext context) {
    final dao = context.read<AppDatabase>().settingsDao;

    return FScaffold(
      header: FHeader.nested(
        title: IntrinsicWidth(
          child: FBreadcrumb(
            children: [
              FBreadcrumbItem(
                // HACK: only correct for 2 layers structure
                onPress: section == "root" ? null : () => context.pop(),
                child: const Text("Settings"),
              ),
              ?(section != "root"
                  ? FBreadcrumbItem(child: Text(section.capitalized.replaceAll(RegExp(r"[-_]"), " ")))
                  : null),
            ],
          ),
        ),
        prefixes: [
          FHeaderAction.back(
            onPress: () {
              context.pop();
            },
          ),
        ],
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
          return Padding(
            padding: context.theme.style.pagePadding,
            child: SingleChildScrollView(child: settingsSections[section]!(settings, dao)),
          );
        },
      ),
    );
  }
}
