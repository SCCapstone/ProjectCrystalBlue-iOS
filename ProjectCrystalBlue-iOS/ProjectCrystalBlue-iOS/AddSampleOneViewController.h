//
//  AddSampleOneViewController.h
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 3/1/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CoreLocation/CoreLocation.h"

@interface AddSampleOneViewController : UIViewController<UITextFieldDelegate, CLLocationManagerDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *KeyField;
@property (weak, nonatomic) IBOutlet UITextField *LatitudeField;
@property (weak, nonatomic) IBOutlet UITextField *LongitudeField;
@property (weak, nonatomic) IBOutlet UITextField *CollectedByField;
@property (weak, nonatomic) IBOutlet UIDatePicker *DatePicker;

- (IBAction)backgroundTapped:(id)sender;
- (IBAction)getLocation:(id)sender;
- (IBAction)viewMap:(id)sender;

@end
