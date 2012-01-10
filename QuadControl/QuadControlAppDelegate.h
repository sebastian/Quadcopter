//
//  QuadControlAppDelegate.h
//  QuadControl
//
//  Created by Sebastian Eide on 10.01.12.
//  Copyright 2012 Kle.io. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QuadControlViewController;

@interface QuadControlAppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet QuadControlViewController *viewController;

@end
