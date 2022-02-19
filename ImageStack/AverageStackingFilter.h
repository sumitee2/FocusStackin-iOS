//
//  AverageStackingFilter.h
//  ImageStack
//
//  Created by Sumit Chaudhary on 17/02/22.
//

#import <CoreImage/CoreImage.h>

NS_ASSUME_NONNULL_BEGIN

@interface AverageStackingFilter : CIFilter

@property CIKernel *kernel;
@property CIImage *inputCurrentStack;
@property CIImage *inputNewImage;
@property CIImage *inputBase1;
@property CIImage *inputBase2;

@property float inputStackCount;

- (instancetype)initWithFname: (NSString *)filtername;

@end

NS_ASSUME_NONNULL_END
