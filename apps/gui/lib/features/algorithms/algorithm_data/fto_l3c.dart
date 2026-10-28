import "common.dart";

/// FTO last three corners (L3C), one look: the five cases of the Nautilus method, after
/// https://nautilusfto.com/Step4/ and its algorithm sheet.
///
/// `ftoStickers` is read as in `fto_l6x.dart`, followed by the three corners of the layer's face and
/// the nine stickers round them: `b` B (blue), `p` L (purple), `r` R (red), `y` the layer's own. An
/// `[AUF dependent]` algorithm needs the layer turned a particular way first; the others work from
/// any turn.
final List<AlgorithmCase> ftoL3cCases = [
  const AlgorithmCase(
    id: "two-flip",
    name: "Two Flip",
    description: "Pure two flip",
    group: "Last Three Corners",
    ftoStickers: "ooolllgggbpylyogyolgr",
    algorithms: ["{R,D} D' R' U' R B' R' B R' L R L' U R D", "(U) r' U' R' F' U r' F r U' F U' R U r", "[AUF dependent] R' BR' R U R' U' BR r U R U' r' U'"],
  ),
  const AlgorithmCase(
    id: "flip-cw",
    name: "Flip CW",
    description: "Two flip clockwise permutation",
    group: "Last Three Corners",
    ftoStickers: "lllgggooobpylyogyolgr",
    algorithms: ["(U) {L,F} U R' F' R U' BR U R' F' R U'", "{L,U} U' R BR' R' U F U' R BR' R' U", "[AUF dependent] r U R' U' R F R' U R F' U' r'", "[AUF dependent] R U R' U' F' U r U R U' r' U' F R'", "[Corner at UF: align to UBL, then {U,L}] br' R U' R' br U br' R U' R' br", "[Corner at UBR: align to UF] {U,R} r' F U' F' r U r' F U' F' r"],
  ),
  const AlgorithmCase(
    id: "flip-ccw",
    name: "Flip CCW",
    description: "Two flip counterclockwise permutation",
    group: "Last Three Corners",
    ftoStickers: "ooolllgggrbygyloylgop",
    algorithms: ["(U) {L,F} U R' F R U' BR' U R' F R U'", "{L,U} U' R BR R' U F' U' R BR R' U", "[AUF dependent] (U) r U F R' U' R F' R' U R U' r'", "[AUF dependent] (U) R F' U r U R' U' r' U' F U R U' R'", "[Corner at UF: align to UBL, then {U,L}] (U') R' br U br' R U' R' br U br' R", "[Corner at UBR: align to UF] (U') {F,R} F R U' R' F' R U R' U' R' F R U R' F'", "[Corner at UBL: align to UBL] (U') {U,R} F' r U r' F U' F' r U r' F"],
  ),
  const AlgorithmCase(
    id: "cw",
    name: "CW",
    description: "Clockwise permutation",
    group: "Last Three Corners",
    ftoStickers: "lllgggoooyyyoblopglgr",
    algorithms: ["{F,BR} R' U R' D' R U' R' D R2", "br' R br' U' br R' br' U br'", "[AUF dependent] {U,R} r' U r' BR' r U' r' BR r2"],
  ),
  const AlgorithmCase(
    id: "ccw",
    name: "CCW",
    description: "Counterclockwise permutation",
    group: "Last Three Corners",
    ftoStickers: "lllgggoooyyygpogrlolb",
    algorithms: ["{F,BR} R2' D' R U R' D R U' R", "br U' br R br' U br R' br", "[AUF dependent] {U,R} r2' BR' r U r' BR r U' r"],
  ),
];
