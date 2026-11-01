import "../../../l10n/l10n.dart";
import "pll_rules.dart";

/// The words of the guide, for the rules and groups of [PllRule] and [PllGroup].
String pllGroupTitle(AppLocalizations l10n, PllGroup group) => switch (group) {
  PllGroup.threeBar => l10n.pllGroupThreeBar,
  PllGroup.doubleLights => l10n.pllGroupDoubleLights,
  PllGroup.lightsAndBar => l10n.pllGroupLightsAndBar,
  PllGroup.loneLights => l10n.pllGroupLoneLights,
  PllGroup.doubleBar => l10n.pllGroupDoubleBar,
  PllGroup.outsideBar => l10n.pllGroupOutsideBar,
  PllGroup.insideBar => l10n.pllGroupInsideBar,
  PllGroup.bookends => l10n.pllGroupBookends,
  PllGroup.noBookends => l10n.pllGroupNoBookends,
};

String pllGroupInfo(AppLocalizations l10n, PllGroup group) => switch (group) {
  PllGroup.threeBar => l10n.pllGroupThreeBarInfo,
  PllGroup.doubleLights => l10n.pllGroupDoubleLightsInfo,
  PllGroup.lightsAndBar => l10n.pllGroupLightsAndBarInfo,
  PllGroup.loneLights => l10n.pllGroupLoneLightsInfo,
  PllGroup.doubleBar => l10n.pllGroupDoubleBarInfo,
  PllGroup.outsideBar => l10n.pllGroupOutsideBarInfo,
  PllGroup.insideBar => l10n.pllGroupInsideBarInfo,
  PllGroup.bookends => l10n.pllGroupBookendsInfo,
  PllGroup.noBookends => l10n.pllGroupNoBookendsInfo,
};

String pllRuleLabel(AppLocalizations l10n, PllRule rule) => switch (rule) {
  PllRule.threeBarHeadlights => l10n.pllRuleThreeBarHeadlights,
  PllRule.threeBarTwoBar => l10n.pllRuleThreeBarTwoBar,
  PllRule.threeBarFourColours => l10n.pllRuleThreeBarFourColours,
  PllRule.doubleLightsChecker => l10n.pllRuleDoubleLightsChecker,
  PllRule.doubleLights21 => l10n.pllRuleDoubleLights21,
  PllRule.doubleLightsOpposite => l10n.pllRuleDoubleLightsOpposite,
  PllRule.doubleLightsAdjacent => l10n.pllRuleDoubleLightsAdjacent,
  PllRule.lightsBarInside3 => l10n.pllRuleLightsBarInside3,
  PllRule.lightsBarInside4 => l10n.pllRuleLightsBarInside4,
  PllRule.lightsBarOutside3 => l10n.pllRuleLightsBarOutside3,
  PllRule.lightsBarOutside4 => l10n.pllRuleLightsBarOutside4,
  PllRule.loneLights5 => l10n.pllRuleLoneLights5,
  PllRule.loneLights4 => l10n.pllRuleLoneLights4,
  PllRule.loneLightsOpposite => l10n.pllRuleLoneLightsOpposite,
  PllRule.loneLightsAdjacent => l10n.pllRuleLoneLightsAdjacent,
  PllRule.doubleBarOutside => l10n.pllRuleDoubleBarOutside,
  PllRule.doubleBarInsideBookends => l10n.pllRuleDoubleBarInsideBookends,
  PllRule.doubleBarInsideNone => l10n.pllRuleDoubleBarInsideNone,
  PllRule.doubleBarSameBookends => l10n.pllRuleDoubleBarSameBookends,
  PllRule.doubleBarSameNone => l10n.pllRuleDoubleBarSameNone,
  PllRule.outsideBarNone => l10n.pllRuleOutsideBarNone,
  PllRule.outsideBarAdjacentTwice => l10n.pllRuleOutsideBarAdjacentTwice,
  PllRule.outsideBarOppositeTwice => l10n.pllRuleOutsideBarOppositeTwice,
  PllRule.outsideBarAdjacent => l10n.pllRuleOutsideBarAdjacent,
  PllRule.outsideBarOpposite => l10n.pllRuleOutsideBarOpposite,
  PllRule.insideBarAdjacent => l10n.pllRuleInsideBarAdjacent,
  PllRule.insideBarOpposite => l10n.pllRuleInsideBarOpposite,
  PllRule.insideBarNone => l10n.pllRuleInsideBarNone,
  PllRule.bookends4 => l10n.pllRuleBookends4,
  PllRule.bookendsAdjacentTwice => l10n.pllRuleBookendsAdjacentTwice,
  PllRule.bookendsOppositeTwice => l10n.pllRuleBookendsOppositeTwice,
  PllRule.noBookendsInner4 => l10n.pllRuleNoBookendsInner4,
  PllRule.noBookendsOuter4 => l10n.pllRuleNoBookendsOuter4,
  PllRule.noBookends5 => l10n.pllRuleNoBookends5,
};
