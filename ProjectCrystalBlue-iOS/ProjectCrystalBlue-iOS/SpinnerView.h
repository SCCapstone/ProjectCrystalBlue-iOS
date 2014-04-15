//
//  SpinnerView.h
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 4/14/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpinnerView : UIView

+(SpinnerView *)loadSpinnerIntoView:(UIView *)superView;
-(void)removeSpinner;

@end
