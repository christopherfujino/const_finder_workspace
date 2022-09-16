#!/usr/bin/env bash

set -euo pipefail

ENGINE_ROOT="$HOME/git/engine/src"
DART="$ENGINE_ROOT/out/host_debug_unopt/dart-sdk/bin/dart"
CONST_FINDER="$ENGINE_ROOT/flutter/tools/const_finder/bin/main.dart"
APP_DILL="$HOME/git/tmp/dart_const_test_foo/app.dill"

"$DART" \
  --disable-dart-dev \
  "$CONST_FINDER" \
  --kernel-file "$APP_DILL" \
  --class-library-uri 'file:///usr/local/google/home/fujino/git/tmp/dart_const_test_foo/main.dart' \
  --class-name Foo

#  --class-library-uri 'package:flutter/src/widgets/icon_data.dart' \
#  --class-name IconData
