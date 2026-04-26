#!/bin/bash
# ZuhrOS Installer Script
# Run this from the root of your LineageOS 23 source tree.

ZUHR_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LINEAGE_DIR=$(pwd)

echo "Initiating ZuhrOS Architecture..."

# 1. Apply C++ Compositor & RenderEngine Patches
echo "Patching frameworks/native..."
cd $LINEAGE_DIR/frameworks/native
git apply $ZUHR_DIR/patches/tasarruf_native.patch

# 2. Apply Java Settings UI Patches
echo "Patching packages/apps/Settings..."
cd $LINEAGE_DIR/packages/apps/Settings
git apply $ZUHR_DIR/patches/tasarruf_settings.patch

# 3. Apply SELinux Boundaries
echo "Patching system/sepolicy..."
cd $LINEAGE_DIR/system/sepolicy
git apply $ZUHR_DIR/patches/tasarruf_sepolicy.patch


# 4. Apply Device Specifics (Bluejay) - Note: This will change depending on device.
echo "Patching device/google/bluejay..."
cd $LINEAGE_DIR/device/google/bluejay
git apply $ZUHR_DIR/patches/tasarruf_bluejay.patch

# 5. Copy E-Ink Filter Preference Controller
echo "Installing EinkFilterPreferenceController..."
mkdir -p $LINEAGE_DIR/packages/apps/Settings/src/com/android/settings/development/
cp $ZUHR_DIR/src/EinkFilterPreferenceController.java $LINEAGE_DIR/packages/apps/Settings/src/com/android/settings/development/EinkFilterPreferenceController.java

# 6. Inject Boot Animation
echo "Injecting Boot Animation..."
cp $ZUHR_DIR/assets/bootanimation.zip $LINEAGE_DIR/device/google/bluejay/bootanimation.zip

echo "ZuhrOS Injection Complete. The system is ready for compilation."
