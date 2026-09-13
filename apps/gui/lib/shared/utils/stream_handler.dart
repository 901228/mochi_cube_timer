import "package:flutter/widgets.dart";
import "package:forui/forui.dart";

/// The widget to show for a snapshot that has no data yet, or `null` once it does.
///
/// [description] names what is being watched, e.g. "watching the sessions", so a
/// reported error says which stream failed.
Widget? streamHandler(BuildContext context, AsyncSnapshot snapshot, {required String description}) {
  // A failed stream is not a slow one; without this branch it arrives as a
  // spinner that never stops.
  if (snapshot.error case final error?) {
    FlutterError.reportError(
      FlutterErrorDetails(
        exception: error,
        stack: snapshot.stackTrace,
        library: "mochi cube timer",
        context: ErrorDescription(description),
      ),
    );
    return Center(child: Icon(FLucideIcons.triangleAlert, color: context.theme.colors.destructive));
  }

  if (snapshot.data == null) return const Center(child: FCircularProgress());

  return null;
}
