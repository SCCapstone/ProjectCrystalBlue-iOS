//
//  AddSampleSixViewController.m
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 3/1/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "AddSampleSevenViewController.h"
#import "AddSampleImageViewController.h"
#import "Sample.h"
#import "DDLog.h"
#import "SourceFieldValidator.h"


@interface AddSampleSevenViewController ()

@end

@implementation AddSampleSevenViewController
@synthesize libraryObjectStore, sourceToAdd, AgeField, AgeDataTypeField;

- (id)initWithSource:(Source *)initSource WithLibraryObject:(AbstractCloudLibraryObjectStore *) initLibrary
{
    self = [super init];
    if (self) {
        sourceToAdd = initSource;
        libraryObjectStore = initLibrary;
        
        UINavigationItem *n = [self navigationItem];
        [n setTitle:@"Add Sample Cont."];
        
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:self action:@selector(addSource:)];
        
        UIBarButtonItem *backbtn = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(goBack:)];
        
        [[self navigationItem] setRightBarButtonItem:bbi];
        [[self navigationItem] setLeftBarButtonItem:backbtn];
    }
    return self;
    
}

- (IBAction)addSource:(id)sender {
    if (![self validateTextFieldValues])
    {
        return;
    }
    
    [[sourceToAdd attributes] setObject:[AgeField text] forKey:SRC_AGE];
    [[sourceToAdd attributes] setObject:[AgeDataTypeField text] forKey:SRC_AGE_DATATYPE];
    
    NSMutableArray *images = [[NSMutableArray alloc] init];
    NSMutableArray *desriptions = [[NSMutableArray alloc] init];
    
    AddSampleImageViewController *asiViewController = [[AddSampleImageViewController alloc] initWithSource:sourceToAdd WithLibraryObject:libraryObjectStore WithTitle:@"Far View Outcrop" withImages:images withDescriptions:desriptions];
    
    [[self navigationController] pushViewController:asiViewController  animated:YES];
}

-(void) goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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

    ValidationResponse *ageOK = [SourceFieldValidator validateAge:[AgeField text]];
    if (!ageOK.isValid && validationPassed == YES) {
        validationPassed = NO;
        
        NSString *message = [ageOK alertWithFieldName:@"age" fieldValue:[AgeField text]];
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:message
                              message:nil
                              delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil, nil];
        [alert show];
    }
    
    ValidationResponse *ageDatatypeOK = [SourceFieldValidator validateAgeDatatype:[AgeDataTypeField text]];
    if (!ageDatatypeOK.isValid && validationPassed == YES) {
        validationPassed = NO;
        
        NSString *message = [ageDatatypeOK alertWithFieldName:@"age datatype" fieldValue:[AgeDataTypeField text]];
        
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