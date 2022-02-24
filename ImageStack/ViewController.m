//
//  ViewController.m
//  ImageStack
//
//  Created by Sumit Chaudhary on 17/02/22.
//

#import "ViewController.h"
#import <CoreImage/CoreImage.h>
#import <Vision/Vision.h>
#import "AverageStackingFilter.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *photoView;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSMutableArray *images = [self readImages];
    UIImage *displayImage = [self focusStackImages:images];
    _photoView.image = displayImage;
}

- (NSMutableArray *) readImages {
    return [NSMutableArray arrayWithObjects:[UIImage imageNamed:@"IMG-188"],
            [UIImage imageNamed:@"IMG-189"],
            nil];
}

- (UIImage *) focusStackImages: (NSMutableArray *) images {
    NSMutableArray *aligned = [self alignImages:images];
    CIImage *final = [self stackImages:aligned];
    return [UIImage imageWithCIImage:final];
}

- (NSMutableArray *) alignImages: (NSMutableArray *)imageArray {
    NSMutableArray *alignedArray = [[NSMutableArray alloc] init];
    CIImage *firstImage;
    CIImage *current;
    
    for (UIImage *photo in imageArray) {
        if (firstImage) {
            current =  [[CIImage alloc] initWithImage:photo];
            
            VNTranslationalImageRegistrationRequest *req = [[VNTranslationalImageRegistrationRequest alloc] initWithTargetedCIImage:current options: [NSDictionary dictionary]];
            
            @try  {
                VNSequenceRequestHandler *handler = [[VNSequenceRequestHandler alloc] init];
                NSError *error;
                [handler performRequests: [NSArray arrayWithObject:req]  onCIImage:firstImage error: &error];
                
            } @catch (NSError *error) {
                  NSLog(@"%@ ", error.domain);
            }
            
            if (req.results) {
                VNImageTranslationAlignmentObservation *opern = req.results.firstObject;
                if (opern) {
                    CIImage *alignedImage = [current imageByApplyingTransform: opern.alignmentTransform];
                    [alignedArray addObject: alignedImage];
                }
            }
        } else {
            firstImage = [[CIImage alloc] initWithImage:photo];
            [alignedArray addObject: firstImage];
        }
    }
    
    return alignedArray;
}

- (CIImage *) stackImages: (NSMutableArray *)alignedArray {
    
    AverageStackingFilter *filter = [[AverageStackingFilter alloc] initWithFname:@"gaussianImage"];
    filter.inputStackCount = 1;
    AverageStackingFilter *filter2 = [[AverageStackingFilter alloc] initWithFname:@"lofGauss"];
    filter2.inputStackCount = 1;
    AverageStackingFilter *filter3 = [[AverageStackingFilter alloc] initWithFname:@"compareStacking"];
    filter3.inputStackCount = -1;

    int i = 0;
    CIImage *finalImage;
    
    for (CIImage *image in alignedArray) {
        if (finalImage) {
            filter.inputCurrentStack = finalImage;
            filter2.inputCurrentStack = filter.outputImage;
            CIImage * firstX = filter2.outputImage;
            
            filter.inputCurrentStack = image;
            filter2.inputCurrentStack = filter.outputImage;
            CIImage * secX = filter2.outputImage;
            
            filter3.inputCurrentStack = firstX;
            filter3.inputNewImage = secX;
            filter3.inputBase1 = finalImage;
            filter3.inputBase2 = image;
            
            finalImage = filter3.outputImage;
        } else {
            finalImage = image;
        }
        ++i;
    }
    
    //filter.inputCurrentStack = finalImage;
    return finalImage;
}

@end
