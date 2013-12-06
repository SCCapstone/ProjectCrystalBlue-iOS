//
//  EditTaskViewController.h
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 12/4/13.
//  Copyright (c) 2013 Project Crystal Blue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SampleListViewController.h"

@class Sample;

@interface EditTaskViewController : UITableViewController

@property (nonatomic, strong) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UITextField *rocktypeField;
@property (strong, nonatomic) IBOutlet UITextField *locationField;
@property (strong, nonatomic) IBOutlet UITextField *isPulverizedField;
@property (nonatomic, strong) Sample *sample;

@property (nonatomic, strong) SampleListViewController *sampleListViewController;

- (IBAction)sampleDataChanged:(id)sender;

@end
