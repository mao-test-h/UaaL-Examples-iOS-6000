using System.IO;
using NUnit.Framework;
using UnityEditor;
using UnityEditor.Callbacks;
using UnityEditor.iOS.Xcode;
using UnityEngine;

namespace _Example.Editor
{
    internal static class XcodePostProcess
    {
        // 参考: https://tech.mirrativ.stream/entry/2020/10/20/100000
        [PostProcessBuild]
        private static void OnPostProcessBuild(BuildTarget target, string path)
        {
            if (target != BuildTarget.iOS)
            {
                return;
            }

            var projectPath = PBXProject.GetPBXProjectPath(path);
            var project = new PBXProject();
            project.ReadFromString(File.ReadAllText(projectPath));

            SetUnityAsALibrary(project);
            ApplyMetalDisplayLinkWorkaround(path);

            project.WriteToFile(projectPath);
        }

        private static void SetUnityAsALibrary(PBXProject project)
        {
            // `Data`フォルダを[Build Phase -> Copy Bundle Resources]に追加
            var targetGuid = project.GetUnityFrameworkTargetGuid();
            var dataPathGuid = project.FindFileGuidByProjectPath("Data");
            var resPhaseGuid = project.GetResourcesBuildPhaseByTarget(targetGuid);
            project.AddFileToBuildSection(targetGuid, resPhaseGuid, dataPathGuid);
        }

        /// <summary>
        /// Unity 6000.3.0f1 の Metal DisplayLink GPU Timeout エラーのワークアラウンドを適用
        /// </summary>
        /// <param name="buildPath">iOS ビルド出力のパス</param>
        private static void ApplyMetalDisplayLinkWorkaround(string buildPath)
        {
#if UNITY_6000_3_0
            // Metal DisplayLink ワークアラウンド用の定数
            // TODO: Unity が GPU Timeout エラーを修正したら削除可能（対象: Unity 6000.3.0f1）
            const string metalDisplayLinkPattern =
                "        // We get GPU Timeout errors when enabling the CAMetalDisplayLink.\n" +
                "        // Therefore it is disabled until a fix is found.\n" +
                "        return NO;";

            const string metalDisplayLinkReplacement =
                "        // We get GPU Timeout errors when enabling the CAMetalDisplayLink.\n" +
                "        // Therefore it is disabled until a fix is found.\n" +
                "        return YES;";

            var unityAppControllerPath = Path.Combine(buildPath, "Classes", "UnityAppController.mm");
            Assert.IsTrue(File.Exists(unityAppControllerPath), $"[XcodePostProcess] UnityAppController.mm が見つかりません: {unityAppControllerPath}");

            var content = File.ReadAllText(unityAppControllerPath);
            if (!content.Contains(metalDisplayLinkPattern))
            {
                if (content.Contains(metalDisplayLinkReplacement))
                {
                    Debug.Log("[XcodePostProcess] Metal DisplayLink ワークアラウンドは既に適用済みです。");
                }
                else
                {
                    Debug.LogWarning("[XcodePostProcess] Metal DisplayLink のパターンが見つかりません。Unity のバージョンが変更された可能性があります。");
                }

                return;
            }

            var modifiedContent = content.Replace(metalDisplayLinkPattern, metalDisplayLinkReplacement);
            if (modifiedContent == content)
            {
                Debug.LogWarning("[XcodePostProcess] Metal DisplayLink ワークアラウンドの置換に失敗しました。");
                return;
            }

            File.WriteAllText(unityAppControllerPath, modifiedContent);
            Debug.Log("[XcodePostProcess] Metal DisplayLink ワークアラウンドを適用しました。");
#endif
        }
    }
}
