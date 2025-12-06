# UaaL-Examples-iOS-6000

![Unity](https://img.shields.io/badge/Unity-6000.3.0b10-blue)
![Xcode](https://img.shields.io/badge/Xcode-26.1.1-blue)
![Platform](https://img.shields.io/badge/platform-iOS-lightgrey)
![License](https://img.shields.io/badge/license-MIT-green)

[English](README.md) | **日本語**

## 概要

iOS 向けの **Unity as a Library (UaaL)** 実装例です。**XCFramework 対応**と **Device/Simulator ユニバーサルフレームワーク**に対応しています。

本プロジェクトでは、Unity 6000.3 をネイティブ iOS アプリ (SwiftUI & UIKit) に組み込む方法、Device/Simulator 両対応のユニバーサルフレームワーク、P/Invoke を使った Unity とネイティブコード間の双方向通信を実証します。

既存の iOS アプリケーションに Unity コンテンツを埋め込みたい開発者に最適です。

## 主な機能

- ✅ **XCFramework 対応**: Device & Simulator 両対応のユニバーサルフレームワーク
- ✅ **自動ビルド**: Makefile による1コマンドビルドパイプライン
- ✅ **2種類の UI サンプル**: SwiftUI と UIKit の統合パターン
- ✅ **双方向通信**: P/Invoke による Unity ↔ Native 間通信
- ✅ **UIToolkit**: モダンな Unity UI 実装
- ✅ **充実したドキュメント**: ネイティブプラグイン実装パターン

## スクリーンショット

<!-- TODO: スクリーンショットを追加 -->
<!-- SwiftUI版とUIKit版のサンプルアプリのスクリーンショットをここに追加予定 -->

## クイックスタート

**方法1: ビルド済みサンプルを実行**

```bash
# リポジトリをクローン
git clone https://github.com/mao-test-h/UaaL-Examples-iOS-6000.git
cd UaaL-Examples-iOS-6000

# Xcode プロジェクトを開く (XCFramework は同梱済み)
open XcodeProject/UaaLExample-SwiftUI/UaaLExample.xcodeproj

# シミュレーターまたは実機で実行
```

**方法2: Unity からビルド**

```bash
# 完全なビルドパイプライン
make all

# または段階的に
make unity-build   # Unity ビルド (Device & Simulator)
make xcframework   # XCFramework 生成
make deploy        # Xcode プロジェクトへデプロイ
```

## プロジェクト構造

```
.
├── UnityProject/                      # Unity プロジェクト
│   ├── Assets/_Example/               # サンプル実装
│   │   ├── Editor/                    # BuildScript (Device/Simulator)
│   │   ├── Plugins/iOS/               # NativeCallProxy.swift (P/Invoke)
│   │   ├── Runtime/                   # C# コード (UIToolkit)
│   │   └── Scenes/                    # SampleScene.unity
│   └── Builds/                        # ビルド出力先
│
├── XcodeProject/
│   ├── UaaLExample-SwiftUI/           # SwiftUI サンプル
│   ├── UaaLExample-UIKit/             # UIKit サンプル
│   └── UnityFramework.xcframework/    # デプロイ済み XCFramework
│
├── Documents/
│   └── Unity-iOS-Plugin-Patterns.md   # ネイティブプラグインガイド
│
└── Makefile                           # 自動ビルドスクリプト
```

## ドキュメント

- **[Unity iOS プラグインパターン](Documents/Unity-iOS-Plugin-Patterns.md)** - P/Invoke を使ったネイティブプラグイン実装の包括的ガイド
- **[CLAUDE.md](CLAUDE.md)** - プロジェクト構造と開発ワークフロー

## 必要要件

- macOS (Apple Silicon または Intel)
- Unity 6000.3.0b10 以降
- Xcode 26.1.1 以降
- Command Line Tools for Xcode

## ライセンス

MIT License - 詳細は [LICENSE](LICENSE) を参照
