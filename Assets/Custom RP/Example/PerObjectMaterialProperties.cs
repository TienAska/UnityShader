using UnityEngine;

[DisallowMultipleComponent]
public class PerObjectMaterialProperties : MonoBehaviour
{
    static MaterialPropertyBlock block;
    static int baseColorID = Shader.PropertyToID("_BaseColor");

    [SerializeField]
    Color baseColor = Color.white;

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
        GetComponent<MeshRenderer>().SetPropertyBlock(block);
    }

    public void SetColor(Color color)
    {
        baseColor = color;
        OnValidate();
    }
}
