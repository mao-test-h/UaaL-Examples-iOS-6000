# UnityからビルドしたiOSの実機&シミュレーター向けのビルドから`.xcframework`のビルドを行う
# 参考: https://qiita.com/tfactory/items/34f9d88f014c47221617

# UnityEditorのパス
UNITY_EDITOR_PATH := /Applications/Unity/Hub/Editor/6000.3.0f1/Unity.app/Contents/MacOS/Unity

# プロジェクトのパス
PROJECT_ROOT := $(shell pwd)
UNITY_PROJECT_PATH := $(PROJECT_ROOT)/UnityProject
UNITY_OUTPUT_PATH := $(UNITY_PROJECT_PATH)/Builds
XCODE_PROJECT_PATH := $(PROJECT_ROOT)/XcodeProject

# ビルド結果のパス
DEVICE_BUILD_PATH := $(UNITY_OUTPUT_PATH)/DeviceSDK/Unity-iPhone.xcodeproj
SIMULATOR_BUILD_PATH := $(UNITY_OUTPUT_PATH)/SimulatorSDK/Unity-iPhone.xcodeproj
DEVICE_ARCHIVE_PATH := $(UNITY_OUTPUT_PATH)/UnityFramework-Device.xcarchive
SIMULATOR_ARCHIVE_PATH := $(UNITY_OUTPUT_PATH)/UnityFramework-Simulator.xcarchive
XCFRAMEWORK_PATH := $(UNITY_OUTPUT_PATH)/UnityFramework.xcframework

.PHONY: all clean \
        unity-build unity-build-device unity-build-simulator \
        archive archive-device archive-simulator \
        xcframework fix-swiftinterface cleanup-swiftinterface deploy \
        help

# メインターゲット

all: unity-build archive xcframework fix-swiftinterface cleanup-swiftinterface deploy
	@echo "All steps completed successfully!"

clean:
	@echo "Cleaning build artifacts..."
	rm -rf $(UNITY_OUTPUT_PATH)/DeviceSDK
	rm -rf $(UNITY_OUTPUT_PATH)/SimulatorSDK
	rm -rf $(DEVICE_ARCHIVE_PATH)
	rm -rf $(SIMULATOR_ARCHIVE_PATH)
	rm -rf $(XCFRAMEWORK_PATH)
	rm -rf $(XCODE_PROJECT_PATH)/UnityFramework.xcframework
	@echo "Clean completed!"

# unity-build: Unity の iOS ビルドを実行して実機/シミュレーター向けの `Unity-iPhone.xcodeproj` を生成

unity-build: unity-build-device unity-build-simulator
	@osascript -e 'display notification "Success Build UnityProject" sound name "Bip"' 2>/dev/null || true
	@echo "Unity build completed: iOS projects generated"

unity-build-device:
	@echo "Building Unity for Device SDK..."
	$(UNITY_EDITOR_PATH) -batchmode \
		-nographics \
		-silent-crashes \
		-quit \
		-buildTarget iOS \
		-projectPath $(UNITY_PROJECT_PATH) \
		-executeMethod _Example.Editor.BuildScript.BuildForDevice
	@if [ ! -d "$(DEVICE_BUILD_PATH)" ]; then \
		echo "Error: iOS実機向けのビルドが存在しない"; \
		exit 1; \
	fi

unity-build-simulator:
	@echo "Building Unity for Simulator SDK..."
	$(UNITY_EDITOR_PATH) -batchmode \
		-nographics \
		-silent-crashes \
		-quit \
		-buildTarget iOS \
		-projectPath $(UNITY_PROJECT_PATH) \
		-executeMethod _Example.Editor.BuildScript.BuildForSimulator
	@if [ ! -d "$(SIMULATOR_BUILD_PATH)" ]; then \
		echo "Error: iOSシミュレーター向けのビルドが存在しない"; \
		exit 1; \
	fi

# archive: ビルドした `.xcodeproj` から `.xcarchive` をビルド

archive:
	@$(MAKE) -j2 archive-device archive-simulator
	@echo "Archive completed: xcarchives created"

archive-device:
	@echo "Creating Device archive..."
	@rm -rf $(DEVICE_ARCHIVE_PATH)
	xcodebuild archive \
		-project "$(DEVICE_BUILD_PATH)" \
		-scheme "UnityFramework" \
		-destination="iOS" \
		-archivePath "$(DEVICE_ARCHIVE_PATH)" \
		-sdk iphoneos \
		SKIP_INSTALL=NO \
		BUILD_LIBRARY_FOR_DISTRIBUTION=YES
	@osascript -e 'display notification "Success Build UnityFramework-Device.xcarchive" sound name "Bip"' 2>/dev/null || true

archive-simulator:
	@echo "Creating Simulator archive..."
	@rm -rf $(SIMULATOR_ARCHIVE_PATH)
	xcodebuild archive \
		-project "$(SIMULATOR_BUILD_PATH)" \
		-scheme "UnityFramework" \
		-destination="iOS Simulator" \
		-archivePath "$(SIMULATOR_ARCHIVE_PATH)" \
		-sdk iphonesimulator \
		SKIP_INSTALL=NO \
		BUILD_LIBRARY_FOR_DISTRIBUTION=YES
	@osascript -e 'display notification "Success Build UnityFramework-Simulator.xcarchive" sound name "Bip"' 2>/dev/null || true

# xcframework: `.xcarchive` から `.xcframework` をビルド

xcframework:
	@echo "Creating XCFramework..."
	@rm -rf $(XCFRAMEWORK_PATH)
	xcodebuild -create-xcframework \
		-framework "$(DEVICE_ARCHIVE_PATH)/Products/Library/Frameworks/UnityFramework.framework" \
		-framework "$(SIMULATOR_ARCHIVE_PATH)/Products/Library/Frameworks/UnityFramework.framework" \
		-output $(XCFRAMEWORK_PATH)
	@osascript -e 'display notification "Success Build UnityFramework.xcframework" sound name "Bip"' 2>/dev/null || true
	@echo "XCFramework created"

# fix-swiftinterface: `.swiftinterface` の修正
# - `BUILD_LIBRARY_FOR_DISTRIBUTION` を有効にしている都合で発生するエラーの対策
# - 参考: https://developer.apple.com/forums/thread/123253

fix-swiftinterface:
	@echo "Fixing .swiftinterface files..."
	@cd $(XCFRAMEWORK_PATH) && \
		find . -name "*.swiftinterface" -exec sed -i '' 's/UnityFramework\.//g' {} \;
	@osascript -e 'display notification "Fix .swiftinterface in xcframework" sound name "Bip"' 2>/dev/null || true
	@echo "swiftinterface fixed"

# cleanup-swiftinterface: 不要ファイルの削除

cleanup-swiftinterface:
	@echo "Cleaning up temporary files..."
	@cd $(XCFRAMEWORK_PATH) && \
		find . -name "*.swiftinterface-e" -exec rm -f {} \; 2>/dev/null || true
	@osascript -e 'display notification "Cleanup completed" sound name "Bip"' 2>/dev/null || true
	@echo "Cleanup done"

# deploy: XcodeProject に `.xcframework` を配置

deploy:
	@echo "Deploying XCFramework to Xcode project..."
	@rm -rf $(XCODE_PROJECT_PATH)/UnityFramework.xcframework
	@cp -R $(XCFRAMEWORK_PATH) $(XCODE_PROJECT_PATH)/
	@osascript -e 'display notification "XCFramework deployed to Xcode project" sound name "Bip"' 2>/dev/null || true
	@echo "XCFramework deployed to $(XCODE_PROJECT_PATH)"

# =============================================================================
# ヘルプ
# =============================================================================

help:
	@echo "Usage: make [target]"
	@echo ""
	@echo "Targets:"
	@echo "  all                  - Run all steps (default)"
	@echo "  clean                - Remove all build artifacts"
	@echo ""
	@echo "  unity-build          - Unity iOS build (Device & Simulator)"
	@echo "  unity-build-device   - Unity iOS build (Device only)"
	@echo "  unity-build-simulator- Unity iOS build (Simulator only)"
	@echo ""
	@echo "  archive              - Create xcarchives (Device & Simulator)"
	@echo "  archive-device       - Create Device xcarchive"
	@echo "  archive-simulator    - Create Simulator xcarchive"
	@echo ""
	@echo "  xcframework          - Create XCFramework from archives"
	@echo "  fix-swiftinterface   - Fix .swiftinterface module prefix issue"
	@echo "  cleanup-swiftinterface              - Remove temporary files"
	@echo "  deploy               - Deploy XCFramework to Xcode project"
	@echo ""
	@echo "  help                 - Show this help message"
