import "package:cube_timer/cube_timer.dart";
import "package:flutter/widgets.dart";
import "package:flutter_bloc/flutter_bloc.dart";
import "package:go_router/go_router.dart";
import "package:mochi_ui/mochi_ui.dart";

import "../../shared/utils.dart";

Future<void> showSessionSelectionDialog(BuildContext context, {required String sessionId}) async {
  final creating = ValueNotifier(false);

  await showMochiModal(
    context,
    title: const Text("Select a session"),
    titleSuffix: MochiActionBar([
      MochiAction(
        icon: TablerIcons.stackPlus,
        label: "Create new session",
        onPress: () {
          creating.value = true;
        },
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
            MochiButton(appearance: .outlined, onPress: widget.onCancel, child: const Text("Cancel")),
            MochiButton(child: const Text("Save"), onPress: () => widget.onSave(_controller.text)),
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

  late final dao = context.read<AppDatabase>().sessionsDao;
  late final appStateDao = context.read<AppDatabase>().appStateDao;

  List<Widget> _menu(BuildContext context) {
    return [
      MochiMenuItem(
        prefix: Icon(TablerIcons.edit),
        title: const Text("Rename"),
        onPress: () {
          setState(() {
            _isEditing = true;
          });
        },
      ),
      MochiMenuDivider(),
      MochiMenuItem(
        intent: .danger,
        enabled: widget.session.id != kDefaultSessionId,
        prefix: Icon(TablerIcons.trash),
        title: const Text("Delete"),
        onPress: () async {
          final answer = await showMochiConfirm(
            context,
            title: "Delete session?",
            message: 'All solves in "${widget.session.name}" will be permanently deleted.',
            confirmLabel: "Delete",
            destructive: true,
          );
          if (answer) {
            await dao.softDelete(widget.session.id);
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
                  await dao.setName(widget.session.id, newName);
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
