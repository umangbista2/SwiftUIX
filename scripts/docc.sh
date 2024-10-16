#!/bin/bash
# This script builds docc with SwiftUI module exports disabled.

# Variables
BUILD_FOLDER=".build"
DERIVED_FOLDER="$BUILD_FOLDER/derived"
DOCC_FOLDER="$BUILD_FOLDER/docc"

# Use the script folder to refer to the rewrite script.
SCRIPT_FOLDER="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
REWRITE="$SCRIPT_FOLDER/docc-swiftui-export-rewrite.sh"
chmod +x "$REWRITE"

# Disable SwiftUI module export
bash "$REWRITE" "@_exported import SwiftUI" "import SwiftUI"

# Build DocC documentation
swift package resolve;
xcodebuild docbuild -scheme SwiftUIX -derivedDataPath $DERIVED_FOLDER -destination 'generic/platform=iOS';

# Transform the generated documentation for static hosting
$(xcrun --find docc) process-archive \
    transform-for-static-hosting $DERIVED_FOLDER/Build/Products/Debug-iphoneos/SwiftUIX.doccarchive \
    --output-path $DOCC_FOLDER \
    --hosting-base-path 'SwiftUIX';

# Inject a redirect script into the empty documentation root
echo "<script>window.location.href += \"/documentation/swiftuix\"</script>" > $DOCC_FOLDER/index.html;

# Ensable SwiftUI module export
bash "$REWRITE" "import SwiftUI" "@_exported import SwiftUI"