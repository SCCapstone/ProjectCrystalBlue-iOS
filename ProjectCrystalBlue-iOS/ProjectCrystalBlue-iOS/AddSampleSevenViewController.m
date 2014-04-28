//
//  AddSampleSixViewController.m
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 3/1/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "AddSampleSevenViewController.h"
#import "AddSampleImageViewController.h"
#import "Split.h"
#import "SampleFieldValidator.h"
#import "PCBLogWrapper.h"

@interface AddSampleSevenViewController ()

@end

@implementation AddSampleSevenViewController
@synthesize libraryObjectStore, sampleToAdd, AgeField, AgeDataTypeField;

- (id)initWithSample:(Sample *)initSample
   WithLibraryObject:(AbstractCloudLibraryObjectStore *)initLibrary
{
    self = [super init];
    if (self) {
        sampleToAdd = initSample;
        libraryObjectStore = initLibrary;
        
        UINavigationItem *n = [self navigationItem];
        [n setTitle:@"Add Sample Cont."];
        
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:self action:@selector(addSample:)];
        
        UIBarButtonItem *backbtn = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(goBack:)];
        
        [[self navigationItem] setRightBarButtonItem:bbi];
        [[self navigationItem] setLeftBarButtonItem:backbtn];
    }
    return self;
}

- (IBAction)addSample:(id)sender
{
    if (![self validateTextFieldValues])
    {
        return;
    }
    
    [[sampleToAdd attributes] setObject:[AgeField text] forKey:SMP_AGE];
    [[sampleToAdd attributes] setObject:[AgeDataTypeField text] forKey:SMP_AGE_DATATYPE];
    
    NSMutableArray *images = [[NSMutableArray alloc] init];
    NSMutableArray *desriptions = [[NSMutableArray alloc] init];
    
    AddSampleImageViewController *asiViewController = [[AddSampleImageViewController alloc] initWithSample:sampleToAdd
                                                                                         WithLibraryObject:libraryObjectStore
                                                                                                 WithTitle:@"Far View Outcrop"
                                                                                                WithImages:images
                                                                                          WithDescriptions:desriptions];
    
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

- (BOOL)validateTextFieldValues
{
    BOOL validationPassed = YES;

    ValidationResponse *ageOK = [SampleFieldValidator validateAge:[AgeField text]];
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
    
    ValidationResponse *ageDatatypeOK = [SampleFieldValidator validateAgeDatatype:[AgeDataTypeField text]];
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