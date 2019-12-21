using UnityEditor;
using UnityEngine;

public class RandomColor
{
    [MenuItem("GameObject/SetRandomColor")]
    static void SetRandomColor()
    {
        foreach (GameObject so in Selection.objects)
        {
            if (so != null)
            {
                so.GetComponent<MeshRenderer>().sharedMaterial.SetColor("_BaseColor", Random.ColorHSV());
            }
        }
    }
}
