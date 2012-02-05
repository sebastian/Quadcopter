//
//  PIDController.h
//  QuadControl
//
//  Created by Sebastian Eide on 28.01.12.
//  Copyright 2012 Kle.io. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PIDControllerDelegate;

@interface PIDController : NSObject {
  NSMutableArray * _history;

  // The value we want the output to have
  NSNumber * _controlSignal;
  
  // Amount of gain the different components
  // of the PID controller should have.
  NSNumber * _proportionalGain;
  NSNumber * _integralGain;
  NSNumber * _derivativeGain;
  
  // The numbers of terms we should keep.
  // This corresponds to dt  in the 
  // integration term of the PID controller.
  // Since we have discrete input measurements,
  // we also keep a discrete number of previous
  // measurements.
  NSInteger _numberOfTermsInHistory;
  
  // The delegate of this class.
  // The class the gets the output changes
  // fed into it.
  id<PIDControllerDelegate> _delegate;
  
  // The time between measurements in seconds;
  double _dt;
}

@property (nonatomic, assign) id<PIDControllerDelegate> delegate;

@property (nonatomic, retain) NSNumber * proportionalGain;
@property (nonatomic, retain) NSNumber * integralGain;
@property (nonatomic, retain) NSNumber * derivativeGain;
@property (nonatomic, retain) NSNumber * controlSignal;
@property (nonatomic, assign) NSInteger numberOfTermsInHistory;
@property (nonatomic, assign) double dt;

- (void) addMeasurement:(NSNumber *) measurement;
@end

@protocol PIDControllerDelegate<NSObject>
- (void) pidController:(PIDController *) controller controllerOutput:(double) output;
@end
