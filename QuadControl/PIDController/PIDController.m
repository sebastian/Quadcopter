//
//  PIDController.m
//  QuadControl
//
//  Created by Sebastian Eide on 28.01.12.
//  Copyright 2012 Kle.io. All rights reserved.
//

#import "PIDController.h"

@implementation PIDController

@synthesize proportionalGain;
@synthesize integralGain;
@synthesize derivativeGain;

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

@end
