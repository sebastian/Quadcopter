//
//  QuadControlAppDelegate.h
//  QuadControl
//
//  Created by Sebastian Eide on 10.01.12.
//  Copyright 2012 Kle.io. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MotorController.h"

@interface QuadControlAppDelegate : NSObject <UIApplicationDelegate> {
  MotorController * _motorController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end
