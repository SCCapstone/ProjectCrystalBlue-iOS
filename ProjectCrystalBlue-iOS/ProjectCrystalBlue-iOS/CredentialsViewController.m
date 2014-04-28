//
//  CredentialsViewController.m
//  ProjectCrystalBlue-iOS
//
//  Created by Logan Hood on 4/17/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "CredentialsViewController.h"
#import "LocalEncryptedCredentialsProvider.h"
#import "AbstractCloudLibraryObjectStore.h"
#import "PCBLogWrapper.h"

@interface CredentialsViewController ()

@end

NSString *firstTimeInstructions =
@"It appears this is your first time running the application on this device. Please enter your AWS \
credentials below. You can obtain these credentials from your lab administrator. Please also \
provide a local passcode - you will need to enter this passcode everytime you open the program.\n\
\nIf you do not wish to utilize the cloud syncing functionality, you can skip this step and run \
the program locally.";

NSString *standardInstructions =
@"Please enter your local passcode to obtain saved AWS Credentials, or enter new AWS credentials\
and a new local passcode to overwrite the saved credentials file.";

NSString *passwordError =
@"Couldn't retrieve credentials. Did you enter an incorrect passcode?";

@implementation CredentialsViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([[LocalEncryptedCredentialsProvider sharedInstance] credentialsStoreFileExists]) {
        [self.instructionsDisplay setText:standardInstructions];
    } else {
        [self.instructionsDisplay setText:firstTimeInstructions];
    }
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)okButtonPressed:(id)sender {
    if (self.awsAccessKeyField.text.length > 0 &&
        self.awsSecretKeyField.text.length > 0)
    {
        AmazonCredentials *credentials;
        credentials = [[AmazonCredentials alloc] initWithAccessKey:self.awsAccessKeyField.text
                                                     withSecretKey:self.awsSecretKeyField.text];
        [[LocalEncryptedCredentialsProvider sharedInstance] storeCredentials:credentials
                                                                     withKey:self.localKeyField.text];
    }
    AmazonCredentials *retrieved;
    retrieved = [[LocalEncryptedCredentialsProvider sharedInstance] retrieveCredentialsWithKey:self.localKeyField.text];
    if (retrieved) {
        [self.dataStore setupDomains];
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.instructionsDisplay setText:passwordError];
        [self.instructionsDisplay setTextColor:[UIColor orangeColor]];
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField endEditing:YES];
    return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField {
    return YES;
}

- (IBAction)backgroundTapped:(id)sender {
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
