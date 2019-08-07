using UnityEngine;
using UnityEngine.Rendering;

[CreateAssetMenu(menuName = "Rendering/My Pipeline")]
public class MyPipelineAsset : RenderPipelineAsset
{
    [SerializeField]
    bool dynamicBatching = false;

    [SerializeField]
    bool instancing = false;

    protected override RenderPipeline CreatePipeline()
    {
        return new MyPipeline(dynamicBatching, instancing);
    }
}