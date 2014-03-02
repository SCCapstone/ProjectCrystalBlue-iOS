//
//  AddSampleOneViewController.h
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 3/1/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddSampleOneViewController : UIViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *KeyField;
@property (weak, nonatomic) IBOutlet UITextField *LatitudeField;
@property (weak, nonatomic) IBOutlet UITextField *LongitudeField;
@property (weak, nonatomic) IBOutlet UITextField *DateField;

- (IBAction)backgroundTapped:(id)sender;

@end
