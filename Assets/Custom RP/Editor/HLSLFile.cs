using UnityEditor;

public class HLSLFile
{
    static readonly string hlslTemplateGUID = "29cb7a8dda552af4b8954956c107d4e5";
    static readonly string defaultNewHLSLName = "NewHLSL.hlsl";

    [MenuItem("Assets/Create/Shader/HLSL")]
    static void Create()
    {
        //var assetPath = AssetDatabase.GetAssetPath(Selection.activeObject);
        //var dataPath = Application.dataPath.Replace("Assets", "");
        //var FileName = "NewHLSL.hlsl";
        //var assetName = assetPath + "/" + FileName;
        //var fullPath = dataPath + assetName;

        //for (int i = 1; File.Exists(fullPath); i++)
        //{
        //    var newFileName = "NewHLSL " + i.ToString() + ".hlsl";
        //    assetName = assetPath + "/" + newFileName;
        //    fullPath = dataPath + assetName;
        //}

        //File.WriteAllText(fullPath, "", Encoding.UTF8);

        //AssetDatabase.Refresh();

        //var asset = AssetDatabase.LoadAssetAtPath(assetName, typeof(object));
        //Selection.activeObject = asset;

        string templatePath = AssetDatabase.GUIDToAssetPath(hlslTemplateGUID);
        ProjectWindowUtil.CreateScriptAssetFromTemplateFile(templatePath, defaultNewHLSLName);
    }
}
