#!/usr/bin/env bash

set -euo pipefail

ENGINE_ROOT="$HOME/git/engine/src"
DART_SDK="$ENGINE_ROOT/out/host_debug_unopt/dart-sdk"
DART="$DART_SDK/bin/dart"
INPUT="$HOME/git/tmp/delete_me_flutter/"

"$DART" \
  "./lib/const_finder.dart" \
  "/usr/local/google/home/fujino/git/tmp/delete_me_flutter/.dart_tool/flutter_build/eb90bde4b0b18be5229329e4d5ee647f/app.dill"
