#!/usr/bin/env bash

set -euo pipefail

ENGINE_ROOT="$HOME/git/engine/src"
DART_SDK="$ENGINE_ROOT/out/host_debug_unopt/dart-sdk"
DART="$DART_SDK/bin/dart"
INPUT="$HOME/git/tmp/dart_const_test_foo/main.dart"
OUTPUT="$HOME/git/tmp/dart_const_test_foo/app.dill"

echo "Hello $DART_SDK/bin/snapshots/dart2js.snapshot"

"$DART" --disable-dart-dev \
  "$DART_SDK/bin/snapshots/dart2js.dart.snapshot" \
  "--libraries-spec=$ENGINE_ROOT/out/host_debug_unopt/flutter_web_sdk/libraries.json" \
  -Ddart.vm.product=true \
  --no-source-maps \
  -o "$OUTPUT" \
  --cfe-only \
  "$INPUT"
#  '--libraries-spec=$ENGINE_ROOT/out/host_debug_unopt/flutter_web_sdk/libraries.json',
#      ...decodeCommaSeparated(environment.defines, kExtraFrontEndOptions),
#      if (nativeNullAssertions)
#        '--native-null-assertions',
#      if (buildMode == BuildMode.profile)
#        '-Ddart.vm.profile=true'
#      else
#        '-Ddart.vm.product=true',
#      for (final String dartDefine in decodeDartDefines(environment.defines, kDartDefines))
#        '-D$dartDefine',
#      if (!sourceMapsEnabled)
#        '--no-source-maps',
#    ]

#      '-o',
#      environment.buildDir.childFile('app.dill').path,
#      '--packages=.dart_tool/package_config.json',
#      '--cfe-only',
#      environment.buildDir.childFile('main.dart').path, // dartfile

