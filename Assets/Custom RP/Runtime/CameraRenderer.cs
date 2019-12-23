using UnityEngine;
using UnityEngine.Rendering;

public partial class CameraRenderer
{
    const int maxVisibleLights = 4;

    static int visibleLightColorsId = Shader.PropertyToID("_VisibleLightColors");
    static int visibleLightDirectionsId = Shader.PropertyToID("_VisibleLightDirections");

    Vector4[] visibleLightColors = new Vector4[maxVisibleLights];
    Vector4[] visibleLightDirections = new Vector4[maxVisibleLights];

    ScriptableRenderContext context;

    Camera camera;

    const string bufferName = "Render Camera";
    CommandBuffer buffer = new CommandBuffer() { name = bufferName };

    CullingResults cullingResults;

    static ShaderTagId unlitShaderTagId = new ShaderTagId("SRPDefaultUnlit");

    public void Render(ScriptableRenderContext context, Camera camera, bool useDynamicBatching, bool useGPUInstancing)
    {
        this.context = context;
        this.camera = camera;

        PrepareBuffer();
        PrepareForSceneWindow();
        if (!Cull())
        {
            return;
        }

        Setup();

        ConfigureLights();

        buffer.SetGlobalVectorArray(visibleLightColorsId, visibleLightColors);
        buffer.SetGlobalVectorArray(visibleLightDirectionsId, visibleLightDirections);

        DrawVisibleGeometry(useDynamicBatching, useGPUInstancing);

        // draw defult surface shader
        DrawUnsupportedShaders();

        DrawGizoms();

        Submit();
    }

    bool Cull()
    {
        // culling parameter setup
        if (camera.TryGetCullingParameters(out ScriptableCullingParameters p))
        {
            cullingResults = context.Cull(ref p);
            return true;
        }
        return false;
    }

    void Setup()
    {
        // setup camera properties before clear to use quick clear method
        context.SetupCameraProperties(camera);
        CameraClearFlags flags = camera.clearFlags;
        // camera clear
        buffer.ClearRenderTarget
        (
            flags <= CameraClearFlags.Depth,
            flags == CameraClearFlags.Color,
            flags == CameraClearFlags.Color ? camera.backgroundColor.linear : Color.clear
        );
        // setup current camera
        buffer.BeginSample(SampleName);
        ExecuteBuffer();
    }

    void ExecuteBuffer()
    {
        context.ExecuteCommandBuffer(buffer);
        buffer.Clear();
    }

    void Submit()
    { 
        buffer.EndSample(SampleName);
        ExecuteBuffer();
        context.Submit();
    }

    void DrawVisibleGeometry(bool useDynamicBatching, bool useGPUInstancing)
    {
        // draw opaque
        var sortingSettings = new SortingSettings(camera) { criteria = SortingCriteria.CommonOpaque };
        var drawingSettings = new DrawingSettings(unlitShaderTagId, sortingSettings) { enableDynamicBatching = useDynamicBatching, enableInstancing = useGPUInstancing };
        var filteringSettings = new FilteringSettings(RenderQueueRange.opaque);
        context.DrawRenderers(cullingResults, ref drawingSettings, ref filteringSettings);

        // draw skeybox
        context.DrawSkybox(camera);

        // draw transparent
        sortingSettings.criteria = SortingCriteria.CommonTransparent;
        drawingSettings.sortingSettings = sortingSettings;
        filteringSettings.renderQueueRange = RenderQueueRange.transparent;
        context.DrawRenderers(cullingResults, ref drawingSettings, ref filteringSettings);
    }


    void ConfigureLights()
    {
        for (int i = 0; i < cullingResults.visibleLights.Length; i++)
        {
            VisibleLight light = cullingResults.visibleLights[i];
            visibleLightColors[i] = light.finalColor;
            Vector4 v = light.localToWorldMatrix.GetColumn(2);
            v.x = -v.x;
            v.y = -v.y;
            v.z = -v.z;
            visibleLightDirections[i] = v;
        }
    }
}