//
//  AddSampleSixViewController.m
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 3/1/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "AddSampleSixViewController.h"
#import "AddSampleAgeViewController.h"
#import "SourceFieldValidator.h"


@interface AddSampleSixViewController ()

@end

@implementation AddSampleSixViewController
@synthesize libraryObjectStore, sourceToAdd, RegionField, LocalityField, SectionField, MeterField;

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
    if (![self validateTextFieldValues]) {
        return;
    }
    
    [[sourceToAdd attributes] setObject:[RegionField text] forKey:SRC_REGION];
    [[sourceToAdd attributes] setObject:[LocalityField text] forKey:SRC_LOCALITY];
    [[sourceToAdd attributes] setObject:[SectionField text] forKey:SRC_SECTION];
    [[sourceToAdd attributes] setObject:[MeterField text] forKey:SRC_METER];
    
    AddSampleAgeViewController *asaViewController = [[AddSampleAgeViewController alloc] initWithSource:sourceToAdd WithLibraryObject:libraryObjectStore];
    
    [[self navigationController] pushViewController:asaViewController  animated:YES];

   }

-(void) goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)backgroundTapped:(id)sender {
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

    ValidationResponse *regionOK = [SourceFieldValidator validateRegion:[RegionField text]];
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
    
    ValidationResponse *localityOK = [SourceFieldValidator validateLocality:[LocalityField text]];
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
    
    ValidationResponse *sectionOK = [SourceFieldValidator validateContinent:[SectionField text]];
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
    
    ValidationResponse *meterOK = [SourceFieldValidator validateMeters:[MeterField text]];
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