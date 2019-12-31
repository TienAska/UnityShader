using UnityEngine;
using UnityEngine.Rendering;

public class Lighting
{
    const string bufferName = "Lighting";

    CommandBuffer buffer = new CommandBuffer { name = bufferName };

    //const int maxVisibleLights = 4;

    static int 
        dirLightColorsId = Shader.PropertyToID("_DirectionalLightColors"),
        dirLightDirectionsId = Shader.PropertyToID("_DirectionalLightDirection");

    //Vector4[] visibleLightColors = new Vector4[maxVisibleLights];
    //Vector4[] visibleLightDirections = new Vector4[maxVisibleLights];



    //void ConfigureLights()
    //{
    //    for (int i = 0; i < cullingResults.visibleLights.Length; i++)
    //    {
    //        VisibleLight light = cullingResults.visibleLights[i];
    //        visibleLightColors[i] = light.finalColor;
    //        Vector4 v = light.localToWorldMatrix.GetColumn(2);
    //        v.x = -v.x;
    //        v.y = -v.y;
    //        v.z = -v.z;
    //        visibleLightDirections[i] = v;
    //    }
    //}

    public void Setup(ScriptableRenderContext context)
    {
        buffer.BeginSample(bufferName);
        SetupDirectionalLight();
        buffer.EndSample(bufferName);
        context.ExecuteCommandBuffer(buffer);
        buffer.Clear();
    }

    void SetupDirectionalLight()
    {
        Light light = RenderSettings.sun;
        //buffer.SetGlobalVectorArray(visibleLightColorsId, visibleLightColors);
        //buffer.SetGlobalVectorArray(visibleLightDirectionsId, visibleLightDirections);
        buffer.SetGlobalColor(dirLightColorsId, light.color.linear * light.intensity);
        buffer.SetGlobalVector(dirLightDirectionsId, -light.transform.forward);
    }
}
