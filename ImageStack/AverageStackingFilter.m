//
//  AverageStackingFilter.m
//  ImageStack
//
//  Created by Sumit Chaudhary on 17/02/22.
//

#import "AverageStackingFilter.h"

@implementation AverageStackingFilter

@synthesize inputStackCount;

- (instancetype)init {
    self = [super init];
    self.inputStackCount = 5;
    if (self) {
        @try  {
            NSError *error;
            NSURL *url = [[NSBundle mainBundle] URLForResource:@"default" withExtension:@"metallib"];
            if (!url) {
                [NSException raise:@"Bundle error: path to kernel not found" format:@"Check build settings"];
            } else {
                NSData *data = [NSData dataWithContentsOfURL:url];
               _kernel = [CIKernel kernelWithFunctionName:@"avgeeStacking" fromMetalLibraryData:data error: &error];
            }
        } @catch (NSError *error) {
              NSLog(@"%@ ", error.domain);
        }
    }
        return self;
    
    return self;
}

- (CIImage *) outputImage {
    if (_inputCurrentStack && _inputNewImage) {
        
        NSArray *argmts = [NSArray arrayWithObjects:_inputCurrentStack, nil];
        
        CIKernelROICallback callback = ^(int index, CGRect rect) {
            return rect;
        };
        
        CIImage *op = [_kernel applyWithExtent:_inputCurrentStack.extent roiCallback:callback arguments:argmts];
        return op;
    } else {
        return nil;
    }
}

//if (_inputCurrentStack && _inputNewImage) {
//    
//    NSArray *argmts = [NSArray arrayWithObjects:_inputCurrentStack, _inputNewImage, [NSNumber numberWithFloat:inputStackCount], nil];
//    
//    CIImage *op = [_kernel applyWithExtent:_inputCurrentStack.extent arguments: argmts];
//    
//    return op;
//} else {
//    return nil;
//}

@end
