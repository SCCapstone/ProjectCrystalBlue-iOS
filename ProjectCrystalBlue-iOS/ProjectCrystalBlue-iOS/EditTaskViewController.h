//
//  EditTaskViewController.h
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 12/4/13.
//  Copyright (c) 2013 Project Crystal Blue. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Sample;

@interface EditTaskViewController : UITableViewController

@property (nonatomic, strong) IBOutlet UITextField *nameField;
@property (nonatomic, strong) Sample *sample;

- (IBAction)sampleDataChanged:(id)sender;

@end
