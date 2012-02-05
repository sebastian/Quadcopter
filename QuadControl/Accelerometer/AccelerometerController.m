//
//  AccelerometerController.m
//  QuadControl
//
//  Created by Sebastian Probst Eide on 28.01.12.
//  Copyright 2012 Kle.io. All rights reserved.
//

#import "AccelerometerController.h"

#define kUpdateFrequency 1000  // Hz

@implementation AccelerometerController

@synthesize delegate = _delegate;

#pragma mark -
#pragma mark === Setup and teardown ===
#pragma mark -
- (id)init
{
  if (self = [super init]) {
    // Set self to be the accelerometer delegate
    UIAccelerometer * acc = [UIAccelerometer sharedAccelerometer];
    [acc setUpdateInterval:(1.0 / kUpdateFrequency)];
    [acc setDelegate:self];
  }
  return self;
}

#pragma mark -
#pragma mark === Receiving changes in acceleration ===
#pragma mark -
// UIAccelerometer delegate method, which delivers the latest acceleration data.
- (void)accelerometer:(UIAccelerometer *)accelerometer didAccelerate:(UIAcceleration *)acceleration {
  accelerationX = acceleration.x;
  accelerationY = acceleration.y;
  accelerationZ = acceleration.z;
  
  [self.delegate accelerometerController:self x:accelerationX y:accelerationY z:accelerationZ];
}


@end
