# CLAUDE.md

## プロジェクト概要

こちらは iOS 向けの UaaL (Unity as a Library) を検証するためのプロジェクトです。

- UnityFramework.framework (Unity の iOS ビルドで出力されるフレームワーク) の XCFramework 対応
- UaaL 環境でのプラグイン呼び出し

### 開発環境

- Unity 6000.3.0f1
  - UITookKit
- JetBrains Rider
- VSCode
- Xcode 26.1.1

### プロジェクト構造

```
.
├── UnityProject                                    # Unity プロジェクト
│   ├── Assets
│   │   └── _Example                                # サンプル一式
│   │       ├── Editor                              # エディタ拡張 (.cs, .asmdef)
│   │       ├── Plugins                             # ネイティブプラグイン (.swift, .mm)
│   │       ├── Runtime                             # ランタイムコード (.cs, .asmdef)
│   │       ├── Scenes                              # シーンファイル
│   │       └── Settings                            # 各種設定ファイル
│   ├── Builds                                      # ビルド結果の置き場
│   └── *
└── XcodeProject
    └── *                                           # iOS 向けのネイティブアプリプロジェクト (UaaLの組み込み先)
```

------------------------------

# ワークフロー

- 不明点がある場合には AskUserQuestion ツールで聞いてください

# ネイティブプラグイン開発

iOS のネイティブプラグインの実装方法については以下のドキュメントを参照すること。

- ./DocDocumentss/Unity-iOS-Plugin-Patterns.md

# UITooklit について

UIToolkit で View を作る際には以下のリンクを参照して、ベストプラクティスに沿った実装を行うこと。

- https://docs.unity3d.com/Documentation/Manual/UIE-best-practices-for-managing-elements.html
