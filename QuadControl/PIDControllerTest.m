//
//  PIDControllerTest.m
//  QuadControl
//
//  Created by Sebastian Eide on 04.02.12.
//  Copyright (c) 2012 Kle.io. All rights reserved.
//

#import "PIDControllerTest.h"

@implementation PIDControllerTest

@synthesize pidResult = _pidResult;

// PIDController delegate method
- (void) pidController:(PIDController *) controller controllerOutput:(double) output {
  [self setPidResult:[NSNumber numberWithDouble:output]];
  _hasReceivedValue = YES;
}

- (void)setUp
{
  [super setUp];
  pidController = [[[PIDController alloc] init] retain];
  [pidController setDelegate:self];
  [self setPidResult:[NSNumber numberWithFloat:0.0]];
  _hasReceivedValue = NO;
}

- (void)tearDown
{
  [pidController release];
  [self setPidResult:nil];
  [super tearDown];
}

- (void) assertThat:(double) val isWithinEpsilon:(double)eps of:(double)realVal withMessage:(NSString*)msg {
  STAssertTrue(val < realVal + eps, @"Value should not exceed realValue + eps, %@", msg);
  STAssertTrue(val > realVal - eps, @"Value should not be less than realValue - eps, %@", msg);
}

- (void)testShouldPassChangesBackToDelegate {
  // Upon receiving a measurement, it should compute an output, and
  // send it to the delegate.
  [pidController setControlSignal:[NSNumber numberWithFloat:1.0]];
  [pidController addMeasurement:[NSNumber numberWithFloat:0.0]];
  STAssertTrue(_hasReceivedValue, @"Should have received an output from the PIDController");
}

- (void) testPController {
  // We only want proportional gain
  [pidController setDerivativeGain:[NSNumber numberWithFloat:0.0]];
  [pidController setIntegralGain:[NSNumber numberWithFloat:0.0]];
  [pidController setProportionalGain:[NSNumber numberWithFloat:1.0]];

  [pidController setControlSignal:[NSNumber numberWithFloat:1.0]];
  [pidController addMeasurement:[NSNumber numberWithFloat:0.0]];

  // There is an error of 1.
  // We have a proportional gain of 1.
  // Hence the output should be somewhat close to 1 :D
  STAssertTrue(_hasReceivedValue, @"Should have received an output from the PIDController");
  double result = [_pidResult doubleValue];
  [self assertThat:result isWithinEpsilon:0.001 of:1 withMessage:@"testing PController"];
  
  // We now want to ensure that the history does not affect the proportional
  // controller.
  [pidController setNumberOfTermsInHistory:5];
  [pidController addMeasurement:[NSNumber numberWithFloat:1.0]];
  [pidController addMeasurement:[NSNumber numberWithFloat:1.0]];
  [pidController addMeasurement:[NSNumber numberWithFloat:1.0]];
  [pidController addMeasurement:[NSNumber numberWithFloat:1.0]];
  [pidController addMeasurement:[NSNumber numberWithFloat:1.0]];
  [pidController addMeasurement:[NSNumber numberWithFloat:1.0]];

  // We have saturdated the history
  [pidController addMeasurement:[NSNumber numberWithFloat:0.0]];
  result = [_pidResult doubleValue];
  [self assertThat:result isWithinEpsilon:0.001 of:1 withMessage:@"testing pController"];
}

- (void) testDController {
  // We only want derivative gain
  [pidController setDerivativeGain:[NSNumber numberWithFloat:1.0]];
  [pidController setIntegralGain:[NSNumber numberWithFloat:0.0]];
  [pidController setProportionalGain:[NSNumber numberWithFloat:0.0]];
  
  [pidController setControlSignal:[NSNumber numberWithFloat:1.0]];
  [pidController setDt:1.0/100];

  // The derivative needs two measurements in order to calculate
  // a change in gradient
  [pidController addMeasurement:[NSNumber numberWithFloat:1.0]];
  [pidController addMeasurement:[NSNumber numberWithFloat:0.0]];
  
  // We have a change in error of 1 between the two last measurements.
  // dt is set to be 10 ms, hence the output should be: 100
  STAssertTrue(_hasReceivedValue, @"Should have received an output from the PIDController");
  double result = [_pidResult doubleValue];
  [self assertThat:result isWithinEpsilon:0.001 of:100 withMessage:@"testing DController"];
  
  // We now want to ensure that a logner history does not affect the
  // derivative controller
  [pidController setNumberOfTermsInHistory:5];
  [pidController addMeasurement:[NSNumber numberWithFloat:0.0]];
  [pidController addMeasurement:[NSNumber numberWithFloat:0.0]];
  [pidController addMeasurement:[NSNumber numberWithFloat:0.0]];
  [pidController addMeasurement:[NSNumber numberWithFloat:0.0]];
  [pidController addMeasurement:[NSNumber numberWithFloat:0.0]];
  [pidController addMeasurement:[NSNumber numberWithFloat:0.0]];
  [pidController addMeasurement:[NSNumber numberWithFloat:1.0]];
  
  // We have saturdated the history
  [pidController addMeasurement:[NSNumber numberWithFloat:0.0]];
  result = [_pidResult doubleValue];
  [self assertThat:result isWithinEpsilon:0.001 of:100 withMessage:@"testing DController1"];

  [pidController addMeasurement:[NSNumber numberWithFloat:1.0]];
  result = [_pidResult doubleValue];
  [self assertThat:result isWithinEpsilon:0.001 of:-100 withMessage:@"testing DController2"];
}

- (void) testIController {
  // We only want integral gain
  [pidController setDerivativeGain:[NSNumber numberWithFloat:0.0]];
  [pidController setIntegralGain:[NSNumber numberWithFloat:1.0]];
  [pidController setProportionalGain:[NSNumber numberWithFloat:0.0]];
  
  [pidController setControlSignal:[NSNumber numberWithFloat:1.0]];
  
  // The integral controller needs at least two measurements in order
  // to generate output.
  [pidController setDt:10.0/1000];
  
  [pidController addMeasurement:[NSNumber numberWithFloat:1.0]];
  [pidController addMeasurement:[NSNumber numberWithFloat:0.5]];
  
  // We have two points.
  // 1: 1.0 (error 0)
  // 2: 0.5 (error 0.5)
  // That is an area of dt * 0.5 + (dt * 0.5 / 2)
  // dt is set to be 10 ms, so the value should be: 0.0025
  STAssertTrue(_hasReceivedValue, @"Should have received an output from the PIDController");
  double result = [_pidResult doubleValue];
  [self assertThat:result isWithinEpsilon:0.0001 of:0.0025 withMessage:@"Testing IController"];  
}

- (void) testIControllerForValuesCrossingXAxis {
  // We only want integral gain
  [pidController setDerivativeGain:[NSNumber numberWithFloat:0.0]];
  [pidController setIntegralGain:[NSNumber numberWithFloat:1.0]];
  [pidController setProportionalGain:[NSNumber numberWithFloat:0.0]];
  
  [pidController setControlSignal:[NSNumber numberWithFloat:0.0]];
  
  // The integral controller needs at least two measurements in order
  // to generate output.
  [pidController setDt:10.0/1000];
  
  [pidController addMeasurement:[NSNumber numberWithFloat:1.0]];
  [pidController addMeasurement:[NSNumber numberWithFloat:-1.0]];
  
  // This is a value that crosses the x-axis, so we expect the output
  // to be zero.
  STAssertTrue(_hasReceivedValue, @"Should have received an output from the PIDController");
  double result = [_pidResult doubleValue];
  [self assertThat:result isWithinEpsilon:0.0001 of:0.0 withMessage:@"Testing IController for value crossing the x-axis"];  
}

- (void) testIControllerForNegativeValues {
  // We only want integral gain
  [pidController setDerivativeGain:[NSNumber numberWithFloat:0.0]];
  [pidController setIntegralGain:[NSNumber numberWithFloat:1.0]];
  [pidController setProportionalGain:[NSNumber numberWithFloat:0.0]];
  
  [pidController setControlSignal:[NSNumber numberWithFloat:0.0]];
  
  // The integral controller needs at least two measurements in order
  // to generate output.
  [pidController setDt:10.0/1000];
  
  [pidController addMeasurement:[NSNumber numberWithFloat:-1.0]];
  [pidController addMeasurement:[NSNumber numberWithFloat:-0.5]];
  
  STAssertTrue(_hasReceivedValue, @"Should have received an output from the PIDController");
  double result = [_pidResult doubleValue];
  [self assertThat:result isWithinEpsilon:0.0001 of:0.0075 withMessage:@"Testing IController for value crossing the x-axis"];  
}

- (void) testIControllerForMultipleValues {
  // We only want integral gain
  [pidController setDerivativeGain:[NSNumber numberWithFloat:0.0]];
  [pidController setIntegralGain:[NSNumber numberWithFloat:1.0]];
  [pidController setProportionalGain:[NSNumber numberWithFloat:0.0]];
  
  [pidController setControlSignal:[NSNumber numberWithFloat:0.0]];
  
  // The integral controller needs at least two measurements in order
  // to generate output.
  [pidController setDt:10.0/1000];
  
  [pidController addMeasurement:[NSNumber numberWithFloat:1.0]];
  [pidController addMeasurement:[NSNumber numberWithFloat:0.5]];
  [pidController addMeasurement:[NSNumber numberWithFloat:2.0]];
  
  STAssertTrue(_hasReceivedValue, @"Should have received an output from the PIDController");
  double result = [_pidResult doubleValue];
  [self assertThat:result isWithinEpsilon:0.0001 of:-0.02 withMessage:@"Testing IController for multiple values"];  
}

@end
