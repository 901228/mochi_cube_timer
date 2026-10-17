import "package:flutter/foundation.dart" show TargetPlatform, defaultTargetPlatform;
import "package:flutter/widgets.dart";

import "app_localizations.dart";

export "app_localizations.dart";

/// iOS has its own per-app language setting, so the app has no picker of its own there.
bool get systemPicksLanguage => defaultTargetPlatform == TargetPlatform.iOS;

extension AppLocalizationsContext on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
