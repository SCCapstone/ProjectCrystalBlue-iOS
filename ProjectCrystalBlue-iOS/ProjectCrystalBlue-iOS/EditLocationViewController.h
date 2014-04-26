//
//  EditLocationViewController.h
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 3/4/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Split.h"

@interface EditLocationViewController : UIViewController

@property (nonatomic, strong) Split *selectedSplit;
@property (weak, nonatomic) IBOutlet UITextField *LocationField;

- (id)initWithSplit:(Split *) initSplit;
- (IBAction)updateLocation:(id)sender;
- (IBAction)cancel:(id)sender;

@end
