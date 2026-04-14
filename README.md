
ZuhdOS (Ascetic Edition)
========================

**Target Devices:** Pixel 6a (bluejay) | Pixel 7 Pro (cheetah)

**Base Architecture:** LineageOS 23 (Android 16)

I. Architectural Philosophy
---------------------------

ZuhdOS is a custom Android operating system engineered to dismantle the engagement-driven design of modern smartphones. It is built for absolute utility, cognitive preservation, and intentional detachment from high-fidelity media consumption.

By aggressively intervening at the lowest levels of the C++ graphics compositor (SurfaceFlinger) and the SELinux mandatory access control layer, the device is structurally restricted from rendering smooth gradients, vibrant colors, or hardware-accelerated video.

### Core Modifications

*   **Brutalist E-Ink SkSL Pipeline:** A computationally lightweight, chromatic dithering algorithm injected directly into the Skia RenderEngine. It crushes the display output into a 3-shade posterized palette (Navy Ink on Dull Paper) overlaid with a static visual texture.
    
*   **Compositor Override:** The Hardware Composer (HWC) is permanently disabled. This hardcoded rule in the SurfaceFlinger.cpp render loop bypasses all proprietary vendor optimizations that prioritize media performance.
    
*   **Persistent SELinux Enforcement:** The filter's state is bound to a highly privileged, persistent custom SELinux domain (eink\_filter\_prop), ensuring the structural limits survive device reboots.
    
*   **System Identity:** A custom, uncompressed boot animation and a hardcoded XML status bar stamp establish the OS's utilitarian intent at a system level.
    

II. Repository Structure (The Patcher)
--------------------------------------

This repository does not host the entire 200GB+ Android source tree. It acts as a lightweight injection mechanism. It contains the exact mathematical deltas (patch files) and assets needed to transmute a standard LineageOS codebase into ZuhdOS. All future updates will be added or updated as patches here unless need for a more comprehensive repository with source files arises.

```
ZuhdOS/
├── README.md
├── assets/
│   └── bootanimation.zip
├── patches/
│   ├── tasarruf_native.patch
│   ├── tasarruf_settings.patch
│   ├── tasarruf_sepolicy.patch
│   └── tasarruf_device.patch
└── scripts/
    └── apply_zuhd.sh
```

III. Build Environment & Source Sync
------------------------------------

Before applying the ZuhdOS architecture, you must initialize and download the foundational LineageOS 23 source tree.
The below instructions for initializing LineageOS are demonstrative, please go to lineage wiki for more detailed instructions
(e.g here are instructions for Pixel 6a ([bluejay](https://wiki.lineageos.org/devices/bluejay/build/)))

**1\. Initialize the repository:**

```  
mkdir -p ~/android/lineage  cd ~/android/lineage  repo init -u https://github.com/LineageOS/android.git -b lineage-23.0
```

**2\. Sync the source tree:**

```
repo sync -c -j$(nproc --all) --force-sync --no-clone-bundle --no-tags   
```

IV. Injecting the Architecture
------------------------------

Once the LineageOS tree is synced, clone this repository outside of the source tree and run the installer script to apply the C++, Java, XML, and SELinux modifications.

**1\. Clone the ZuhdOS repository:**

```
cd ~  git clone https://github.com/zeno22/ZuhdOS.git   
```

**2\. Execute the injection script:**

Note: A part of this script includes updates to a specific device (bluejay). Please update the script to reflect your own device tree.
```
cd ~/android/lineage  ../ZuhdOS/scripts/apply_zuhd.sh   
```

_This script will automatically patch SurfaceFlinger, Settings, SystemUI, sepolicy, and copy the boot animation into the correct device tree._

V. Compilation
--------------

Initialize the build environment using relaxed compilation flags. This ensures our custom prebuilts (like the standalone WebView) and SELinux domain shifts compile without strict vendor-enforcement halting the process.

**1\. Prepare the environment and select the target:**

```
source build/envsetup.sh  breakfast bluejay  # Replace 'bluejay' with 'cheetah' for Pixel 7 Pro   
```

**2\. Export relaxed compilation flags:**
```
 export RELAX_USES_LIBRARY_CHECK=true  export ALLOW_MISSING_DEPENDENCIES=true
```

**3\. Execute the build:**

```
brunch bluejay -j6
```

_The above example runs the build for Pixel 6a ( bluejay) forcing six cores to compile the source._

_Upon success, the cryptographic zip will be located at: out/target/product//lineage-23.0-XXXX-UNOFFICIAL-.zip_

VI. Installation Sequence
-------------------------

This sequence requires the compiled ROM ZIP and the specific MindTheGapps package for ARM64.

_Download GApps here:_ [MindTheGapps-16.0.0-arm64-20260409\_073023.zip](https://www.google.com/search?q=https://github.com/MindTheGapps/16.0.0-arm64/releases/download/MindTheGapps-16.0.0-arm64-20260409_073023/MindTheGapps-16.0.0-arm64-20260409_073023.zip)

**1\. Boot into Recovery and Format Data:**

Connect your phone, reboot to the bootloader, and select Recovery Mode. (Note: This assumes that the bootloader is unlocked and Lineage or TWRP recovery is already setup)

```
adb reboot recovery
```

*   Navigate to **Factory Reset** -> **Format data / factory reset**.
    

**2\. Flash the Base OS:**

*   Navigate to **Apply Update** -> **Apply from ADB**.
    

```
adb sideload out/target/product/bluejay/lineage-23.0-XXXX-UNOFFICIAL-bluejay.zip
```

**3\. Reboot to Recovery (Crucial Step):**

Do **not** boot into the operating system yet. You must reboot recovery to swap the active slot.

*   Navigate to **Advanced** -> **Reboot to Recovery**.
    

**4\. Sideload Google Apps:**

*   Navigate back to **Apply Update** -> **Apply from ADB**.
    

```
adb sideload path/to/MindTheGapps-16.0.0-arm64-20260409_073023.zip
```

**5\. Initial Boot:**

*   Navigate to **Reboot system now**. Complete the standard Android setup wizard.
    

VII. Post-Install Hardening (The Final Limits)
----------------------------------------------

Once the OS is configured, you must establish the final structural limits via ADB. The default rendering resolution of modern displays undermines the brutalist aesthetic. We will degrade the resolution, inject the WebView, and permanently lock down the developer environment.

Enable USB Debugging in Developer Options, connect to your workstation, and execute the following:

**1\. Gain Root Access (if on userdebug) or execute as shell:**

```
adb root   
```

**2\. Spatial & Density Degradation:**

Scale the display to a 540x1200 resolution to enhance the stippled texture of the chromatic dither and drastically reduce GPU processing load.

```
adb shell wm size 540x1200  adb shell wm density 280
```

**3\. Manual WebView Injection:**

Install the prebuilt ARM64 Chromium WebView to ensure system applications render HTML correctly, independent of the Google Play Store update mechanism.

```
adb install -r -d external/chromium-webview/prebuilt/arm64/webview.apk
```

**4\. Locking the Boundary:**

Because the E-Ink filter relies on underlying property states, leaving the Developer Options menu accessible provides an easy bypass to the system's core constraints. Annihilate access to the menu to secure the architecture.

```
adb shell settings put global development_settings_enabled 0
```

_Note: This strictly disables the UI menu within the Settings app. ADB access will remain active globally as long as your workstation's RSA key remains authorized on the device._
