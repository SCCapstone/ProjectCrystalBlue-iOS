//
//  EditLocationViewController.m
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 3/4/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "EditLocationViewController.h"
#import "SimpleDBLibraryObjectStore.h"
#import "SampleEditViewController.h"
#import "Sample.h"
#import "SampleConstants.h"
#import "Procedures.h"
#import "SampleFieldValidator.h"

@interface EditLocationViewController ()
{
    SimpleDBLibraryObjectStore *libraryObjectStore;
    NSString *newLocation;
    Sample *editedSample;
}

@end

@implementation EditLocationViewController
@synthesize selectedSample, LocationField;

- (id)initWithSample:(Sample *) initSample
{
    self = [super init];
    if (self) {
        selectedSample = initSample;
        libraryObjectStore = [[SimpleDBLibraryObjectStore alloc] initInLocalDirectory:@"ProjectCrystalBlue/Data"           WithDatabaseName:@"test_database.db"];
        
        UINavigationItem *n = [self navigationItem];
        [n setTitle:@"Change Sample Location"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)updateLocation:(id)sender
{
    if (![self validateTextFieldValues])
    {
        return;
    }
    newLocation = [LocationField text];
    [Procedures moveSample:selectedSample toLocation:newLocation inStore:libraryObjectStore];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cancel:(id)sender
{
     [self.navigationController popViewControllerAnimated:YES];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)backgroundTapped:(id)sender
{
    [[self view] endEditing:YES];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField: textField up: YES];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField: textField up: NO];
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    const int movementDistance = 40; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

- (BOOL)validateTextFieldValues
{
    BOOL validationPassed = YES;
    
    ValidationResponse *locationOK = [SampleFieldValidator validateCurrentLocation:[LocationField text]];
    if (!locationOK.isValid && validationPassed == YES) {
        validationPassed = NO;
        
        NSString *message = [locationOK alertWithFieldName:@"location" fieldValue:[LocationField text]];
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:message
                              message:nil
                              delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil, nil];
        [alert show];
    }
    
    return validationPassed;
}

@end
