using UnityEngine;
using UnityEngine.Rendering;

[CreateAssetMenu(menuName = "Rendering/Custom Render Pipeline")]
public class CustomRenderPipelineAsset : RenderPipelineAsset
{
    [SerializeField]
    bool dynamicBatching = false;

    [SerializeField]
    bool instancing = false;

    protected override RenderPipeline CreatePipeline()
    {
        return new CustomRenderPipeline(dynamicBatching, instancing);
    }
}