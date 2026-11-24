#!/bin/bash
#
# Repackages Microsoft's ONNX Runtime pod archive as a static-library XCFramework, with unchanged object code.
# The pod archive wraps the static library in onnxruntime.framework. Xcode then embeds a stub framework whose
# minimum iOS differs from its Info.plist, which App Store Connect rejects (ITMS-90208).
#
# usage: scripts/repackage.sh <pod-archive-onnxruntime-c-1.24.2.zip> <output directory>
# Prints the SwiftPM checksum of <output directory>/onnxruntime.xcframework.zip.

set -euo pipefail

ARCHIVE="$1"
OUT="$2"
EXPECTED_SHA="f7100a992d2a8135168c8afd831e6a58b465349101982aa58b3e11d36e600b54"

[[ "$(shasum -a 256 "$ARCHIVE" | awk '{print $1}')" == "$EXPECTED_SHA" ]] || { echo "error: not the 1.24.2 pod archive" >&2; exit 1; }
WORK="$(mktemp -d)"
trap 'rm -rf "$WORK"' EXIT

unzip -q "$ARCHIVE" -d "$WORK/pod"
mkdir -p "$WORK/include/onnxruntime"
cp "$WORK"/pod/Headers/*.h "$WORK/include/onnxruntime/"

ARGS=()
for slice in "$WORK"/pod/onnxruntime.xcframework/*/; do
    name="$(basename "$slice")"
    mkdir -p "$WORK/lib/$name"
    cp "$slice/onnxruntime.framework/onnxruntime" "$WORK/lib/$name/libonnxruntime.a"
    ARGS+=(-library "$WORK/lib/$name/libonnxruntime.a" -headers "$WORK/include")
done

mkdir -p "$OUT"
rm -rf "$OUT/onnxruntime.xcframework" "$OUT/onnxruntime.xcframework.zip"
xcodebuild -create-xcframework "${ARGS[@]}" -output "$OUT/onnxruntime.xcframework" >/dev/null
(cd "$OUT" && zip -qry onnxruntime.xcframework.zip onnxruntime.xcframework)
swift package compute-checksum "$OUT/onnxruntime.xcframework.zip"
