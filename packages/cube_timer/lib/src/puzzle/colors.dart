class DefaultColors {
  static const cubeColors = (
    U: 0xFFFFFFFF,
    R: 0xFFEE6B6B,
    F: 0xFF00FF7F,
    D: 0xFFFFFF00,
    L: 0xFFFFC13D,
    B: 0xFF1E90FF,
  );

  static const pyraminxColors = (U: 0xFFFFFF00, B: 0xFF00FF7F, R: 0xFFEE6B6B, L: 0xFF1E90FF);

  /// csTimer's Megaminx colours, found by matching its picture of a scramble to ours, with the
  /// yellow brightened and the purple moved away from the blue. The red, green, blue and orange are the
  /// cube's own R, F, B and L, copied here because a record's fields are not constants. Named for the faces of the layout.
  static const megaminxColors = (
    u: 0xFFFFFFFF,
    bl: 0xFFFFFF00,
    br: 0xFF1E90FF,
    r: 0xFFEE6B6B,
    f: 0xFF006600,
    l: 0xFFB020C8,
    d: 0xFF999999,
    dr: 0xFFFFFFBB,
    dbr: 0xFFFF99FF,
    b: 0xFF77EE00,
    dbl: 0xFFFFC13D,
    dl: 0xFF88DDFF,
  );

  static const clockColors = (front: 0xFFD3F5FF, back: 0xFF3F82FF);

  /// The timer's time while a press is waiting, holding through inspection, and armed to start.
  static const timerColors = (pressed: 0xFFFF7979, holding: 0xFFFFFF79, accept: 0xFF20E264);
}
