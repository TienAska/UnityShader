using UnityEngine;

[DisallowMultipleComponent]
public class PerObjectMaterialProperties : MonoBehaviour
{
    static int baseColorID = Shader.PropertyToID("_BaseColor");
    static int cutoffID = Shader.PropertyToID("_Cutoff");

    static MaterialPropertyBlock block;

    [SerializeField]
    Color baseColor = Color.white;

    [SerializeField, Range(0f, 1f)]
    float cutoff = 0.5f;

    private void Awake()
    {
        OnValidate();
    }

    private void OnValidate()
    {
        if (block == null)
        {
            block = new MaterialPropertyBlock();
        }
        block.SetColor(baseColorID, baseColor);
        block.SetFloat(cutoffID, cutoff);
        GetComponent<MeshRenderer>().SetPropertyBlock(block);
    }

    public void SetColor(Color color)
    {
        baseColor = color;
        OnValidate();
    }
}
