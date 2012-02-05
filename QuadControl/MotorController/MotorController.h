//
//  MotorController.h
//  QuadControl
//
//  Created by Sebastian Eide on 04.02.12.
//  Copyright (c) 2012 Kle.io. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PIDController.h"
#import "AccelerometerController.h"
#import "MotorView.h"

@interface MotorController : NSObject 
    <PIDControllerDelegate, 
     AccelerometerControllerDelegate, 
     MotorViewDelegate> {

  PIDController * _leftRightPidController;
  PIDController * _frontBackPidController;
  
  AccelerometerController * _accelerometer;
  
  UIViewController * _viewPidController;
  
  NSInteger motorLeftFront, motorLeftBack, motorRightFront, motorRightBack;
  
  double desiredLeftRight;
  double desiredFrontBack;
}

@property (nonatomic, retain) PIDController * leftRightPidController;
@property (nonatomic, retain) PIDController * frontBackPidController;

@property (nonatomic, retain) AccelerometerController * accelerometer;
@property (nonatomic, retain) UIViewController * viewPidController;

@property (nonatomic, readonly) NSInteger motorLeftFront;
@property (nonatomic, readonly) NSInteger motorLeftBack;
@property (nonatomic, readonly) NSInteger motorRightFront;
@property (nonatomic, readonly) NSInteger motorRightBack;
@end
