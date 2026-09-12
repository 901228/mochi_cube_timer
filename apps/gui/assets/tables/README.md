# Prebuilt solver tables

The scramblers' lookup tables, built ahead of time so the web build does not
spend a second or more building them on the one thread it has. `main.dart`
hands them to mochi_cube through `useTableBytesLoader`.

Regenerate them whenever a table builder changes — which is also when the
`TableFile` version in mochi_cube gets bumped, and a stale file here is then
rejected on load and rebuilt at startup, with only a log line to say so:

```bash
cd ../../../../mochi_cube    # wherever the package is checked out
dart run bin/mochi_cube.dart tables --rebuild --out <this directory>
```

The files are written host endian, so regenerate them on a little endian
machine; a big endian one produces tables every browser will reject.
