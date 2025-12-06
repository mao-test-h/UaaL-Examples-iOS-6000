# UaaL-Examples-iOS-6000

![Unity](https://img.shields.io/badge/Unity-6000.3.0b10-blue)
![Xcode](https://img.shields.io/badge/Xcode-26.1.1-blue)
![Platform](https://img.shields.io/badge/platform-iOS-lightgrey)
![License](https://img.shields.io/badge/license-MIT-green)

[English](README.md) | **日本語**

## 概要

iOS 向けの Unity as a Library (UaaL) にて、実機 / シミュレーター向けの `UnityFramework.framework` から XCFramework を生成して組み込むための検証プロジェクトです。

過去に Intel Mac (x86-64) 向けに以下の記事及び検証プロジェクトを用意しましたが、こちらのプロジェクトでは新たに **Unity 6.3 向けの対応** と **arm64-simulator でも動かせるようにした対応** を入れてます。

- [Unity as a LibraryをXCFramework化してiOSの実機とシミュレーターの両方で動かせるようにする](https://qiita.com/mao_/items/9874c1efa280ed4bb399)
- https://github.com/mao-test-h/UaaL-Examples-iOS

<!-- TODO: スクリーンショットを追加 -->

### 動作環境

- Unity 6000.3.0f1+
- Xcode 26.1.1+

## クイックスタート

以下のコマンドを実行することで Unity のビルドから XCFramework の生成、配置まで一通り行えます。  
完了したら `./XcodeProject` 以下にある Xcodeプロジェクトを開いて実行してください。

```bash
make all
```

## プロジェクト構造

>[!caution]  
> 現在 `./XcodeProject/UaaLExample-SwiftUI` は正常に動作しないので注意。

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
