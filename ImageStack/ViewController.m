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
    NSMutableArray *aligned = [self alignImages:images];
    CIImage *final = [self stackImages:aligned];
    UIImage *displayImage = [UIImage imageWithCIImage:final];
    _photoView.image = displayImage;
}

- (NSMutableArray *) readImages {
    return [NSMutableArray arrayWithObjects:[UIImage imageNamed:@"pcb_001"],
            [UIImage imageNamed:@"pcb_002"],
            [UIImage imageNamed:@"pcb_003"],
            [UIImage imageNamed:@"pcb_004"],
            [UIImage imageNamed:@"pcb_005"],
            [UIImage imageNamed:@"pcb_006"],
            [UIImage imageNamed:@"pcb_007"],
            nil];
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
    
    AverageStackingFilter *filter = [[AverageStackingFilter alloc] init];
    int i = 0;
    CIImage *finalImage;
    filter.inputCurrentStack = [alignedArray firstObject];
    filter.inputNewImage = [alignedArray firstObject];
    finalImage = filter.outputImage;
    
//    for (CIImage *image in alignedArray) {
//        if (finalImage) {
//            filter.inputCurrentStack = finalImage;
//            filter.inputNewImage = image;
//            filter.inputStackCount = i;
//            finalImage = filter.outputImage;
//        } else {
//            finalImage = image;
//        }
//        ++i;
//    }
    return finalImage;
}

@end
