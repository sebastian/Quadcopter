//
//  QuadControlAppDelegate.m
//  QuadControl
//
//  Created by Sebastian Eide on 10.01.12.
//  Copyright 2012 Kle.io. All rights reserved.
//

#import "QuadControlAppDelegate.h"

#import "QuadControlViewController.h"

@implementation QuadControlAppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize accelerometer = _accelerometer;
@synthesize pidController = _pidController;

#pragma mark -
#pragma mark === Setup and teardown ===
#pragma mark -
- (id)init
{
  if (self = [super init]) {
    AccelerometerController * acc = 
        [[[AccelerometerController alloc] init] autorelease];
    [self setAccelerometer: acc];

    PIDController * pidController =
        [[[PIDController alloc] init] autorelease];
    [self setPidController:pidController];
  }
  return self;
}

- (void) dealloc {
  [_accelerometer release];
  [_pidController release];
  [_window release];
  [_viewController release];
  [_accelerometer release];
  [super dealloc];
}

#pragma mark -
#pragma mark === Standard stuff ===
#pragma mark -
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{   
  self.window.rootViewController = self.viewController;
  [self.window makeKeyAndVisible];
  return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
  /*
   Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
   Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
   */
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
  /*
   Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
   If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
   */
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
  /*
   Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
   */
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
  /*
   Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
   */
}

- (void)applicationWillTerminate:(UIApplication *)application
{
  /*
   Called when the application is about to terminate.
   Save data if appropriate.
   See also applicationDidEnterBackground:.
   */
}

@end
