using System;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

[Serializable]
[PostProcess(typeof(BSCRenderer), PostProcessEvent.AfterStack, "Custom/BSC")]
public sealed class BSC : PostProcessEffectSettings
{
    [Range(0f, 3f), Tooltip("Brightness")]
    public FloatParameter brightness = new FloatParameter { value = 1.0f };

    [Range(0f, 3f), Tooltip("Saturation")]
    public FloatParameter satruation = new FloatParameter { value = 1.0f };

    [Range(0f, 3f), Tooltip("Contrast")]
    public FloatParameter contrast = new FloatParameter { value = 1.0f };
}

public sealed class BSCRenderer : PostProcessEffectRenderer<BSC>
{
    public override void Render(PostProcessRenderContext context)
    {
        var sheet = context.propertySheets.Get(Shader.Find("Hidden/Custom/BSC"));
        sheet.properties.SetFloat("_Birghtness", settings.brightness);
        sheet.properties.SetFloat("_Saturation", settings.satruation);
        sheet.properties.SetFloat("_Contrast", settings.contrast);
        context.command.BlitFullscreenTriangle(context.source, context.destination, sheet, 0);
    }
}