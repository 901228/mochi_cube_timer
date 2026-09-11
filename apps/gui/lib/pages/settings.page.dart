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
          final settings = snapshot.data;
          if (settings == null) return Center(child: FCircularProgress());

          return Padding(
            padding: context.theme.style.pagePadding,
            child: settingsPages[section]!(settings, dao),
          );

          // return Padding(
          //   padding: context.theme.style.pagePadding,
          //   child: Column(
          //     spacing: 16,
          //     crossAxisAlignment: CrossAxisAlignment.stretch,
          //     children: [
          //       FTileGroup(
          //         label: const Text("計時"),
          //         children: [
          //           SettingsTile(title: "Inspection", suffix: FSwitch()),
          //           SettingsTile(title: "啟動前需長按", suffix: FSwitch()),
          //         ],
          //       ),

          //       // 直接放在 group 外面
          //       // InspectionDurationField(value: s.inspectionDuration, onCommit: ...),
          //       FTileGroup(label: const Text("外觀"), children: []),
          //     ],
          //   ),
          // );
        },
      ),
    );
  }
}
