//
//  MotorView.h
//  QuadControl
//
//  Created by Sebastian Eide on 05.02.12.
//  Copyright (c) 2012 Kle.io. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MotorViewDelegate;

@interface MotorView : UIView {
  IBOutlet UIView * motorLeftFront;
  IBOutlet UIView * motorLeftBack;
  IBOutlet UIView * motorRightFront;
  IBOutlet UIView * motorRightBack;
  
  UIColor * _black;
  
  id<MotorViewDelegate> _delegate;
}
@property (nonatomic, retain) UIView * motorLeftFront;
@property (nonatomic, retain) UIView * motorLeftBack;
@property (nonatomic, retain) UIView * motorRightFront;
@property (nonatomic, retain) UIView * motorRightBack;

@property (nonatomic, assign) id<MotorViewDelegate> delegate;

- (void) displayMotorValuesForLeftFront:(NSInteger)leftFront
                               leftBack:(NSInteger)leftBack 
                             rightFront:(NSInteger)rightFront
                              rightBack:(NSInteger)rightBack;

- (IBAction)changePSliderValue:(UISlider*)sender;
- (IBAction)changeISliderValue:(UISlider*)sender;
- (IBAction)changeDSliderValue:(UISlider*)sender;
@end

@protocol MotorViewDelegate <NSObject>
- (void) setPValue:(double)val;
- (void) setIValue:(double)val;
- (void) setDValue:(double)val;
@end