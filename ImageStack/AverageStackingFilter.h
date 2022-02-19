//
//  AverageStackingFilter.h
//  ImageStack
//
//  Created by Sumit Chaudhary on 17/02/22.
//

#import <CoreImage/CoreImage.h>

NS_ASSUME_NONNULL_BEGIN

@interface AverageStackingFilter : CIFilter

@property CIBlendKernel *kernel;
@property CIImage *inputCurrentStack;
@property CIImage *inputNewImage;
@property float inputStackCount;


@end

NS_ASSUME_NONNULL_END
