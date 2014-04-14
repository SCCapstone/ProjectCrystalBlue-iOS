//
//  AddSampleFiveViewController.m
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 3/1/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "AddSampleFiveViewController.h"
#import "Source.h"
#import "AddSampleSixViewController.h"
#import "AbstractLibraryObjectStore.h"
#import "SampleConstants.h"
#import "SourceFieldValidator.h"

@interface AddSampleFiveViewController ()

@end

@implementation AddSampleFiveViewController
@synthesize GroupField, FormationField, MemberField, sourceToAdd, libraryObjectStore;

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

- (IBAction)addSource:(id)sender
{
    if (![self validateTextFieldValues])
    {
        return;
    }
    [[sourceToAdd attributes] setObject:[GroupField text] forKey:SRC_GROUP];
    [[sourceToAdd attributes] setObject:[FormationField text] forKey:SRC_FORMATION];
    [[sourceToAdd attributes] setObject:[MemberField text] forKey:SRC_MEMBER];
    
    AddSampleSixViewController *assViewController = [[AddSampleSixViewController alloc] initWithSource:sourceToAdd WithLibraryObject:libraryObjectStore];
    
    [[self navigationController] pushViewController:assViewController  animated:YES];
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
    int movementDistance = 0;
    float movementDuration = 0.0;
    
    if (textField == GroupField) {
       movementDistance = 40; // tweak as needed
       movementDuration = 0.3f; // tweak as needed
    }
    
    else
    {
        movementDistance = 40; // tweak as needed
        movementDuration = 0.3f; // tweak as needed
    }
    
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
    
    ValidationResponse *formationOK = [SourceFieldValidator validateFormation:[FormationField text]];
    if (!formationOK.isValid && validationPassed == YES) {
        validationPassed = NO;
        
        NSString *message = [formationOK alertWithFieldName:@"formation" fieldValue:[FormationField text]];
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:message
                              message:nil
                              delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil, nil];
        [alert show];
    }
    
    ValidationResponse *memberOK = [SourceFieldValidator validateMember:[MemberField text]];
    if (!memberOK.isValid && validationPassed == YES) {
        validationPassed = NO;
        
        NSString *message = [memberOK alertWithFieldName:@"member" fieldValue:[MemberField text]];
        
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
