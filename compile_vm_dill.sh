#!/usr/bin/env bash

set -euo pipefail

ENGINE_ROOT="$HOME/git/engine/src"
DART_SDK="$ENGINE_ROOT/out/host_debug_unopt/dart-sdk"
DART="$DART_SDK/bin/dart"
INPUT="$1"
OUTPUT="$2"

"$DART" \
  compile \
  kernel \
  -Ddart.vm.product=true \
  --output "$OUTPUT" \
  "$INPUT"
