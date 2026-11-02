#!/bin/sh
# Rebuilds the algorithm data files in apps/gui/lib/features/algorithms/algorithm_data from SpeedCubeDB.
# Needs curl, python3 and dart. Run from anywhere; review the diff, the pages change over time.
set -eu

here=$(cd "$(dirname "$0")" && pwd)
out="$here/../../apps/gui/lib/features/algorithms/algorithm_data"
pages=$(mktemp -d)
trap 'rm -rf "$pages"' EXIT

# page, file, Dart name, doc line, mode [, cube size]; modes are described in gen.py
gen() {
  page=$1 file=$2 var=$3 doc=$4 mode=$5 size=${6-}
  html="$pages/$(echo "$page" | tr / _).html"
  [ -f "$html" ] || curl -sf -o "$html" "https://www.speedcubedb.com/a/$page"
  python3 -I "$here/gen.py" "$html" "$var" "$doc" "$mode" $size > "$out/$file.dart"
}

gen 2x2/OrtegaOLL cube2_ortega_oll ortegaOllCases "Ortega OLL: orient the last layer of a 2x2." top
gen 2x2/OrtegaPBL cube2_ortega_pbl ortegaPblCases "Ortega PBL: permute both layers of a 2x2." iso-sim-pbl 2
gen 2x2/CLL cube2_cll cllCases "CLL: solve the last layer of a 2x2 in one step." top
gen 3x3/F2L cube3_f2l f2lCases "F2L: solve a corner-edge pair." iso-sim-f2l 3
gen 3x3/WV cube3_wv wvCases "Winter Variation: orient the last layer while inserting the last F2L pair." top
gen 3x3/SV cube3_sv svCases "Summer Variation: orient the last layer while inserting the last F2L pair." top
gen 3x3/COLL cube3_coll collCases "COLL: solve the last-layer corners when its edges are oriented." top
gen 4x4/OLLParity big_cube_oll_parity ollParityCases "OLL parity: flip a single dedge of a 4x4." top
gen 4x4/PLLParity big_cube_pll_parity pllParityCases "PLL parity: swap two dedges of a 4x4." top
gen 5x5/L2C big_cube_l2c l2cCases "L2C: solve the last two centers of a 5x5." faces-jcube
gen 5x5/L2E big_cube_l2e l2eCases "L2E: pair the last two edges of a 5x5." top

dart format "$out"
