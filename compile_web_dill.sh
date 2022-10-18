#!/usr/bin/env bash

set -euo pipefail

ENGINE_ROOT="$HOME/git/engine/src"
DART_SDK="$ENGINE_ROOT/out/host_debug_unopt/dart-sdk"
DART="$DART_SDK/bin/dart"
INPUT="$1"
OUTPUT="$2"

"$DART" --disable-dart-dev \
  "$DART_SDK/bin/snapshots/dart2js.dart.snapshot" \
  "--libraries-spec=$ENGINE_ROOT/out/host_debug_unopt/flutter_web_sdk/libraries.json" \
  -Ddart.vm.product=true \
  --no-source-maps \
  -o "$OUTPUT" \
  --cfe-only \
  "$INPUT"
