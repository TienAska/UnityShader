using UnityEngine;

[DisallowMultipleComponent]
public class PerObjectMaterialProperties : MonoBehaviour
{
    static int
        baseColorID = Shader.PropertyToID("_BaseColor"),
        cutoffID = Shader.PropertyToID("_Cutoff"),
        metallicID = Shader.PropertyToID("_Metallic"),
        smoothnessID = Shader.PropertyToID("_Smoothness"),
        emissionID = Shader.PropertyToID("_EmissionColor");

    static MaterialPropertyBlock block;

    [SerializeField]
    Color baseColor = Color.white;

    [SerializeField, Range(0f, 1f)]
    float alphaCutoff = 0.5f, metallic = 0f, smoothness = 0.5f;

    [SerializeField, ColorUsage(false, true)]
    Color emissionColor = Color.black;

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
        block.SetFloat(cutoffID, alphaCutoff);
        block.SetFloat(metallicID, metallic);
        block.SetFloat(smoothnessID, smoothness);
        block.SetColor(emissionID, emissionColor);
        GetComponent<MeshRenderer>().SetPropertyBlock(block);
    }

    public void SetColor(Color color)
    {
        baseColor = color;
        OnValidate();
    }
}
