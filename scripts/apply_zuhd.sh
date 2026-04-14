#!/bin/bash
# ZuhdOS Installer Script
# Run this from the root of your LineageOS 23 source tree.

ZUHD_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
LINEAGE_DIR=$(pwd)

echo "Initiating ZuhdOS Architecture..."

# 1. Apply C++ Compositor & RenderEngine Patches
echo "Patching frameworks/native..."
cd $LINEAGE_DIR/frameworks/native
git apply $ZUHD_DIR/patches/tasarruf_native.patch

# 2. Apply Java Settings UI Patches
echo "Patching packages/apps/Settings..."
cd $LINEAGE_DIR/packages/apps/Settings
git apply $ZUHD_DIR/patches/tasarruf_settings.patch

# 3. Apply SELinux Boundaries
echo "Patching system/sepolicy..."
cd $LINEAGE_DIR/system/sepolicy
git apply $ZUHD_DIR/patches/tasarruf_sepolicy.patch

# 4. Apply SystemUI XML Stamp
echo "Patching frameworks/base..."
cd $LINEAGE_DIR/frameworks/base
git apply $ZUHD_DIR/patches/tasarruf_base.patch

# 5. Apply Device Specifics (Bluejay)
echo "Patching device/google/bluejay..."
cd $LINEAGE_DIR/device/google/bluejay
git apply $ZUHD_DIR/patches/tasarruf_bluejay.patch

# 6. Inject Boot Animation
echo "Injecting Boot Animation..."
cp $ZUHD_DIR/assets/bootanimation.zip $LINEAGE_DIR/device/google/bluejay/bootanimation.zip

echo "ZuhdOS Injection Complete. The system is ready for compilation."
