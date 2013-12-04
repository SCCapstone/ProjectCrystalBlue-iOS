//
//  AddSampleViewController.h
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 12/4/13.
//  Copyright (c) 2013 Project Crystal Blue. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SampleListViewController;

@interface AddSampleViewController : UITableViewController

- (IBAction)canceLButtonPressed:(id)sender;
- (IBAction)nextButtonPressed:(id)sender;

@property (nonatomic, strong) IBOutlet UITextField *nameField;
@property (nonatomic, strong) SampleListViewController *sampleListViewController;

@end
