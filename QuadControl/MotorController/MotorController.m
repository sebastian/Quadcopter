//
//  MotorController.m
//  QuadControl
//
//  Created by Sebastian Eide on 04.02.12.
//  Copyright (c) 2012 Kle.io. All rights reserved.
//

#import "MotorController.h"
#import "MotorView.h"

#define MAX_MOTOR_VALUE 180
#define MIN_MOTOR_VALUE 0
#define FACTOR_INCREASE 10
#define AVOID_ROUNDING_FACTOR 1000
#define TEN_MS 1.0/100

@implementation MotorController

@synthesize leftRightPidController = _leftRightPidController;
@synthesize frontBackPidController = _frontBackPidController;

@synthesize accelerometer = _accelerometer;

@synthesize viewPidController = _viewPidController;

@synthesize motorLeftFront;
@synthesize motorLeftBack;
@synthesize motorRightFront;
@synthesize motorRightBack;

- (id)init {
  if (self = [super init]) {
    desiredLeftRight = 0.0;
    desiredFrontBack = 0.0;
    
    _leftRightPidController = [[[PIDController alloc] init] retain];
    _frontBackPidController = [[[PIDController alloc] init] retain];
    
    [_leftRightPidController setDelegate:self];
    [_frontBackPidController setDelegate:self];

    [_leftRightPidController setDt:TEN_MS];
    [_frontBackPidController setDt:TEN_MS];

    [_leftRightPidController setControlSignal:[NSNumber numberWithDouble:desiredLeftRight]];
    [_frontBackPidController setControlSignal:[NSNumber numberWithDouble:desiredFrontBack]];

    [_leftRightPidController setNumberOfTermsInHistory:10];
    [_frontBackPidController setNumberOfTermsInHistory:10];
    
    motorLeftFront = 0;
    motorLeftBack = 0;
    motorRightFront = 0;
    motorRightBack = 0;
      
    self.viewPidController = [[[UIViewController alloc] initWithNibName:@"MotorView" bundle:Nil] autorelease];
    MotorView * view = (MotorView*) self.viewPidController.view;
    [view setDelegate:self];
    
    _accelerometer = [[[AccelerometerController alloc] init] retain];
    [self.accelerometer setDelegate:self];
  }
  return self;
}

- (void) dealloc {
  [_leftRightPidController release];
  [_frontBackPidController release];
  [_accelerometer release];
  [_viewPidController release];
  [super dealloc];
}

- (int) getValidMotorValueForCurrent:(int) currentMotorValue
                       desiredChange:(double) desiredChange {
  int desiredNewValue = currentMotorValue + desiredChange;
  if (desiredNewValue > MAX_MOTOR_VALUE * AVOID_ROUNDING_FACTOR) {
    return MAX_MOTOR_VALUE * AVOID_ROUNDING_FACTOR;
  } else if (desiredNewValue < MIN_MOTOR_VALUE * AVOID_ROUNDING_FACTOR) {
    return MIN_MOTOR_VALUE * AVOID_ROUNDING_FACTOR;
  } else {
    return desiredNewValue;
  }
}

// AccelerometerControllerDelegate method
- (void) accelerometerController:(AccelerometerController *) controller 
                               x:(UIAccelerationValue) x
                               y:(UIAccelerationValue) y
                               z:(UIAccelerationValue) z {
  [self.leftRightPidController addMeasurement:[NSNumber numberWithDouble:x]];
  [self.frontBackPidController addMeasurement:[NSNumber numberWithDouble:y]];
}

// PIDControllerDelegate method
- (void) pidController:(PIDController *) controller controllerOutput:(double) output {
  double side1 = AVOID_ROUNDING_FACTOR * FACTOR_INCREASE * output * 0.5;
  double side2 = (-1) * side1;
  
  if (controller == _leftRightPidController) {
    // Left side
    motorLeftFront = [self getValidMotorValueForCurrent:motorLeftFront desiredChange:side1];
    motorLeftBack = [self getValidMotorValueForCurrent:motorLeftBack desiredChange:side1];
    // Right side
    motorRightFront = [self getValidMotorValueForCurrent:motorRightFront desiredChange:side2];
    motorRightBack = [self getValidMotorValueForCurrent:motorRightBack desiredChange:side2];
  } else if (controller == _frontBackPidController) {
    // Back
    motorLeftBack = [self getValidMotorValueForCurrent:motorLeftBack desiredChange:side1];
    motorRightBack = [self getValidMotorValueForCurrent:motorRightBack desiredChange:side1];    
    // Front
    motorLeftFront = [self getValidMotorValueForCurrent:motorLeftFront desiredChange:side2];
    motorRightFront = [self getValidMotorValueForCurrent:motorRightFront desiredChange:side2];
  }
  MotorView * view = (MotorView*) _viewPidController.view;
  [view displayMotorValuesForLeftFront:motorLeftFront / AVOID_ROUNDING_FACTOR
                              leftBack:motorLeftBack / AVOID_ROUNDING_FACTOR
                            rightFront:motorRightFront / AVOID_ROUNDING_FACTOR
                             rightBack:motorRightBack / AVOID_ROUNDING_FACTOR];  
  
  if (controller == _leftRightPidController) {
    [view setPidValueForLeftRight:output];
  } else if (controller == _frontBackPidController) {
    [view setPidValueForFrontBack:output];
  }
}

- (void) setPValue:(double)val {
  [self.leftRightPidController setProportionalGain:[NSNumber numberWithDouble:val]];
  [self.frontBackPidController setProportionalGain:[NSNumber numberWithDouble:val]];
}
- (void) setIValue:(double)val {
  [self.leftRightPidController setIntegralGain:[NSNumber numberWithDouble:val]];
  [self.frontBackPidController setIntegralGain:[NSNumber numberWithDouble:val]];  
}
- (void) setDValue:(double)val {
  [self.leftRightPidController setDerivativeGain:[NSNumber numberWithDouble:val]];
  [self.frontBackPidController setDerivativeGain:[NSNumber numberWithDouble:val]];  
}

@end
