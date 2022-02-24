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
        
//        float gaussianArr[][5] = {{0.00296902,    0.0133062,    0.0219382,    0.0133062,    0.00296902},
//            {0.0133062,    0.0596343,    0.0983203,    0.0596343,    0.0133062},
//            {0.0219382,    0.0983203,    0.162103,    0.0983203,    0.0219382},
//            {0.0133062,    0.0596343,    0.0983203,    0.0596343,    0.0133062},
//            {0.00296902,    0.0133062,    0.0219382,    0.0133062,    0.00296902}};
        
//        float gaussianArr[][3] = {{1.0,    2.0,    1.0},
//            {2.0,    4.0,    2.0},
//            {1.0,    2.0,    1.0}
//           };
//        //
//        float2 pos = src.coord();
//        float4 pixelColor = src.sample(pos);
//        float3 gaussianWeight = 0;
//
//        for(int i = -1; i < 2; i++ ) {
//            for(int j = -1; j < 2; j++) {
//                float2 a1 = src.transform(pos + float2(i*1.0,j*1.0));
//                float3 a1c = src.sample(a1).rgb;
//                gaussianWeight = gaussianWeight + (a1c * (gaussianArr[i+2][j+2]));
//            }
//        }
        
        float2 pos = src.coord();
        float4 pixelColor = src.sample(pos);
        float3 pixelRGB = pixelColor.rgb;

        float2 a1 = src.transform(pos + float2(-2.0,-2.0));
        float2 a2 = src.transform(pos + float2(-2.0, -1.0));
        float2 a3 = src.transform(pos + float2(-2.0, 0.0));
        float2 a4 = src.transform(pos + float2(-2.0, 1.0));
        float2 a5 = src.transform(pos + float2(-2.0, 2.0));

        float3 a1c = src.sample(a1).rgb;
        float3 a2c = src.sample(a2).rgb;
        float3 a3c = src.sample(a3).rgb;
        float3 a4c = src.sample(a4).rgb;
        float3 a5c = src.sample(a5).rgb;

        float2 b1 = src.transform(pos + float2(-1.0, -2.0));
        float2 b2 = src.transform(pos + float2(-1.0, -1.0));
        float2 b3 = src.transform(pos + float2(-1.0, 0.0));
        float2 b4 = src.transform(pos + float2(-1.0, 1.0));
        float2 b5 = src.transform(pos + float2(-1.0, 2.0));

        float3 b1c = src.sample(b1).rgb;
        float3 b2c = src.sample(b2).rgb;
        float3 b3c = src.sample(b3).rgb;
        float3 b4c = src.sample(b4).rgb;
        float3 b5c = src.sample(b5).rgb;

        float2 c1 = src.transform(pos + float2(0.0,-2.0));
        float2 c2 = src.transform(pos + float2(0.0,-1.0));
        float2 c4 = src.transform(pos + float2(0.0,+1.0));
        float2 c5 = src.transform(pos + float2(0.0,+2.0));

        float3 c1c = src.sample(c1).rgb;
        float3 c2c = src.sample(c2).rgb;
        float3 c4c = src.sample(c4).rgb;
        float3 c5c = src.sample(c5).rgb;

        float2 d1 = src.transform(pos + float2(+1.0,-2.0));
        float2 d2 = src.transform(pos + float2(+1.0, -1.0));
        float2 d3 = src.transform(pos + float2(+1.0, 0.0));
        float2 d4 = src.transform(pos + float2(+1.0,+1.0));
        float2 d5 = src.transform(pos + float2(+1.0,+2.0));
        
        float3 d1c = src.sample(d1).rgb;
        float3 d2c = src.sample(d2).rgb;
        float3 d3c = src.sample(d3).rgb;
        float3 d4c = src.sample(d4).rgb;
        float3 d5c = src.sample(d5).rgb;

        float2 e1 = src.transform(pos + float2(+2.0,-2.0));
        float2 e2 = src.transform(pos + float2(+2.0,-1.0));
        float2 e3 = src.transform(pos + float2(+2.0,0.0));
        float2 e4 = src.transform(pos + float2(+2.0,+1.0));
        float2 e5 = src.transform(pos + float2(+2.0,+2.0));

        float3 e1c = src.sample(e1).rgb;
        float3 e2c = src.sample(e2).rgb;
        float3 e3c = src.sample(e3).rgb;
        float3 e4c = src.sample(e4).rgb;
        float3 e5c = src.sample(e5).rgb;
        
//        {0.00296902,    0.0133062,    0.0219382,    0.0133062,    0.00296902},
//                    {0.0133062,    0.0596343,    0.0983203,    0.0596343,    0.0133062},
//                    {0.0219382,    0.0983203,    0.162103,    0.0983203,    0.0219382},
//                    {0.0133062,    0.0596343,    0.0983203,    0.0596343,    0.0133062},
//                    {0.00296902,    0.0133062,    0.0219382,    0.0133062,    0.00296902}};
        
        float3 gaussian = (0.00296902 * a1c
                           + 0.0133062 * a2c
                           + 0.0219382 * a3c
                           + 0.0133062 * a4c
                           + 0.00296902 * a5c
                           
                           + 0.0133062 * b1c
                           + 0.0596343 * b2c
                           + 0.0983203 * b3c
                           + 0.0596343 * b4c
                           + 0.0133062 * b5c
                           
                           + 0.0219382 * c1c
                           + 0.0983203 * c2c
                           + 0.162103 * pixelRGB
                           + 0.0983203 * c4c
                           + 0.0219382 * c5c
                           
                           + 0.0133062 * d1c
                           + 0.0596343 * d2c
                           + 0.0983203 * d3c
                           + 0.0596343 * d4c
                           + 0.0133062 * d5c
                           
                           + 0.00296902 * e1c
                           + 0.0133062 * e2c
                           + 0.0219382 * e3c
                           + 0.0133062 * e4c
                           + 0.00296902 * e5c
                           );
//        float3 gaussian = (a1c + (2 * a2c) + a3c + (2*b1c) + (2 * b2c) + c1c + (2 * c2c) + c3c + (4 * pixelRGB)) / 16;
//
        return float4(gaussian, 1.0);
    }
    
    float4 lofGauss(sampler src) {
      // 2
        
        //GAUSSIAN ARRAY
       
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

