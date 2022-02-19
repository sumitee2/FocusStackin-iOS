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
  float4 avgStacking(sample_t currentStack, sample_t newImage, float stackCount) {
    // 2
    float4 avg = ((currentStack * stackCount) + newImage) / (stackCount + 1.0);
    // 3
    avg = float4(avg.rgb, 1);
    // 4
    
    return avg;
  }
    
    float4 avgeeStacking(sample_t currentStack) {
      // 2
     
      
        return float4(1.1,0.1,0.1,1.0);
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

