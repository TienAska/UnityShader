using System;
using UnityEngine;
using UnityEngine.Rendering.PostProcessing;

[Serializable]
[PostProcess(typeof(OutlineRenderer), PostProcessEvent.AfterStack, "Custom/Outline")]
public sealed class Outline : PostProcessEffectSettings
{
    [Range(0f, 1f), Tooltip("EdgeOnly")]
    public FloatParameter edgeOnly = new FloatParameter { value = 0.0f };

    public ColorParameter edgeColor = new ColorParameter {value = Color.black};

    public ColorParameter backgroundColor = new ColorParameter {value = Color.white};

    public FloatParameter simpleDistance = new FloatParameter { value = 1.0f };

    public FloatParameter sensitivityDepth = new FloatParameter { value = 1.0f };

    public FloatParameter sensitivityNormals = new FloatParameter {value = 1.0f};
}

public sealed class OutlineRenderer : PostProcessEffectRenderer<Outline>
{
    public override void Render(PostProcessRenderContext context)
    {
        var sheet = context.propertySheets.Get(Shader.Find("Hidden/Custom/Outline"));
        sheet.properties.SetFloat("_EdgeOnly", settings.edgeOnly);
        sheet.properties.SetColor("_EdgeColor", settings.edgeColor);
        sheet.properties.SetColor("_BackgroundColor", settings.backgroundColor);
        sheet.properties.SetFloat("_SampleDistance", settings.simpleDistance);
        sheet.properties.SetVector("_Sensitivity", new Vector4(settings.sensitivityNormals, settings.sensitivityDepth, 0.0f, 0.0f));
        context.command.BlitFullscreenTriangle(context.source, context.destination, sheet, 0);
    }
}