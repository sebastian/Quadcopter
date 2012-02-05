//
//  AccelerometerController.h
//  QuadControl
//
//  Created by Sebastian Probst Eide on 28.01.12.
//  Copyright 2012 Kle.io. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol AccelerometerControllerDelegate;

@interface AccelerometerController : NSObject <UIAccelerometerDelegate> {
  UIAccelerationValue accelerationX;
  UIAccelerationValue accelerationY;
  UIAccelerationValue accelerationZ;
  
  id<AccelerometerControllerDelegate> _delegate;
}

@property (nonatomic, assign) id<AccelerometerControllerDelegate> delegate;
@end

@protocol AccelerometerControllerDelegate<NSObject>
- (void) accelerometerController:(AccelerometerController *) controller 
                               x:(UIAccelerationValue) x
                               y:(UIAccelerationValue) y
                               z:(UIAccelerationValue) z;
@end
