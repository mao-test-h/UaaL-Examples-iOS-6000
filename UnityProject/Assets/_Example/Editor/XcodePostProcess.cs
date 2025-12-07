using System.IO;
using UnityEditor;
using UnityEditor.Callbacks;
using UnityEditor.iOS.Xcode;

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
    }
}
