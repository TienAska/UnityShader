using UnityEditor;
using UnityEngine;
using System.IO;
using System.Text;

public class CreateCustomFile
{
    [MenuItem("Assets/Create/Shader/HLSL")]
    static void CreateHLSLFile()
    {
        CreateFile("HLSL");
    }

    static void CreateFile(string fileEx)
    {
        var assetPath = AssetDatabase.GetAssetPath(Selection.activeObject);
        var dataPath = Application.dataPath.Replace("Assets", "");
        var FileName = "new" + fileEx + "." + fileEx.ToLower();
        var assetName = assetPath + "/" + FileName;
        var fullPath = dataPath + assetName;

        for (int i = 1; File.Exists(fullPath); i++)
        {
            var newFileName = "new" + fileEx + i.ToString() + "." + fileEx.ToLower();
            assetName = assetPath + "/" + newFileName;
            fullPath = dataPath + assetName;
        }

        File.WriteAllText(fullPath, "", Encoding.UTF8);

        AssetDatabase.Refresh();

        var asset = AssetDatabase.LoadAssetAtPath(assetName, typeof(object));
        Selection.activeObject = asset;
    }
}
