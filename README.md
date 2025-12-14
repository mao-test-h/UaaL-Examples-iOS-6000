# UaaL-Examples-iOS-6000

![Unity](https://img.shields.io/badge/Unity-6000.3.0b10-blue)
![Xcode](https://img.shields.io/badge/Xcode-26.1.1-blue)
![Platform](https://img.shields.io/badge/platform-iOS-lightgrey)
![License](https://img.shields.io/badge/license-MIT-green)

**English** | [日本語](README-JP.md)

> [!tip]
> I wrote an article about this sample project (in Japanese).
> - [【Unity6.3対応版】Unity as a Library で UnityFramework を XCFramework 化して iOS 実機とシミュレーターの両方で動かせるようにする](https://qiita.com/mao_/items/4da81d6b57ea1a0fe382)

## Overview

This is a sample project for generating and integrating XCFramework from `UnityFramework.framework` for device/simulator in Unity as a Library (UaaL) for iOS.

In the past, I prepared the following article and sample project for Intel Mac (x86-64), but this project includes **support for Unity 6.3** and **support for arm64-simulator**.

- [Unity as a LibraryをXCFramework化してiOSの実機とシミュレーターの両方で動かせるようにする](https://qiita.com/mao_/items/9874c1efa280ed4bb399) (Japanese)
- https://github.com/mao-test-h/UaaL-Examples-iOS

> [!warning]
> As a known issue, enabling `Show Splash Screen` when integrating as UaaL may cause it to not work properly.
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
