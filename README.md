# UaaL-Examples-iOS-6000

![Unity](https://img.shields.io/badge/Unity-6000.3.0b10-blue)
![Xcode](https://img.shields.io/badge/Xcode-26.1.1-blue)
![Platform](https://img.shields.io/badge/platform-iOS-lightgrey)
![License](https://img.shields.io/badge/license-MIT-green)

**English** | [日本語](README-JP.md)

### Overview

Unity as a Library (UaaL) implementation example for iOS with **XCFramework support** and **Device/Simulator universal framework**.

This project demonstrates how to integrate Unity 6000.3 into native iOS apps (SwiftUI & UIKit) with Device/Simulator universal framework support and bidirectional communication between Unity and native code via P/Invoke.

Perfect for developers who want to embed Unity content in existing iOS applications.

### Key Features

- ✅ **XCFramework Support**: Device & Simulator universal framework
- ✅ **Automated Build**: One-command build pipeline with Makefile
- ✅ **Dual UI Samples**: SwiftUI and UIKit integration patterns
- ✅ **Bidirectional Communication**: Unity ↔ Native via P/Invoke
- ✅ **UIToolkit**: Modern Unity UI implementation
- ✅ **Comprehensive Docs**: Native plugin implementation patterns

### Screenshots

<!-- TODO: Add screenshots -->
<!-- SwiftUI and UIKit sample app screenshots will be added here -->

### Quick Start

**Option 1: Run Pre-built Sample**

```bash
# Clone repository
git clone https://github.com/mao-test-h/UaaL-Examples-iOS-6000.git
cd UaaL-Examples-iOS-6000

# Open Xcode project (pre-built XCFramework included)
open XcodeProject/UaaLExample-SwiftUI/UaaLExample.xcodeproj

# Run on simulator or device
```

**Option 2: Build from Unity**

```bash
# Full build pipeline
make all

# Or step by step
make unity-build   # Unity build for Device & Simulator
make xcframework   # Generate XCFramework
make deploy        # Deploy to Xcode projects
```

### Project Structure

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

### Documentation

- **[Unity iOS Plugin Patterns](Documents/Unity-iOS-Plugin-Patterns.md)** - Comprehensive guide for implementing native plugins with P/Invoke
- **[CLAUDE.md](CLAUDE.md)** - Project structure and development workflow

### Requirements

- macOS (Apple Silicon or Intel)
- Unity 6000.3.0b10 or later
- Xcode 26.1.1 or later
- Command Line Tools for Xcode

### License

MIT License - See [LICENSE](LICENSE) for details
