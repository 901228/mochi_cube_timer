import "package:flutter/widgets.dart";
import "package:mochi_ui/mochi_ui.dart";

import "../theme/typography_timer.dart";
import "router.dart";

class Application extends StatelessWidget {
  const new({super.key});

  @override
  Widget build(BuildContext context) => MochiApp.router(
    title: "Mochi Cube Timer",
    routerConfig: router,
    lightTheme: MochiTheme.light.copyWith(extensions: [TimerTypography.standard]),
    darkTheme: MochiTheme.dark.copyWith(extensions: [TimerTypography.standard]),
  );
}
