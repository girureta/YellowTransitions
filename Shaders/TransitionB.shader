Shader "YellowTransitions/TransitionB"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		//How rotated the higher bound should be.
		_Progress("Progress",Range(0,1)) = 0
		//How many rows/columns the screen should be devided in.
		_Factor("Factor",float) = 18.75
    }
    SubShader
    {
        Cull Off ZWrite Off ZTest Always

        Pass
        {
            CGPROGRAM
            #pragma vertex vert
            #pragma fragment frag

            #include "UnityCG.cginc"

            struct appdata
            {
                float4 vertex : POSITION;
                float2 uv : TEXCOORD0;
            };

            struct v2f
            {
                float2 uv : TEXCOORD0;
                float4 vertex : SV_POSITION;
            };

			sampler2D _MainTex;
			float _Progress;
			float _Factor;

			float TransitionB(float2 uv)
			{
				float2 c = ceil((_Factor) * uv);
				float sign = step(1,fmod(c.y, 2));
				c = c / (_Factor + 0.01);
				float ret = step(_Progress, (sign*(1.0 - c.x)) + ((1-sign)*c.x) );

				return ret;
			}

			v2f vert(appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = v.uv;
				return o;
			}

            fixed4 frag (v2f i) : SV_Target
            {
			    float ret = TransitionB(i.uv);
				fixed4 col = tex2D(_MainTex, i.uv);
				ret = lerp(0,col,ret);
				return ret;
            }
            ENDCG
        }
    }
}
