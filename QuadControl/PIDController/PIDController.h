//
//  PIDController.h
//  QuadControl
//
//  Created by Sebastian Eide on 28.01.12.
//  Copyright 2012 Kle.io. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PIDController : NSObject {
  NSMutableArray * history;

  NSNumber * controlSignal;
  NSNumber * proportionalGain;
  NSNumber * integralGain;
  NSNumber * derivativeGain;
}

@property (nonatomic, retain) NSNumber * proportionalGain;
@property (nonatomic, retain) NSNumber * integralGain;
@property (nonatomic, retain) NSNumber * derivativeGain;

- (void) setControllSignal:(NSInteger) signal;
- (void) addMeasurement:(NSInteger) measurement;
@end

@protocol PIDControllerDelegate<NSObject>
- (void) pidController:(PIDController *) controller controllerOutput:(NSInteger) output;
@end
