//
//  SampleEditViewController.h
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 2/15/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Sample.h"

@interface SampleEditViewController : UITableViewController <UINavigationControllerDelegate>

@property (nonatomic, strong) Sample *sample;

-(id)initWithSample:(Sample *)initSample;

@end
