using UnityEditor;
using UnityEngine;

public class RandomColor
{
    static PerObjectMaterialProperties perObjMatProperty;

    [MenuItem("GameObject/SetRandomColor")]
    static void SetRandomColor()
    {
        foreach (GameObject selectedObjs in Selection.gameObjects)
        {
            perObjMatProperty = selectedObjs.GetComponent<PerObjectMaterialProperties>();
            if (perObjMatProperty != null)
            {
                perObjMatProperty.SetColor(Random.ColorHSV(0f, 1f, 0f, 0.5f, valueMin: 0.8f, valueMax: 1f));
            }
        }
    }
}
