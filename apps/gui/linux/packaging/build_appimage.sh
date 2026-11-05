#!/bin/sh
# Packs the release bundle of `flutter build linux` into an AppImage. Run from apps/gui.
set -eu
arch=${ARCH:-x86_64}
bundle=build/linux/x64/release/bundle
appdir=build/AppDir
tool=${APPIMAGETOOL:-appimagetool}

rm -rf "$appdir"
mkdir -p "$appdir/usr/bin"
cp -R "$bundle"/. "$appdir/usr/bin/"
cp linux/packaging/mochi-timer.desktop "$appdir/"
cp assets/icon/icon.png "$appdir/mochi-timer.png"
cat > "$appdir/AppRun" <<'RUN'
#!/bin/sh
here=$(dirname "$(readlink -f "$0")")
exec "$here/usr/bin/gui" "$@"
RUN
chmod +x "$appdir/AppRun"

ARCH=$arch "$tool" "$appdir" "build/mochi_timer-$arch.AppImage"
