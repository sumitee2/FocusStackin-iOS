//
//  AverageStacking.metal
//  ImageStack
//
//  Created by Sumit Chaudhary on 17/02/22.
//

#include <metal_stdlib>
using namespace metal;
#include <CoreImage/CoreImage.h>

//float3x3 area = float3x3(

extern "C" { namespace coreimage {
  // 1
  float4 compareStacking(sample_t firstX, sample_t secX, sample_t firstBase, sample_t secBase) {
    // 2
      float intervar = firstX.rgb.x;
      float intervar2 = secX.rgb.x;
      float4 resultVar = intervar > intervar2 ? firstBase : secBase;
          
    return resultVar;
  }
    
    float4 gaussianImage(sampler src) {
      // 2
        float2 pos = src.coord();
        float4 pixelColor = src.sample(pos);
        float3 pixelRGB = pixelColor.rgb;
        
        float2 a1 = src.transform(pos + float2(-1.0,-1.0));
        float2 a2 = src.transform(pos + float2(-1.0, 0.0));
        float2 a3 = src.transform(pos + float2(-1.0, 1.0));
        float3 a1c = src.sample(a1).rgb;
        float3 a2c = src.sample(a2).rgb;
        float3 a3c = src.sample(a3).rgb;

        float2 b1 = src.transform(pos + float2(0.0, -1.0));
        float2 b2 = src.transform(pos + float2(0.0, 1.0));
        float3 b1c = src.sample(b1).rgb;
        float3 b2c = src.sample(b2).rgb;

        float2 c1 = src.transform(pos + float2(+1.0,-1.0));
        float2 c2 = src.transform(pos + float2(+1.0, 0.0));
        float2 c3 = src.transform(pos + float2(+1.0,+1.0));
        float3 c1c = src.sample(c1).rgb;
        float3 c2c = src.sample(c2).rgb;
        float3 c3c = src.sample(c3).rgb;

        float3 gaussian = (a1c + (2 * a2c) + a3c + (2*b1c) + (2 * b2c) + c1c + (2 * c2c) + c3c + (4 * pixelRGB)) / 16;
        
        return float4(gaussian, 1.0);
    }
    
    float4 lofGauss(sampler src) {
      // 2
        float2 pos = src.coord();
        float4 pixelColor = src.sample(pos);
        float3 pixelRGB = pixelColor.rgb;
        
        float2 a1 = src.transform(pos + float2(-1.0,-1.0));
        float2 a2 = src.transform(pos + float2(-1.0, 0.0));
        float2 a3 = src.transform(pos + float2(-1.0, 1.0));
        float3 a1c = src.sample(a1).rgb;
        float3 a2c = src.sample(a2).rgb;
        float3 a3c = src.sample(a3).rgb;

        float2 b1 = src.transform(pos + float2(0.0, -1.0));
        float2 b2 = src.transform(pos + float2(0.0, 1.0));
        float3 b1c = src.sample(b1).rgb;
        float3 b2c = src.sample(b2).rgb;

        float2 c1 = src.transform(pos + float2(+1.0,-1.0));
        float2 c2 = src.transform(pos + float2(+1.0, 0.0));
        float2 c3 = src.transform(pos + float2(+1.0,+1.0));
        float3 c1c = src.sample(c1).rgb;
        float3 c2c = src.sample(c2).rgb;
        float3 c3c = src.sample(c3).rgb;

        float3 gaussian = abs(-1 * (a1c + a2c + a3c + b1c + 2 * b2c + c1c + 2 * c2c + c3c) + (8 * pixelRGB)) / 16;
        
        return float4(gaussian, 1.0);
    }
    
//    float4 testStacking(sampler src) {
//        // 2
//        float2 pos = src.coord();
//        float4 pixelColor = src.sample(pos);
//        // (4)
//        float3 pixelRGB = pixelColor.rgb;
//
//        return pixelColor;//float4(1.1,0.1,0.1,1.0);
//
//    }
}
}

