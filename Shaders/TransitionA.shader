Shader "YellowTransitions/TransitionA"
{
    Properties
    {
        _MainTex ("Texture", 2D) = "white" {}
		//How rotated the higher bound should be.
		_Angle("Angle",Range(-3.1415,0)) = 0
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

			//Rotates a float2 around a point
			float2 RotatePoint(float2 pt, float2 center, float angle) {
				float sinAngle = sin(angle);
				float cosAngle = cos(angle);
				pt -= center;
				float2 r;
				r.x = pt.x * cosAngle - pt.y * sinAngle;
				r.y = pt.x * sinAngle + pt.y * cosAngle;
				r += center;
				return r;
			}

			sampler2D _MainTex;
			float _Angle;
			float _Factor;

			float TransitionA(float2 uv, float2 uvR)
			{
				float top = step(0.5, uv.y);
				float topR = step(0.5, uvR.y);
				float top3 = step(1.0, top-topR);
				float top4 = step(1.0, topR - top);
				return top3 + top4;
			}

			float2 Pixelize(float2 uv)
			{
				float2 c = uv;
				c = round(_Factor * c) / _Factor;
				return c;
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
				float2 zone = Pixelize(i.uv);
				float2 zoneR = Pixelize(RotatePoint(zone, float2(0.5, 0.5), _Angle));
			    float ret = TransitionA(zone, zoneR);
				fixed4 col = tex2D(_MainTex, i.uv);
				ret = lerp(col, 0,ret);
				return ret;
            }
            ENDCG
        }
    }
}
