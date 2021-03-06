﻿Shader "Unlit/EffectByHsv"
{
	Properties
	{
		_MainTex ("Texture", 2D) = "white" {}
		_xMaxSize("xMaxSize",int) = 128
		_yMaxSize("yMaxSize",int) = 128
		_SaturateMin("SaturateMin",float) = 0.0
		_SaturateValue1("SaturateValue1",float) = 0.3
		_SaturateValue2("SaturateValue2",float) = 0.7
		_SaturateMax("SaturateMax",float) = 1.0
		_SaturateOffset1("SaturateOffset1",float) = 0.25
		_SaturateOffset2("SaturateOffset2",float) = 0.5
		_SaturateOffset3("SaturateOffset3",float) = 0.75
		_BrightnessMin("BrightnessMin",float) = 0.0
		_BrightnessValue1("BrightnessValue1",float) = 0.5
		_BrightnessValue2("BrightnessValue2",float) = 0.6
		_BrightnessMax("BrightnessMax",float) = 1.0
		_BrightnessOffset1("BrightnessOffset1",float) = 0.0
		_BrightnessOffset2("BrightnessOffset2",float) = 0.0
		_BrightnessOffset3("BrightnessOffset3",float) = 0.0
		_BrightnessOffset4("BrightnessOffset4",float) = 0.0
		_LineValue1("LineValue1",int) = 16
		_LineValue2("LineValue2",int) = 16
		_HueValue("HueValue",int) = 360
		_HueOffset("HueOffset",float) = 0.0
		_MaxMinValue("MaxMinValue",float) = 0.01
		_OutlineValue("OutlineValue",float) = 0.5
		_ShadowLineValue1("ShadowLineValue1",float) = 0.1
		_ShadowLineValue2("ShadowLineValue2",float) = 0.1
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
			int _xMaxSize;
			int _yMaxSize;
			float _SaturateMin;
			float _SaturateValue1;
			float _SaturateValue2;
			float _SaturateMax;
			float _SaturateOffset1;
			float _SaturateOffset2;
			float _SaturateOffset3;
			float _BrightnessMin;
			float _BrightnessValue1;
			float _BrightnessValue2;
			float _BrightnessMax;
			float _BrightnessOffset1;
			float _BrightnessOffset2;
			float _BrightnessOffset3;
			float _BrightnessOffset4;
			float _LineValue1;
			float _LineValue2;
			float _HueValue;
			float _HueOffset;
			float _MaxMinValue;
			sampler2D _MainTex;
			float4 _MainTex_ST;
			float _OutlineValue;
			float _ShadowLineValue1;
			float _ShadowLineValue2;
			
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
				fixed3 baseColor = fixed3(0,0,0);
				//fixed3 baseColor = tex2D(_MainTex,i.uv);
				float X = i.uv.x * _xMaxSize;
				float Y = i.uv.y * _yMaxSize;
				fixed3 e = fixed3(1.0 / _xMaxSize, -1.0 / _yMaxSize, 0.0);
				fixed3 right =tex2D(_MainTex, i.uv + e.xz);
				fixed3 left = tex2D(_MainTex, i.uv + e.yz);
				fixed3 up = tex2D(_MainTex, i.uv + e.zx);
				fixed3 down = tex2D(_MainTex, i.uv + e.zy);
				fixed3 rightup = tex2D(_MainTex, i.uv + e.xx);
				fixed3 leftdown = tex2D(_MainTex, i.uv + e.yy);
				fixed3 leftup = tex2D(_MainTex, i.uv + e.yx);
				fixed3 rightdown = tex2D(_MainTex, i.uv + e.xy);
				//baseColor = (baseColor + right + left + up + down) / 5.0;
				baseColor = (4 * baseColor + 2 * right + 2 * left + 2 * up + 2 * down + rightdown + rightup + leftup + leftdown) / 16.0;
				//baseColor = (baseColor + right + left + up + down + rightdown + rightup + leftup + leftdown) / 9.0;
				
				
				
				float minc;
				float maxc;
				minc = min(baseColor.r,min(baseColor.g,baseColor.b));
				maxc = max(baseColor.r,max(baseColor.g,baseColor.b));
				float newBright = baseColor.r * 0.299 + baseColor.g * 0.587 + baseColor.b * 0.114;
				fixed3 rgb;
				float H;
				float shadowoffsetdown1 = _ShadowLineValue1 /2.0;
				float shadowoffsetup1 = 1.0 - shadowoffsetdown1;
				float shadowoffsetdown2 = _ShadowLineValue2 /2.0;
				float shadowoffsetup2 = 1.0 - shadowoffsetdown2;
				if( abs(maxc - minc) < _MaxMinValue)
				{
					/*
					maxc =floor(maxc * 3) / 3;
					maxc = maxc * (1.0 - _BrightnessOffset1) + _BrightnessOffset1;
					maxc = floor(maxc * _BrightnessValue)* _BrightnessValue;
					maxc = maxc * (1.0 - _BrightnessOffset2) + _BrightnessOffset2;
					*/
					if(maxc <= _BrightnessOffset1){
						maxc = 0;
					}
					else if(maxc <= _BrightnessOffset2){
						X /= _LineValue1;
						Y /= _LineValue1;
						float wa = X + Y;
						float wa2 = Y - X;
						wa = wa - floor(wa);
						wa2 = wa2 - floor(wa2);
						if(wa <= shadowoffsetdown1 || wa >= shadowoffsetup1){
							maxc = 0;
						}
						else if(wa2 <= shadowoffsetdown1 || wa2 >= shadowoffsetup1){
							maxc = 0;
						}
						else{
							maxc = _BrightnessMin;
						}
						//maxc =_BrightnessMin;
					}
					else if(maxc <= _BrightnessOffset3){
						X /= _LineValue2;
						Y /= _LineValue2;
						float wa = X + Y;
						wa = wa - floor(wa);
						if(wa <= shadowoffsetdown2 || wa >= shadowoffsetup2){
							maxc = 0;
						}else{
							maxc = _BrightnessValue1;
						}
						//maxc = _BrightnessValue1;
					} 
					else if(maxc <= _BrightnessOffset4){
						maxc = _BrightnessValue2;
					}
					else {
						maxc = _BrightnessMax;
					}
					
					rgb = fixed3(1,1,1) * maxc;
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
					float V = newBright;
					float S = sa;
					/*
					V = V * (1.0 - _BrightnessOffset1) + _BrightnessOffset1;
					S = S * (1.0 - _SaturateOffset1) + _SaturateOffset1;
					V = floor(V * _BrightnessValue) / _BrightnessValue;
					S = floor(S * _SaturateValue) / _SaturateValue;
					V = V * (1.0 - _BrightnessOffset2) + _BrightnessOffset2;
					S = S * (1.0 - _SaturateOffset2) + _SaturateOffset2;
					*/


					H = floor(H * _HueValue / 360) / _HueValue * 360;
					H += _HueOffset * 360;

					if(V <= _BrightnessOffset1){
						V = 0;
					}
					else if(V <= _BrightnessOffset2){
						X /= _LineValue1;
						Y /= _LineValue1; 
						float wa = X + Y;
						float wa2 = Y - X;
						wa = wa - floor(wa);
						wa2 = wa2 - floor(wa2);
						if(wa <= shadowoffsetdown1 || wa >= shadowoffsetup1){
							V = 0;
						}
						else if(wa2 <= shadowoffsetdown1 || wa2 >= shadowoffsetup1){
							V = 0;
						}
						else{
							V = _BrightnessMin;
						}
						//V = _BrightnessMin;
					}
					else if(V <= _BrightnessOffset3){
						X /= _LineValue2;
						Y /= _LineValue2; 
						float wa = X + Y;
						wa = wa - floor(wa);
						if(wa <= shadowoffsetdown2 || wa >= shadowoffsetup2){
							V = 0;
						}else{
							V = _BrightnessValue1;
						}
						//V = _BrightnessValue1;
					} 
					else if(V < _BrightnessOffset4){
						V = _BrightnessValue2;
					}
					else{
						//V = 1.0;
						V = _BrightnessMax;
					}
					
					
					if(S < _SaturateOffset1){
						S =_SaturateMin;
					}
					else if(S < _SaturateOffset2){
						S = _SaturateValue1;
					} 
					else if(S < _SaturateOffset3)
					{
						S = _SaturateValue2;
					}
					else{
						S = _SaturateMax;
					}
					
					float C = S;

					H = H / 60.0;
					H = fmod(H,6);
					if(H < 0){
						H += 6.0;
					}
					float X = C * (1 - abs(fmod(H,2) - 1.0));

					rgb = fixed3(V-C,V-C,V-C);
					if(H >= 0 && H < 1)
					{
						rgb += fixed3(C,X,0);
					}
					else if(H >= 1 && H < 2)
					{
						rgb += fixed3(X,C,0);
					}
					else if(H >= 2 && H < 3)
					{
						rgb += fixed3(0,C,X);
					}
					else if(H >= 3 && H < 4)
					{
						rgb += fixed3(0,X,C);
					}
					else if(H >= 4 && H < 5)
					{
						rgb += fixed3(X,0,C);
					}
					else if(H >= 5 && H < 6)
					{
						rgb += fixed3(C,0,X);
					}
				}
				fixed4 col = fixed4(rgb.r,rgb.g,rgb.b,1.0);
				
				fixed3 gh = -1 * (leftup + 2 * left + leftdown) + rightup + 2 * right + rightdown;
				fixed3 gv = -1 * (leftup + 2 * up + rightup) + leftdown + 2 * down + rightdown;
				fixed3 gsum = gh * gh + gv * gv;
				if(sqrt(dot(gsum,gsum)) * 10 > _OutlineValue ){
					col = fixed4(0,0,0,1.0);
				}
				
				UNITY_APPLY_FOG(i.fogCoord, col); 
				return col;
			}
			ENDCG
		}
	}
}
