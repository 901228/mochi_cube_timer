import "package:flutter/widgets.dart";
import "package:mochi_ui/mochi_ui.dart";

import "../theme/typography_timer.dart";
import "router.dart";

class Application extends StatelessWidget {
  const new({super.key});

  MochiTheme _customTheme(MochiTheme base) => base.copyWith(
    extensions: [TimerTypography.standard],
    defaults: MochiDefaults(transition: .slide),
  );

  @override
  Widget build(BuildContext context) => MochiApp.router(
    title: "Mochi Cube Timer",
    routerConfig: router,
    lightTheme: _customTheme(MochiTheme.light),
    darkTheme: _customTheme(MochiTheme.dark),
  );
}
