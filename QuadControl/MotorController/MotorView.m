//
//  MotorView.m
//  QuadControl
//
//  Created by Sebastian Eide on 05.02.12.
//  Copyright (c) 2012 Kle.io. All rights reserved.
//

#import "MotorView.h"

@implementation MotorView

@synthesize motorLeftFront;
@synthesize motorLeftBack;
@synthesize motorRightFront;
@synthesize motorRightBack;

@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
      NSLog(@"Initializing motor view");
      _black = [UIColor blackColor];
    }
    return self;
}

- (void) dealloc {
  [motorLeftFront release];
  [motorLeftBack release];
  [motorRightFront release];
  [motorRightBack release];
  [_black release];
  [super dealloc];
}

- (void) displayMotorValuesForLeftFront:(NSInteger)leftFront
                               leftBack:(NSInteger)leftBack 
                             rightFront:(NSInteger)rightFront
                              rightBack:(NSInteger)rightBack {  
  [motorLeftFront setBackgroundColor:[UIColor colorWithRed:0.0 green:leftFront/180.0 blue:0.0 alpha:1]];
  [motorLeftBack setBackgroundColor:[UIColor colorWithRed:0.0 green:leftBack/180.0 blue:0.0 alpha:1]];
  [motorRightFront setBackgroundColor:[UIColor colorWithRed:0.0 green:rightFront/180.0 blue:0.0 alpha:1]];
  [motorRightBack setBackgroundColor:[UIColor colorWithRed:0.0 green:rightBack/180.0 blue:0.0 alpha:1]];

  [motorLabelLeftFront setText:[NSString stringWithFormat:@"%i", leftFront]];
  [motorLabelLeftBack setText:[NSString stringWithFormat:@"%i", leftBack]];
  [motorLabelRightFront setText:[NSString stringWithFormat:@"%i", rightFront]];
  [motorLabelRightBack setText:[NSString stringWithFormat:@"%i", rightBack]];
}

- (void) setPidValueForLeftRight:(double) value {
  [pidLabelLeftRight setText:[NSString stringWithFormat:@"%f", value]];
}
- (void) setPidValueForFrontBack:(double) value {
  [pidLabelFrontBack setText:[NSString stringWithFormat:@"%f", value]];
}


- (IBAction)changePSliderValue:(UISlider*)sender {[self.delegate setPValue:[sender value]];}
- (IBAction)changeISliderValue:(UISlider*)sender {[self.delegate setIValue:[sender value]];}
- (IBAction)changeDSliderValue:(UISlider*)sender {[self.delegate setDValue:[sender value]];}

@end
