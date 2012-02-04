//
//  AccelerometerController.h
//  QuadControl
//
//  Created by Sebastian Probst Eide on 28.01.12.
//  Copyright 2012 Kle.io. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AccelerometerController : NSObject <UIAccelerometerDelegate> {
  UIAccelerationValue accelerationX;
  UIAccelerationValue accelerationY;
  UIAccelerationValue accelerationZ;
}
@end
