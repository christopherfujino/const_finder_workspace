#!/usr/bin/env bash

set -euo pipefail

ENGINE_ROOT="$HOME/git/engine/src"
DART_SDK="$ENGINE_ROOT/out/host_debug_unopt/dart-sdk"
DART="$DART_SDK/bin/dart"
INPUT="$HOME/git/tmp/delete_me_flutter/"

"$DART" \
  "./lib/const_finder.dart" \
  "/usr/local/google/home/fujino/git/tmp/delete_me_flutter/.dart_tool/flutter_build/aff9248bd66e9b2a3681f5d33fa87a79/app.dill"
