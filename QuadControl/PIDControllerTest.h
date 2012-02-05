//
//  PIDControllerTest.h
//  QuadControl
//
//  Created by Sebastian Eide on 04.02.12.
//  Copyright (c) 2012 Kle.io. All rights reserved.
//

//  Logic unit tests contain unit test code that is designed to be linked into an independent test executable.
//  See Also: http://developer.apple.com/iphone/library/documentation/Xcode/Conceptual/iphone_development/135-Unit_Testing_Applications/unit_testing_applications.html

#import <SenTestingKit/SenTestingKit.h>
#import "PIDController.h"

@interface PIDControllerTest : SenTestCase <PIDControllerDelegate> {
  PIDController * pidController;
  NSNumber * _pidResult;
  BOOL _hasReceivedValue;
}

@property (nonatomic, retain) NSNumber * pidResult;

// Delegate method
- (void) pidController:(PIDController *) controller controllerOutput:(double) output;

@end
