﻿using UnityEngine;
using UnityEngine.Rendering;
using Conditional = System.Diagnostics.ConditionalAttribute;

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


    CommandBuffer cameraBuffer = new CommandBuffer() { name = "Render Camera" };

    CullingResults cull;

    void Render(ScriptableRenderContext context, Camera camera)
    {
        // culling parameter setup
        ScriptableCullingParameters cullingParameters;
        if (!camera.TryGetCullingParameters(out cullingParameters))
        {
            return;
        }

#if UNITY_EDITOR
        // inject ui into scene window
        if (camera.cameraType == CameraType.SceneView)
        {
            ScriptableRenderContext.EmitWorldGeometryForSceneView(camera);
        }
#endif

        cull = context.Cull(ref cullingParameters);

        // setup current camera
        context.SetupCameraProperties(camera);

        // camera clear
        CameraClearFlags clearFlags = camera.clearFlags;
        cameraBuffer.ClearRenderTarget
        (
            (clearFlags & CameraClearFlags.Depth) != 0,
            (clearFlags & CameraClearFlags.Color) != 0,
            camera.backgroundColor
        );
        cameraBuffer.BeginSample("Render Camera");
        context.ExecuteCommandBuffer(cameraBuffer);
        cameraBuffer.Clear();

        // draw opaque
        var drawSettings = new DrawingSettings(new ShaderTagId("SRPDefaultUnlit"), new SortingSettings(camera));
        var filterSettings = FilteringSettings.defaultValue;
        filterSettings.renderQueueRange = RenderQueueRange.opaque;
        context.DrawRenderers(cull, ref drawSettings, ref filterSettings);

        // draw skeybox
        context.DrawSkybox(camera);

        // draw transparent
        filterSettings.renderQueueRange = RenderQueueRange.transparent;
        context.DrawRenderers(cull, ref drawSettings, ref filterSettings);

        // draw defult surface shader
        DrawDefaultPipeline(context, camera);

        cameraBuffer.EndSample("Render Camera");
        context.ExecuteCommandBuffer(cameraBuffer);
        cameraBuffer.Clear();

        context.Submit();
    }

    Material errorMaterial;

    [Conditional("DEVELOPMENT_BUILD"), Conditional("UNITY_EDITOR")]
    void DrawDefaultPipeline(ScriptableRenderContext context, Camera camera)
    {
        if (errorMaterial == null)
        {
            Shader errorShader = Shader.Find("Hidden/InternalErrorShader");
            errorMaterial = new Material(errorShader) { hideFlags = HideFlags.HideAndDontSave };
        }

        var drawSettings = new DrawingSettings(new ShaderTagId("ForwardBase"), new SortingSettings(camera)) { overrideMaterial = errorMaterial, overrideMaterialPassIndex = 0 };
        drawSettings.SetShaderPassName(1, new ShaderTagId("PrepassBase"));
        drawSettings.SetShaderPassName(2, new ShaderTagId("Always"));
        drawSettings.SetShaderPassName(3, new ShaderTagId("Vertex"));
        drawSettings.SetShaderPassName(4, new ShaderTagId("VertexLMRGBM"));
        drawSettings.SetShaderPassName(5, new ShaderTagId("VertexLM"));
        var filterSettings = FilteringSettings.defaultValue;

        context.DrawRenderers(cull, ref drawSettings, ref filterSettings);
    }
}