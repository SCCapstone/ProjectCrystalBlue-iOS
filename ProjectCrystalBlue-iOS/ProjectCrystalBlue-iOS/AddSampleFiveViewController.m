//
//  AddSampleFiveViewController.m
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 3/1/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "AddSampleFiveViewController.h"
#import "Sample.h"
#import "AddSampleSixViewController.h"
#import "AbstractLibraryObjectStore.h"
#import "SplitConstants.h"
#import "SampleFieldValidator.h"
#import "PCBLogWrapper.h"

@interface AddSampleFiveViewController ()

@end

@implementation AddSampleFiveViewController
@synthesize GroupField, FormationField, MemberField, sampleToAdd, libraryObjectStore;

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
    [[sampleToAdd attributes] setObject:[GroupField text] forKey:SMP_GROUP];
    [[sampleToAdd attributes] setObject:[FormationField text] forKey:SMP_FORMATION];
    [[sampleToAdd attributes] setObject:[MemberField text] forKey:SMP_MEMBER];
    
    AddSampleSixViewController *assViewController = [[AddSampleSixViewController alloc] initWithSample:sampleToAdd
                                                                                     WithLibraryObject:libraryObjectStore];
    
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

- (BOOL)validateTextFieldValues
{
    BOOL validationPassed = YES;
    
    ValidationResponse *formationOK = [SampleFieldValidator validateFormation:[FormationField text]];
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
    
    ValidationResponse *memberOK = [SampleFieldValidator validateMember:[MemberField text]];
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
