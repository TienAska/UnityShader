using UnityEditor;

public class HLSLFile
{
    static readonly string hlslTemplateGUID = "29cb7a8dda552af4b8954956c107d4e5";
    static readonly string defaultNewHLSLName = "NewHLSL.hlsl";

    [MenuItem("Assets/Create/Shader/HLSL")]
    static void Create()
    {
        string templatePath = AssetDatabase.GUIDToAssetPath(hlslTemplateGUID);
        ProjectWindowUtil.CreateScriptAssetFromTemplateFile(templatePath, defaultNewHLSLName);
    }
}
