#!/bin/bash

set -e
set -o pipefail
set -x

SCRIPT_DIRECTORY="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
ROOT_DIRECTORY="${SCRIPT_DIRECTORY}/.."

cd "$ROOT_DIRECTORY"

BUILD_DESTINATION="platform=macOS"

xcodebuild -scheme Interact -showdestinations
xcodebuild -scheme Interact -destination "$BUILD_DESTINATION" clean build
