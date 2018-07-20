Shader "Unlit/EffectByHsl"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_SaturateValue("SaturateValue",float) = 10.0	
		_SaturateOffset("SaturateOffset",float) = 0.0
		_LightnessValue("LightnessValue",float) = 10.0
		_LightnessOffset("LightnessOffset",float) = 0.0
	}
	SubShader
	{
		Tags { "RenderType"="Opaque" }
		LOD 100

		Pass
		{
			CGPROGRAM
			#pragma vertex vert
			#pragma fragment frag
			// make fog work
			#pragma multi_compile_fog
			
			#include "UnityCG.cginc"

			struct appdata
			{
				float4 vertex : POSITION;
				float2 uv : TEXCOORD0;
			};

			struct v2f
			{
				float2 uv : TEXCOORD0;
				UNITY_FOG_COORDS(1)
				float4 vertex : SV_POSITION;
			};

			float _SaturateValue;
			float _SaturateOffset;
			float _LightnessValue;
			float _LightnessOffset;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			
			v2f vert (appdata v)
			{
				v2f o;
				o.vertex = UnityObjectToClipPos(v.vertex);
				o.uv = TRANSFORM_TEX(v.uv, _MainTex);
				UNITY_TRANSFER_FOG(o,o.vertex);
				return o;
			}
			
			fixed4 frag (v2f i) : SV_Target
			{
				// sample the texture
				fixed4 baseColor = tex2D(_MainTex, i.uv);
				float minc;
				float maxc;
				minc = min(baseColor.r,min(baseColor.g,baseColor.b));
				maxc = max(baseColor.r,max(baseColor.g,baseColor.b));
				fixed3 rgb;
				float H;
				if(minc == maxc || abs(maxc - minc) <0.0001)
				{
					maxc =floor(maxc * 3) / 3;
					rgb = fixed3(1,1,1)* maxc;
				}
				else
				{
					float sa = maxc - minc;
					if(minc == baseColor.b)
					{
						H = 60.0 * (baseColor.g - baseColor.r) / sa + 60.0;
					}
					else if(minc == baseColor.r)
					{
						H = 60.0 * (baseColor.b - baseColor.g) / sa + 180.0;
					}
					else if(minc == baseColor.g)
					{
						H = 60.0 * (baseColor.r - baseColor.b) / sa + 300.0;
					}
					float L = (maxc + minc) / 2.0;
					float S = sa / (1 - abs(maxc + minc - 1.0));
					L = floor(L * _LightnessValue) / _LightnessValue;
					S = floor(S * _SaturateValue) / _SaturateValue;
					L = L * (1.0 - _LightnessOffset) + _LightnessOffset / 2.0;
					S = S * (1.0 - _SaturateOffset) + _SaturateOffset;
					//H = floor(H / 10.0)*10.0;


					float mmax = L + S * (1.0 - abs(2.0 * L -1.0)) / 2.0;
					float mmin = L - S * (1.0 - abs(2.0 * L -1.0)) / 2.0;
					if(H >= 0 && H < 60)
					{
						rgb = fixed3(mmax ,mmin + (mmax - mmin) * H / 60.0 ,mmin);
					}
					else if(H >= 60 && H < 120)
					{
						rgb = fixed3(mmin + (mmax - mmin) * (120.0 - H) / 60.0 ,mmax ,mmin);
					}
					else if(H >= 120 && H < 180)
					{
						rgb = fixed3(mmin ,mmax ,mmin + (mmax - mmin) * (H - 120) / 60.0);
					}
					else if(H >= 180 && H < 240)
					{
						rgb = fixed3(mmin ,mmin + (mmax - mmin) * (240.0 - H) / 60.0 ,mmax);
					}
					else if(H >= 240 && H < 300)
					{
						rgb = fixed3(mmin + (mmax - mmin) * (H - 240.0) / 60.0  ,mmin ,mmax);
					}
					else if(H >= 300 && H < 360)
					{
						rgb = fixed3(mmax ,mmin ,mmin + (mmax - mmin) * (360.0 - H) / 60.0);
					}
				}
				fixed4 col = fixed4(rgb.r,rgb.g,rgb.b,baseColor.a);
				UNITY_APPLY_FOG(i.fogCoord, col);
				return col;
			}
			ENDCG
		}
	}
}
