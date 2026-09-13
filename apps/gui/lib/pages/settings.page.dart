import "package:cube_timer/cube_timer.dart";
import "package:flutter/widgets.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:forui/forui.dart";
import "package:go_router/go_router.dart";

import "../utils.dart";
import "settings/inspection.settings.page.dart";
import "settings/root.settings.page.dart";

final Map<String, Widget Function(SettingsEntry, SettingsDao)> settingsPages = {
  "root": (settings, dao) => RootSettingsPage(),
  "inspection": (settings, dao) => InspectionSettingsPage(settings: settings, dao: dao),
};

const groupSpacing = 16.0;

class SettingsTile extends StatelessWidget with FTileMixin {
  static const _contentHeight = 32.0;

  const SettingsTile({
    super.key,
    required this.title,
    this.subtitle,
    this.icon,
    this.suffix,
    this.onPress,
    this.enabled,
  });

  final String title;
  final String? subtitle;
  final Icon? icon;
  final Widget? suffix;
  final VoidCallback? onPress;
  final bool? enabled;

  @override
  Widget build(BuildContext context) => FTile(
    enabled: enabled,
    prefix: icon,
    title: SizedBox(
      height: _contentHeight,
      child: Align(alignment: Alignment.centerLeft, child: Text(title)),
    ),
    subtitle: subtitle != null ? Text(subtitle!) : null,
    suffix: suffix,
    onPress: onPress,
  );
}

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
              ?(section != "root" ? FBreadcrumbItem(child: Text(section.capitalized)) : null),
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
            child: settingsPages[section]!(settings, dao),
          );
        },
      ),
    );
  }
}
