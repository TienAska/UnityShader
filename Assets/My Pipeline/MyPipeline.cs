using UnityEngine;
using UnityEngine.Rendering;

public class MyPipeline : RenderPipeline
{
    protected override void Render(ScriptableRenderContext context, Camera[] cameras)
    {
        //base.Render(context, cameras);
        foreach (var camera in cameras)
        {
            Render(context, camera);
        }
    }

    void Render(ScriptableRenderContext context, Camera camera)
    {
        ScriptableCullingParameters cullingParameters;
        if (!camera.TryGetCullingParameters(out cullingParameters))
        {
            return;
        }
        CullingResults cull = context.Cull(ref cullingParameters);

        context.SetupCameraProperties(camera);

        var buffer = new CommandBuffer() { name = camera.name };
        CameraClearFlags clearFlags = camera.clearFlags;
        buffer.ClearRenderTarget
        (
            (clearFlags & CameraClearFlags.Depth) != 0,
            (clearFlags & CameraClearFlags.Color) != 0,
            camera.backgroundColor
        );
        context.ExecuteCommandBuffer(buffer);
        buffer.Release();
        var drawSettings = new DrawingSettings(new ShaderTagId("SRPDefaultUnlit"), new SortingSettings(camera));
        var filterSettings = FilteringSettings.defaultValue;
        filterSettings.renderQueueRange = RenderQueueRange.opaque;
        context.DrawRenderers(cull, ref drawSettings, ref filterSettings);

        context.DrawSkybox(camera);

        filterSettings.renderQueueRange = RenderQueueRange.transparent;
        context.DrawRenderers(cull, ref drawSettings, ref filterSettings);

        context.Submit();
    }
}
