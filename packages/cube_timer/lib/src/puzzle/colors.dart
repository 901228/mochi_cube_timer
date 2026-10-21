enum DefaultColorsPreset {
  white(0xFFFFFFFF),
  yellow(0xFFFFFF00),
  orange(0xFFFFC13D),
  red(0xFFEE6B6B),
  green(0xFF00FF7F),
  blue(0xFF1E90FF),
  black(0xFF000000),
  lime(0xFF77EE00),
  purple(0xFFB020C8),
  grey(0xFF999999),
  darkGreen(0xFF006600),
  lightYellow(0xFFFFFFBB),
  pink(0xFFFF99FF),
  lightBlue(0xFF88DDFF),
  ice(0xFFD3F5FF);

  const DefaultColorsPreset(this.value);

  final int value;

  static List<int> get presetList => values.map((e) => e.value).toList();
}

class DefaultColors {
  static const cubeColors = (
    U: DefaultColorsPreset.white,
    R: DefaultColorsPreset.red,
    F: DefaultColorsPreset.green,
    D: DefaultColorsPreset.yellow,
    L: DefaultColorsPreset.orange,
    B: DefaultColorsPreset.blue,
  );

  static const pyraminxColors = (
    U: DefaultColorsPreset.yellow,
    B: DefaultColorsPreset.green,
    R: DefaultColorsPreset.red,
    L: DefaultColorsPreset.blue,
  );

  static const megaminxColors = (
    u: DefaultColorsPreset.white,
    bl: DefaultColorsPreset.yellow,
    br: DefaultColorsPreset.blue,
    r: DefaultColorsPreset.red,
    f: DefaultColorsPreset.darkGreen,
    l: DefaultColorsPreset.purple,
    d: DefaultColorsPreset.grey,
    dr: DefaultColorsPreset.lightYellow,
    dbr: DefaultColorsPreset.pink,
    b: DefaultColorsPreset.lime,
    dbl: DefaultColorsPreset.orange,
    dl: DefaultColorsPreset.lightBlue,
  );

  static const ftoColors = (
    u: DefaultColorsPreset.white,
    r: DefaultColorsPreset.red,
    f: DefaultColorsPreset.lime,
    l: DefaultColorsPreset.purple,
    b: DefaultColorsPreset.blue,
    bl: DefaultColorsPreset.orange,
    d: DefaultColorsPreset.yellow,
    br: DefaultColorsPreset.grey,
  );

  static const clockColors = (
    front: DefaultColorsPreset.ice,
    back: DefaultColorsPreset.blue,
  );

  /// The timer's time while a press is waiting, holding through inspection, and armed to start.
  static const timerColors = (
    pressed: DefaultColorsPreset.red,
    holding: DefaultColorsPreset.yellow,
    accept: DefaultColorsPreset.green,
  );
}
