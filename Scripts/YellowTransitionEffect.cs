using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class YellowTransitionEffect : MonoBehaviour
{
    public TransitionAEffect transitionAShader;

    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        transitionAShader.OnRenderImage(source, destination);
    }

    public abstract class TransitionEffect
    {
        public Shader shader;
        protected Material material;
        protected void Init()
        {
            if (material == null)
            {
                material = new Material(shader);
            }
        }

        public abstract void Update();

        public void OnRenderImage(RenderTexture source, RenderTexture destination)
        {
            Init();
            Update();
            Graphics.Blit(source, destination, material);
        }
    }

    [System.Serializable]
    public class TransitionAEffect : TransitionEffect
    {
        [Range(0.0f , 3.1415f)]
        public float angle = 0.0f;
        public float factor = 18.75f;

        protected const string AngleProperty = "_Angle";
        protected const string FactorProperty = "_Factor";

        public override void Update()
        {
            material.SetFloat(AngleProperty, -angle);
            material.SetFloat(FactorProperty, factor);
        }
    }
}
