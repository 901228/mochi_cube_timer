import "package:cube_timer/cube_timer.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:go_router/go_router.dart";
import "package:mochi_ui/mochi_ui.dart";

import "../../shared/puzzles.dart";
import "../../shared/utils.dart";
import "../../l10n/l10n.dart";

Future<void> showSessionSelectionDialog(BuildContext context, {required String sessionId}) async {
  final creating = ValueNotifier(false);

  await showMochiModal(
    context,
    title: Text(context.l10n.sessionSelect),
    titleSuffix: MochiActionBar([
      MochiAction(
        icon: TablerIcons.stackPlus,
        label: context.l10n.sessionCreate,
        onPress: () {
          creating.value = true;
        },
      ),
      MochiAction(
        icon: TablerIcons.packageImport,
        label: context.l10n.sessionImport,
        onPress: () => importRecords(context),
      ),
    ]),
    body: SessionSelectionDialog(currentSessionId: sessionId, creating: creating),
  );

  creating.dispose();
}

class SessionSelectionDialog extends StatefulWidget {
  final String currentSessionId;
  final ValueNotifier<bool> creating;
  const SessionSelectionDialog({super.key, required this.currentSessionId, required this.creating});

  @override
  State<SessionSelectionDialog> createState() => _SessionSelectionDialogState();
}

class _SessionSelectionDialogState extends State<SessionSelectionDialog> {
  late String sessionId = widget.currentSessionId;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: context.read<AppDatabase>().sessionsDao.watchAll(),
      builder: (context, snapshot) {
        final w = streamHandler(context, snapshot, description: "watching the sessions");
        if (w != null) return w;

        final sessions = snapshot.data!;
        return ValueListenableBuilder(
          valueListenable: widget.creating,
          builder: (_, isCreating, _) {
            return MochiTileGroup(
              children: [
                for (final session in sessions)
                  _SessionTile(
                    currentSessionId: sessionId,
                    session: session,
                    afterDeletedCurrent: () {
                      if (mounted) {
                        setState(() {
                          sessionId = kDefaultSessionId;
                        });
                      }
                    },
                  ),
                if (isCreating)
                  _SessionNameEditTile(
                    onCancel: () => widget.creating.value = false,
                    onSave: (name) async {
                      if (name.isNotEmpty) await context.read<AppDatabase>().sessionsDao.add(name: name);
                      widget.creating.value = false;
                    },
                  ),
              ],
            );
          },
        );
      },
    );
  }
}

class _SessionNameEditTile extends StatefulWidget {
  final bool isSelected;
  final String initialName;
  final VoidCallback onCancel;
  final ValueChanged<String> onSave;
  const _SessionNameEditTile({
    this.isSelected = false,
    this.initialName = "",
    required this.onCancel,
    required this.onSave,
  });

  @override
  State<_SessionNameEditTile> createState() => _SessionNameEditTileState();
}

class _SessionNameEditTileState extends State<_SessionNameEditTile> {
  late final _controller = TextEditingController(text: widget.initialName);

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Block the barrier tap / back button from closing the modal while a name is being edited
    return PopScope(
      canPop: false,
      child: MochiTile(
        selected: widget.isSelected,
        prefix: Icon(TablerIcons.stack),
        title: MochiTextField(controller: _controller, autofocus: true, onSubmitted: context.pop),
        suffix: Row(
          mainAxisSize: .min,
          spacing: 8,
          children: [
            MochiButton(
              appearance: .outlined,
              onPress: widget.onCancel,
              child: Text(context.l10n.commonCancel),
            ),
            MochiButton(child: Text(context.l10n.commonSave), onPress: () => widget.onSave(_controller.text)),
          ],
        ),
      ),
    );
  }
}

class _SessionTile extends StatefulWidget {
  final String currentSessionId;
  final SessionEntry session;
  final VoidCallback afterDeletedCurrent;
  const _SessionTile({
    required this.currentSessionId,
    required this.session,
    required this.afterDeletedCurrent,
  });

  @override
  State<_SessionTile> createState() => _SessionTileState();
}

class _SessionTileState extends State<_SessionTile> {
  bool _isEditing = false;

  RecordsDao get recordsDao => context.read<AppDatabase>().recordsDao;
  SessionsDao get sessionsDao => context.read<AppDatabase>().sessionsDao;
  AppStateDao get appStateDao => context.read<AppDatabase>().appStateDao;

  List<Widget> _menu(BuildContext _) {
    return [
      MochiMenuItem(
        prefix: const Icon(TablerIcons.edit),
        title: Text(context.l10n.commonRename),
        onPress: () {
          setState(() {
            _isEditing = true;
          });
        },
      ),
      MochiMenuItem(
        prefix: const Icon(TablerIcons.packageExport),
        title: Text(context.l10n.commonExport),
        onPress: () => exportRecords(context, widget.session),
      ),
      MochiMenuDivider(),
      MochiMenuItem(
        intent: .danger,
        enabled: widget.session.id != kDefaultSessionId,
        prefix: Icon(TablerIcons.trash),
        title: Text(context.l10n.commonDelete),
        onPress: () async {
          final answer = await showMochiConfirm(
            context,
            title: context.l10n.sessionDeleteTitle,
            message: context.l10n.sessionDeleteMessage(widget.session.name),
            confirmLabel: context.l10n.commonDelete,
            destructive: true,
          );
          if (answer) {
            await sessionsDao.softDelete(widget.session.id);
            if (widget.session.id == widget.currentSessionId) {
              await appStateDao.setSession(kDefaultSessionId);
              widget.afterDeletedCurrent();
            }
          }
        },
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final isSelected = widget.session.id == widget.currentSessionId;

    return MochiContextMenu(
      longPress: !_isEditing,
      menuBuilder: _menu,
      child: _isEditing
          ? _SessionNameEditTile(
              isSelected: isSelected,
              initialName: widget.session.name,
              onCancel: () {
                setState(() {
                  _isEditing = false;
                });
              },
              onSave: (newName) async {
                if (newName.isNotEmpty && newName != widget.session.name) {
                  await sessionsDao.setName(widget.session.id, newName);
                }

                if (mounted) {
                  setState(() {
                    _isEditing = false;
                  });
                }
              },
            )
          : MochiTile(
              selected: isSelected,
              prefix: Icon(TablerIcons.stack),
              title: Text(widget.session.name),
              suffix: MochiPopoverMenu(
                menuBuilder: _menu,
                builder: (context, anchor, child) => MochiButton.icon(
                  appearance: .ghost,
                  onPress: anchor.toggle,
                  icon: Icon(TablerIcons.dotsVertical),
                ),
              ),
              onPress: () {
                appStateDao.setSession(widget.session.id);
                context.pop();
              },
            ),
    );
  }
}
