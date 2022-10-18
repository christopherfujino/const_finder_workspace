#!/usr/bin/env bash

set -euo pipefail

ENGINE_ROOT="$HOME/git/engine/src"
DART_SDK="$ENGINE_ROOT/out/host_debug_unopt/dart-sdk"
DART="$DART_SDK/bin/dart"
INPUT_DILL="$1"

DUMP_SCRIPT="$ENGINE_ROOT/third_party/dart/pkg/kernel/bin/dump.dart"

"$DART" "$DUMP_SCRIPT" "$INPUT_DILL"
