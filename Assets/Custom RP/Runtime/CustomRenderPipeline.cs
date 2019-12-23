using UnityEngine;
using UnityEngine.Rendering;
using Conditional = System.Diagnostics.ConditionalAttribute;

public class CustomRenderPipeline : RenderPipeline
{
    //const int maxVisibleLights = 4;

    //static int visibleLightColorsId = Shader.PropertyToID("_VisibleLightColors");
    //static int visibleLightDirectionsId = Shader.PropertyToID("_VisibleLightDirections");

    //Vector4[] visibleLightColors = new Vector4[maxVisibleLights];
    //Vector4[] visibleLightDirections = new Vector4[maxVisibleLights];

    bool useDynamicBatching, useGPUInstancing;

    public CustomRenderPipeline(bool useDynamicBatching, bool useGPUInstancing, bool useSRPBatcher)
    {
        this.useDynamicBatching = useDynamicBatching;
        this.useGPUInstancing = useGPUInstancing;
        GraphicsSettings.useScriptableRenderPipelineBatching = useSRPBatcher;
        GraphicsSettings.lightsUseLinearIntensity = true;
    }

    CameraRenderer renderer = new CameraRenderer();

    protected override void Render(ScriptableRenderContext context, Camera[] cameras)
    {
        foreach (Camera camera in cameras)
        {
            renderer.Render(context, camera, useDynamicBatching, useGPUInstancing);
        }
    }
}
