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

    //bool bBatching;
    //bool bInstancing;

    public CustomRenderPipeline(bool dynamicBatching, bool instancing)
    {
        GraphicsSettings.lightsUseLinearIntensity = true;

        //bBatching = dynamicBatching;
        //bInstancing = instancing;
    }

    CameraRenderer renderer = new CameraRenderer();

    protected override void Render(ScriptableRenderContext context, Camera[] cameras)
    {
        foreach (Camera camera in cameras)
        {
            renderer.Render(context, camera);
        }
    }
}
