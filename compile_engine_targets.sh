#!/usr/bin/env bash

set -euo pipefail

export GOMA_DIR="$HOME/flutter_goma"

cd ..

# build host binaries
./src/flutter/tools/gn --unoptimized --goma --no-prebuilt-dart-sdk

ninja -C ./out/host_debug_unopt
