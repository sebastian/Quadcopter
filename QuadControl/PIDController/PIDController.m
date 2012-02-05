//
//  PIDController.m
//  QuadControl
//
//  Created by Sebastian Eide on 28.01.12.
//  Copyright 2012 Kle.io. All rights reserved.
//

#import "PIDController.h"

@implementation PIDController

// For setting gain of the different components of the
// PID controller
@synthesize proportionalGain = _proportionalGain;
@synthesize integralGain = _intergralGain;
@synthesize derivativeGain = _derivativeGain;

// Setting the desired value
@synthesize controlSignal = _controlSignal;

// How many big a history measurement should we keep?
@synthesize numberOfTermsInHistory = _numberOfTermsInHistory;

@synthesize delegate = _delegate;

@synthesize dt = _dt;

- (id)init {
  if (self = [super init]) {
    _controlSignal = [[NSNumber numberWithFloat:0.0] retain];
    _proportionalGain = [[NSNumber numberWithFloat:0.0] retain];
    _integralGain = [[NSNumber numberWithFloat:0.0] retain];
    _derivativeGain = [[NSNumber numberWithFloat:0.0] retain];

    // From the assumption that the default configuration
    // only uses a derivative gain, then we don't need
    // more than one history term either.
    _numberOfTermsInHistory = (NSInteger) 10;
    
    // dt defaults to 10 milliseconds
    _dt = 1.0 / 100;
    
    _history = [[NSMutableArray arrayWithCapacity:_numberOfTermsInHistory] retain];
  }
  return self;
}

- (double) computeProportionalOutput {
  double lastError = [[_history lastObject] doubleValue];
  return lastError * [_proportionalGain doubleValue];
}

- (double) computeDerivativeOutput {
  NSInteger numHistoryItems = [_history count];
  if (numHistoryItems > 1) {
    double lastError = [[_history lastObject] doubleValue];
    double secondToLast = [[_history objectAtIndex:(numHistoryItems - 2)] doubleValue];
    double difference = lastError - secondToLast;    
    return (difference / _dt) * [_derivativeGain doubleValue];
  } else {
    // We don't have enough datapoints to calculate this value
    return 0.0;
  } 
}

- (double) computeIntegralOutput {
  NSInteger numHistoryItems = [_history count];
  if (numHistoryItems > 1) {
    double result = 0.0;
    for (int i = 0; i < numHistoryItems - 1; i++) {
      double startPoint = [[_history objectAtIndex:i] doubleValue];
      double endPoint = [[_history objectAtIndex:i+1] doubleValue];
      // TODO(fjab): Do as simple math as possible
      // result += areaUnderCurveBetweenStartAndEnd
    }
    return result * [_integralGain doubleValue];  
  } else {
    // We don't have enough datapoints to calculate this value
    return 0.0;
  } 
}

- (void) compute {
  double proportionalOutput = [self computeProportionalOutput];
  double derivativeOutput = [self computeDerivativeOutput];
  double integralOutput = [self computeIntegralOutput];
  double output = proportionalOutput + derivativeOutput + integralOutput;
  [_delegate pidController:self controllerOutput:output];
}

- (void) addMeasurement:(NSNumber *) measurement {
  double currentMeasurement = [measurement doubleValue];
  double controlSignal = [_controlSignal doubleValue];
  double error = controlSignal - currentMeasurement;
  [_history addObject:[NSNumber numberWithDouble:error]];

  NSUInteger size = [_history count];
  // If we have reached the number of objects we are allowed to store,
  // then remove one object from the beginning of the array.
  if (size > _numberOfTermsInHistory) {[_history removeObjectAtIndex:0];}
  
  [self compute];
}
@end
