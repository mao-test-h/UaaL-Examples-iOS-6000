# UaaL-Examples-iOS-6000

![Unity](https://img.shields.io/badge/Unity-6000.3.0b10-blue)
![Xcode](https://img.shields.io/badge/Xcode-26.1.1-blue)
![Platform](https://img.shields.io/badge/platform-iOS-lightgrey)
![License](https://img.shields.io/badge/license-MIT-green)

**English** | [日本語](README-JP.md)

## Overview

This is a verification project for generating and integrating XCFramework from `UnityFramework.framework` for device/simulator in Unity as a Library (UaaL) for iOS.

In the past, I prepared the following article and verification project for Intel Mac (x86-64), but this project includes **support for Unity 6.3** and **support for arm64-simulator**.

- [Unity as a LibraryをXCFramework化してiOSの実機とシミュレーターの両方で動かせるようにする](https://qiita.com/mao_/items/9874c1efa280ed4bb399) (Japanese)
- https://github.com/mao-test-h/UaaL-Examples-iOS

> [!caution]
> There may be issues with normal operation as workarounds are currently in place to run on 6000.0.3f1.
> This will be updated once Unity addresses these issues.

https://github.com/user-attachments/assets/94a63b90-4ffd-447c-a8f9-c2518b625cc1

### Environment

- Unity 6000.3.0f1+
- Xcode 26.1.1+

## Quick Start

Running the following command will perform everything from Unity build to XCFramework generation and deployment.
Once completed, open the Xcode project under `./XcodeProject` and run it.

```bash
make all
```

## Project Structure

>[!caution]
> Please note that `./XcodeProject/UaaLExample-SwiftUI` is currently not working properly.

```
.
├── UnityProject/                      # Unity project
│   ├── Assets/_Example/               # Sample implementation
│   │   ├── Editor/                    # BuildScript (Device/Simulator)
│   │   ├── Plugins/iOS/               # NativeCallProxy.swift (P/Invoke)
│   │   ├── Runtime/                   # C# code (UIToolkit)
│   │   └── Scenes/                    # SampleScene.unity
│   └── Builds/                        # Build output
│
├── XcodeProject/
│   ├── UaaLExample-SwiftUI/           # SwiftUI sample
│   ├── UaaLExample-UIKit/             # UIKit sample
│   └── UnityFramework.xcframework/    # Deployed XCFramework
│
├── Documents/
│   └── Unity-iOS-Plugin-Patterns.md   # Native plugin guide
│
└── Makefile                           # Automated build script
```
