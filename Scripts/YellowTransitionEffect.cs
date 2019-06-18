using System.Collections;
using System.Collections.Generic;
using UnityEngine;

[ExecuteInEditMode]
public class YellowTransitionEffect : MonoBehaviour
{
    public TransitionAEffect transitionAEffect;
    public TransitionBEffect transitionBEffect;
    protected TransitionEffect transitionEffect;

    public enum Transition
    {
        TransitionA,
        TransitionB
    }

    public Transition transition = Transition.TransitionA;
    protected Transition m_Transition = Transition.TransitionA;

    void OnRenderImage(RenderTexture source, RenderTexture destination)
    {
        if (transitionEffect == null || transition != m_Transition)
        {
            m_Transition = transition;
            transitionEffect = GetTransitionEffect(m_Transition);
        }
        transitionEffect.OnRenderImage(source, destination);
    }

    protected TransitionEffect GetTransitionEffect(Transition transition)
    {
        TransitionEffect effect = null;

        switch (transition)
        {
            case Transition.TransitionA:
                effect = transitionAEffect;
                break;
            case Transition.TransitionB:
                effect = transitionBEffect;
                break;
            default:
                break;
        }

        return effect;
    }

    public abstract class TransitionEffect
    {
        public Shader shader;
        protected Material material;
        protected bool Init()
        {
            if (shader == null)
                return false;

            if (material == null)
            {
                material = new Material(shader);
            }

            return true;
        }

        public abstract void Update();

        public void OnRenderImage(RenderTexture source, RenderTexture destination)
        {
            if (Init())
            {
                Update();
                Graphics.Blit(source, destination, material);
            }
            else
            {
                Graphics.Blit(source, destination);
            }
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

    [System.Serializable]
    public class TransitionBEffect : TransitionEffect
    {
        [Range(0.0f, 1.0f)]
        public float progress = 0.0f;
        public float factor = 18.75f;

        protected const string ProgressProperty = "_Progress";
        protected const string FactorProperty = "_Factor";

        public override void Update()
        {
            material.SetFloat(ProgressProperty, progress);
            material.SetFloat(FactorProperty, factor);
        }
    }
}
