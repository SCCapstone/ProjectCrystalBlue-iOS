//
//  CredentialsViewController.h
//  ProjectCrystalBlue-iOS
//
//  Created by Logan Hood on 4/17/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AbstractCloudLibraryObjectStore;

@interface CredentialsViewController : UIViewController <UITextFieldDelegate>

@property (weak) IBOutlet UITextField *awsAccessKeyField;
@property (weak) IBOutlet UITextField *awsSecretKeyField;
@property (weak) IBOutlet UITextField *localKeyField;
@property (weak) IBOutlet UITextView  *instructionsDisplay;
@property AbstractCloudLibraryObjectStore *dataStore;

- (IBAction)cancelButtonPressed:(id)sender;
- (IBAction)okButtonPressed:(id)sender;
- (IBAction)backgroundTapped:(id)sender;

@end
