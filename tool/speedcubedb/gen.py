"""SpeedCubeDB category page -> Dart AlgorithmCase list, with a cube simulator for pages that have no stickers.

Run through regenerate.sh, which knows which page makes which data file.

usage: gen.py <page.html> <dart var> <doc line> <mode> [n]
modes: none | top (jcube top view) | faces-jcube (jcube U and F) | iso-sim-pbl | iso-sim-f2l (simulated, needs n)
       verify-top (compare simulated top views with the page's, needs n; prints a report, no Dart)
Letters are the faces of a solved cube held with yellow up and green front: y U, w D, g F, b B, o R, r L; l = unknown.
"""
import html
import re
import sys
from itertools import product

# ---------- page ----------

def clean(alg_html):
    full = re.search(r'class="fullalg">(.*?)</span>\s*$', alg_html, re.S)
    text = full.group(1) if full else alg_html
    text = re.sub(r"<[^>]+>", " ", text)
    return re.sub(r"\s+", " ", html.unescape(text)).strip()


def parse(page):
    src = open(page, encoding="utf-8").read()
    cases = []
    for b in src.split('class="row singlealgorithm')[1:]:
        name = html.unescape(re.search(r'data-alg="([^"]*)"', b).group(1))
        sub = html.unescape(re.search(r'data-subgroup="([^"]*)"', b).group(1)) or "All"
        cube = re.search(r'<div class="jcube"([^>]*)>', b)
        faces = dict(re.findall(r'data-(u[sbflr])="([^"]*)"', cube.group(1))) if cube else None
        ori0 = b.split("<div data-ori='1'>")[0]
        algs = [clean(a) for a in re.findall(r'<div class="formatted-alg">(.*?)</div>\s*</div>', ori0, re.S)]
        cases.append({"name": name, "sub": sub, "faces": faces, "algs": algs})
    return cases


def jcube_top(f):
    n = int(round(len(f["us"]) ** 0.5))
    return f["us"] + f["ub"][:n][::-1] + f["ur"][:n][::-1] + f["uf"][:n] + f["ul"][:n]


def jcube_faces(f):
    return f["us"] + f["uf"]

# ---------- simulator ----------

AXES = {"x": 0, "y": 1, "z": 2}
FACE = {"R": (0, 1), "L": (0, -1), "U": (1, 1), "D": (1, -1), "F": (2, 1), "B": (2, -1)}
COLOR = {(1, 1): "y", (1, -1): "w", (2, 1): "g", (2, -1): "b", (0, 1): "o", (0, -1): "r"}


def rot90(v, k):
    """+90 degrees about axis k (right hand)."""
    x, y, z = v
    return [(x, -z, y), (z, y, -x), (-y, x, z)][k]


def solved(n):
    st = []
    rng = range(-(n - 1), n, 2)
    for (k, s), col in COLOR.items():
        others = [a for a in range(3) if a != k]
        for i, j in product(rng, rng):
            p = [0, 0, 0]
            p[k] = s * (n - 1)
            p[others[0]], p[others[1]] = i, j
            nrm = [0, 0, 0]
            nrm[k] = s
            st.append((tuple(p), tuple(nrm), col))
    return st


TOKEN = re.compile(r"^(\d+)?(?:-(\d+))?([UDFBLRudfblrMESxyz])(w?)((?:2|3)?'?|'?2?)$")


def parse_move(tok, n):
    m = TOKEN.match(tok)
    if not m:
        raise ValueError(f"bad move {tok!r}")
    a, b, f, w, suf = m.groups()
    amount = 2 if "2" in suf else (3 if "3" in suf else 1)
    if "'" in suf:
        amount = -amount
    if f in "xyz":
        face, layers = {"x": "R", "y": "U", "z": "F"}[f], range(1, n + 1)
    elif f in "MES":
        face = {"M": "L", "E": "D", "S": "F"}[f]
        layers = range((n + 1) // 2, (n + 1) // 2 + 1) if n % 2 else range(2, n)
    else:
        face = f.upper()
        if b:
            layers = range(int(a), int(b) + 1)
        elif w or f.islower():
            layers = range(1, (int(a) if a else 2) + 1)
        else:
            layers = range(int(a or 1), int(a or 1) + 1)
    return face, set(layers), amount


def apply(st, alg, n, inverse=False):
    toks = [t for t in re.split(r"[\s()\[\]]+", alg) if t]
    moves = [parse_move(t, n) for t in toks]
    if inverse:
        moves = [(f, l, -a) for f, l, a in reversed(moves)]
    for face, layers, amount in moves:
        k, s = FACE[face]
        turns = (-s * amount) % 4
        out = []
        for p, nrm, c in st:
            layer = (n - 1 - s * p[k]) // 2 + 1
            if layer in layers:
                for _ in range(turns):
                    p, nrm = rot90(p, k), rot90(nrm, k)
            out.append((p, nrm, c))
        st = out
    return st


def at(st, p, nrm):
    for q, m, c in st:
        if q == p and m == nrm:
            return c
    raise KeyError((p, nrm))


def oriented(st, n):
    if n % 2:
        return at(st, (0, n - 1, 0), (0, 1, 0)) == "y" and at(st, (0, 0, n - 1), (0, 0, 1)) == "g"
    c = -(n - 1)
    return (at(st, (c, c, c), (0, -1, 0)), at(st, (c, c, c), (0, 0, -1)), at(st, (c, c, c), (-1, 0, 0))) == ("w", "b", "r")


def normalize(st, n):
    """Turns the whole cube so yellow is up and green front (odd), or the DBL corner is home (2x2)."""
    seen = [""]
    for seq in product(["", "x", "y", "z"], repeat=3):
        for extra in ["", "x2", "y2", "z2", "x'", "y'", "z'"]:
            alg = " ".join(s for s in (*seq, extra) if s)
            t = apply(st, alg, n)
            if oriented(t, n):
                return t
    raise ValueError("cannot orient")


def top_view(st, n):
    e = n - 1
    r = range(-e, n, 2)
    out = [at(st, (x, e, z), (0, 1, 0)) for z in r for x in r]
    out += [at(st, (x, e, -e), (0, 0, -1)) for x in r]
    out += [at(st, (e, e, z), (1, 0, 0)) for z in r]
    out += [at(st, (x, e, e), (0, 0, 1)) for x in r]
    out += [at(st, (-e, e, z), (-1, 0, 0)) for z in r]
    return "".join(out)


def iso_view(st, n, hide=lambda p: False):
    e = n - 1
    r = range(-e, n, 2)
    down = range(e, -n, -2)
    cells = [((x, e, z), (0, 1, 0)) for z in r for x in r]
    cells += [((x, y, e), (0, 0, 1)) for y in down for x in r]
    cells += [((e, y, z), (1, 0, 0)) for y in down for z in down]
    return "".join("l" if hide(p) else at(st, p, m) for p, m in cells)


def case_state(alg, n):
    return normalize(apply(solved(n), alg, n, inverse=True), n)


def only_fr_pair_unsolved(st, n):
    home = {(p, m): c for p, m, c in normalize(solved(n), n)}
    pieces = piece_colors(st)
    wrong = {frozenset(pieces[p]) for p, m, c in st if "y" not in pieces[p] and home[(p, m)] != c}
    return bool(wrong) and wrong <= {frozenset("wgo"), frozenset("go")}


def piece_colors(st):
    pieces = {}
    for p, _, c in st:
        pieces.setdefault(p, set()).add(c)
    return pieces

# ---------- output ----------

def slug(name):
    return re.sub(r"[^a-z0-9]+", "-", name.lower()).strip("-")


def q(s):
    return '"' + s.replace("\\", "\\\\").replace('"', '\\"').replace("$", "\\$") + '"'


def main():
    page, var, doc, mode = sys.argv[1:5]
    n = int(sys.argv[5]) if len(sys.argv) > 5 else None
    cases = parse(page)

    if mode == "verify-top":
        first = anyalg = 0
        for c in cases:
            want = jcube_top(c["faces"])
            ok = []
            for a in c["algs"]:
                got = top_view(case_state(a, n), n)
                ok.append(all(w == "l" or w == g for w, g in zip(want, got)))
            first += ok[0]
            anyalg += any(ok)
            if not ok[0]:
                print("first alg differs:", c["name"], sum(ok), "/", len(ok), "algs match", file=sys.stderr)
        print(f"{page}: first alg matches {first}/{len(cases)}, some alg matches {anyalg}/{len(cases)}")
        return

    ids = [slug(c["name"]) for c in cases]
    assert len(ids) == len(set(ids)), ids
    print('import "common.dart";\n')
    print(f"/// {doc} From SpeedCubeDB.")
    print(f"const List<AlgorithmCase> {var} = [")
    for id_, c in zip(ids, cases):
        field = None
        if mode == "top":
            field = ("cubeStickers", jcube_top(c["faces"]))
        elif mode == "faces-jcube":
            field = ("faceStickers", jcube_faces(c["faces"]))
        elif mode.startswith("iso-sim"):
            st = case_state(c["algs"][0], n)
            hide = lambda p: False
            if mode == "iso-sim-f2l":
                # some algs start with a rotation and solve another slot; draw the first that solves front-right
                st = next(s for s in (case_state(a, n) for a in c["algs"]) if only_fr_pair_unsolved(s, n))
                pieces = piece_colors(st)
                hide = lambda p: "y" in pieces[p]
            field = ("isoStickers", iso_view(st, n, hide))
        print("  AlgorithmCase(")
        print(f"    id: {q(id_)},")
        print(f"    name: {q(c['name'])},")
        print(f"    group: {q(c['sub'])},")
        if field:
            print(f"    {field[0]}: {q(field[1])},")
        print(f"    algorithms: [{', '.join(q(a) for a in c['algs'])}],")
        print("  ),")
    print("];")


main()
