import "dart:ui";

import "package:cube_timer/cube_timer.dart";
import "package:flutter/widgets.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:forui/forui.dart";
import "package:go_router/go_router.dart";

import "../../widgets.dart";

// 放在 top-level：用 closure 的話每次 build 都是新物件，style 會一直被判定為不相等
ImageFilter _menuBarrier(BuildContext _, double animation) => ColorFilter.mode(
  Color.lerp(const Color(0x00000000), const Color(0x1A000000), animation)!,
  BlendMode.srcOver,
);

class SessionSelectionDialog extends StatefulWidget {
  final FDialogStyleDelta style;
  final Animation<double> animation;
  final String currentSessionId;
  const SessionSelectionDialog({
    super.key,
    required this.style,
    required this.animation,
    required this.currentSessionId,
  });

  @override
  State<SessionSelectionDialog> createState() => _SessionSelectionDialogState();
}

class _SessionSelectionDialogState extends State<SessionSelectionDialog> {
  late String sessionId = widget.currentSessionId;

  Future<String?> _sessionNameDialog(BuildContext context, {required String title}) {
    String name = "";

    return showFDialog<String>(
      context: context,
      builder: (context, style, animation) => AdaptiveDialog(
        style: style,
        animation: animation,
        title: Text(title),
        body: FTextField(
          control: .managed(onChange: (value) => name = value.text),
          hint: "Session name",
          autofocus: true,
          textInputAction: .done,
          onSubmit: context.pop,
        ),
        actions: [FButton(onPress: () => context.pop(name), child: const Text("Confirm"))],
      ),
    );
  }

  EdgeInsetsGeometry suffixedPaddingOf(BuildContext context, {FItemVariant variant = .primary}) {
    final styles = FInheritedItemData.maybeOf(context)?.styles ?? context.theme.itemStyles;
    return styles.resolve({variant, context.platformVariant}).contentStyle.suffixedPadding;
  }

  List<FItemGroupMixin> _menu(
    BuildContext context,
    SessionEntry session, {
    required FPopoverController controller,
    required SessionsDao dao,
    required AppStateDao appStateDao,
  }) => [
    .group(
      children: [
        .item(
          prefix: Icon(FLucideIcons.edit),
          title: Text("Rename"),
          onPress: () async {
            controller.hide(animated: false);

            final newSessionName = await _sessionNameDialog(context, title: "Rename session");
            if (newSessionName == null) return;

            await dao.setName(session.id, newSessionName);
          },
        ),
        .item(
          variant: .destructive,
          enabled: session.id != kDefaultSessionId,
          prefix: Icon(FLucideIcons.trash2),
          title: Text("Delete"),
          onPress: () async {
            controller.hide(animated: false);

            final answer = await showConfirmDialog(
              context,
              title: "Delete session?",
              message: 'All solves in "${session.name}" will be permanently deleted.',
              confirmLabel: "Delete",
              destructive: true,
            );
            if (answer) {
              await dao.softDelete(session.id);
              if (session.id == sessionId) {
                await appStateDao.setSession(kDefaultSessionId);
                if (mounted) {
                  setState(() {
                    sessionId = kDefaultSessionId;
                  });
                }
              }
            }
          },
        ),
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final dao = context.read<AppDatabase>().sessionsDao;
    final stateDao = context.read<AppDatabase>().appStateDao;

    final dir = Directionality.of(context);
    final itemSuffixPadding = suffixedPaddingOf(context).resolve(dir);
    final itemPaddingStart = dir == .ltr ? itemSuffixPadding.left : itemSuffixPadding.right;
    final suffixPaddingHorizontal = itemSuffixPadding.vertical / 2;

    return StreamBuilder(
      stream: dao.watchAll(),
      builder: (context, snapshot) {
        if (snapshot.error case final error?) {
          FlutterError.reportError(
            FlutterErrorDetails(
              exception: error,
              stack: snapshot.stackTrace,
              library: "mochi cube timer",
              context: ErrorDescription("watching the sessions"),
            ),
          );
          return Center(child: Icon(FLucideIcons.triangleAlert, color: context.theme.colors.destructive));
        }

        var sessions = snapshot.data;
        if (sessions == null) return const FCircularProgress();

        return AdaptiveDialog(
          style: widget.style,
          animation: widget.animation,
          title: FHeader.nested(
            title: const Text("Select a session"),
            suffixes: [
              FHeaderAction(
                icon: Icon(FLucideIcons.tagPlus),
                onPress: () async {
                  final sessionName = await _sessionNameDialog(context, title: "Create new session");
                  if (sessionName == null) return;

                  await dao.add(name: sessionName);
                },
              ),
            ],
          ),
          body: FItemGroup.builder(
            count: sessions.length,
            itemBuilder: (context, i) {
              final session = sessions[i];

              return FContextMenu(
                style: .delta(barrierFilter: () => _menuBarrier),
                menuAnchor: .topLeft,
                longPress: true,
                menuBuilder: (context, controller, _) =>
                    _menu(context, session, controller: controller, dao: dao, appStateDao: stateDao),
                builder: (_, controller, _) {
                  return FItem(
                    style: .delta(
                      padding: .add(.symmetric(vertical: 2)),
                      contentStyle: .delta(suffixedPadding: .value(.directional(start: itemPaddingStart))),
                    ),
                    selected: session.id == sessionId,
                    title: Text(session.name),
                    prefix: Icon(FLucideIcons.tag),
                    suffix: FPopoverMenu(
                      style: .delta(barrierFilter: () => _menuBarrier),
                      cutout: false,
                      menuAnchor: .topRight,
                      childAnchor: .bottomRight,
                      menuBuilder: (context, controller, _) =>
                          _menu(context, session, controller: controller, dao: dao, appStateDao: stateDao),
                      builder: (_, controller, _) => FTappable(
                        onPress: controller.toggle,
                        child: Padding(
                          padding: itemSuffixPadding.copyWith(
                            left: suffixPaddingHorizontal,
                            right: suffixPaddingHorizontal,
                          ),
                          child: Icon(FLucideIcons.ellipsisVertical),
                        ),
                      ),
                    ),
                    onPress: () {
                      stateDao.setSession(session.id);
                      context.pop();
                    },
                  );
                },
              );
            },
          ),
        );
      },
    );
  }
}
