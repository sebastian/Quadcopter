//
//  QuadControlAppDelegate.h
//  QuadControl
//
//  Created by Sebastian Eide on 10.01.12.
//  Copyright 2012 Kle.io. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccelerometerController.h"
#import "PIDController.h"

@class QuadControlViewController;

@interface QuadControlAppDelegate : NSObject <UIApplicationDelegate> {
  AccelerometerController * _accelerometer;
  PIDController * _pidController;
}

@property (nonatomic, retain) AccelerometerController * accelerometer;
@property (nonatomic, retain) PIDController * pidController;

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet QuadControlViewController *viewController;

@end
