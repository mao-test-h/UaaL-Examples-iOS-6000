using System.Linq;
using UnityEditor;
using UnityEditor.Build.Reporting;
using UnityEngine;
using UnityEngine.Windows;

namespace _Example.Editor
{
    internal static class BuildScript
    {
        /// <summary>
        /// iOSビルドの実行(Device/Simulator)
        /// </summary>
        [MenuItem("Build/Build for Device")]
        public static void BuildForDevice()
        {
            BuildIOSInternal(iOSSdkVersion.DeviceSDK);
        }

        [MenuItem("Build/Build for Simulator")]
        public static void BuildForSimulator()
        {
            BuildIOSInternal(iOSSdkVersion.SimulatorSDK);
        }

        [MenuItem("Build/Build for Both")]
        private static void BuildForBoth()
        {
            BuildIOSInternal(iOSSdkVersion.DeviceSDK);
            BuildIOSInternal(iOSSdkVersion.SimulatorSDK);
        }

        private static void BuildIOSInternal(iOSSdkVersion sdkVersion)
        {
            // NOTE: 一応 Universal で検証するが、x86-64 が不要な場合には arm64 固定でも良いかも
            PlayerSettings.iOS.simulatorSdkArchitecture = AppleMobileArchitectureSimulator.Universal;

            var currentSdkVersion = PlayerSettings.iOS.sdkVersion;
            PlayerSettings.iOS.sdkVersion = sdkVersion;

            try
            {
                // `./Builds`フォルダのチェック
                var buildsPath = Application.dataPath + "/../Builds/";
                CheckAndCreateDirectory(buildsPath, deleteIfExists: false);

                // このサンプルでは既存のビルドを破棄してReplace相当の処理を行うようにする
                var buildPath = buildsPath + sdkVersion;
                CheckAndCreateDirectory(buildPath, deleteIfExists: true);

                var buildOptions = new BuildPlayerOptions
                {
                    scenes = EditorBuildSettings.scenes.Select(scene => scene.path).ToArray(),
                    target = BuildTarget.iOS,
                    locationPathName = buildPath,
                    options = BuildOptions.None,
                };

                var result = BuildPipeline.BuildPlayer(buildOptions);
                if (result.summary.result != BuildResult.Succeeded)
                {
                    Debug.LogError($"Build Failed : {sdkVersion.ToString()}");
                    return;
                }

                Debug.Log($"Build Successful : {sdkVersion.ToString()}");
            }
            finally
            {
                // NOTE: これを変えるとビルドする度にPlayerSettingsが更新されて差分が発生するので、終わったら元の値に戻すようにしておく
                PlayerSettings.iOS.sdkVersion = currentSdkVersion;
                AssetDatabase.Refresh();
                AssetDatabase.SaveAssets();
            }
        }


        private static void CheckAndCreateDirectory(string path, bool deleteIfExists)
        {
            if (deleteIfExists && Directory.Exists(path))
            {
                Directory.Delete(path);
            }

            Directory.CreateDirectory(path);
        }
    }
}
