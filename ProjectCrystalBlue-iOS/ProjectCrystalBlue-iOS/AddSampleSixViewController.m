//
//  AddSampleSixViewController.m
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 3/1/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "AddSampleSixViewController.h"
#import "AddSampleAgeViewController.h"
#import "SampleFieldValidator.h"


@interface AddSampleSixViewController ()

@end

@implementation AddSampleSixViewController
@synthesize libraryObjectStore, sampleToAdd, RegionField, LocalityField, SectionField, MeterField;

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
    
    [[sampleToAdd attributes] setObject:[RegionField text] forKey:SMP_REGION];
    [[sampleToAdd attributes] setObject:[LocalityField text] forKey:SMP_LOCALITY];
    [[sampleToAdd attributes] setObject:[SectionField text] forKey:SMP_SECTION];
    [[sampleToAdd attributes] setObject:[MeterField text] forKey:SMP_METER];
    
    AddSampleAgeViewController *asaViewController = [[AddSampleAgeViewController alloc] initWithSample:sampleToAdd
                                                                                     WithLibraryObject:libraryObjectStore];
    
    [[self navigationController] pushViewController:asaViewController  animated:YES];
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

    ValidationResponse *regionOK = [SampleFieldValidator validateRegion:[RegionField text]];
    if (!regionOK.isValid && validationPassed == YES) {
        validationPassed = NO;
        
        NSString *message = [regionOK alertWithFieldName:@"region" fieldValue:[RegionField text]];
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:message
                              message:nil
                              delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil, nil];
        [alert show];
    }
    
    ValidationResponse *localityOK = [SampleFieldValidator validateLocality:[LocalityField text]];
    if (!localityOK.isValid && validationPassed == YES) {
        validationPassed = NO;
        
        NSString *message = [localityOK alertWithFieldName:@"locality" fieldValue:[LocalityField text]];
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:message
                              message:nil
                              delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil, nil];
        [alert show];
    }
    
    ValidationResponse *sectionOK = [SampleFieldValidator validateContinent:[SectionField text]];
    if (!sectionOK.isValid && validationPassed == YES) {
        validationPassed = NO;
        
        NSString *message = [sectionOK alertWithFieldName:@"section" fieldValue:[SectionField text]];
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:message
                              message:nil
                              delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil, nil];
        [alert show];
    }
    
    ValidationResponse *meterOK = [SampleFieldValidator validateMeters:[MeterField text]];
    if (!meterOK.isValid && validationPassed == YES) {
        validationPassed = NO;
        
        NSString *message = [meterOK alertWithFieldName:@"meter" fieldValue:[MeterField text]];
        
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