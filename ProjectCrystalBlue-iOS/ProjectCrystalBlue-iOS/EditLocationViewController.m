//
//  EditLocationViewController.m
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 3/4/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "EditLocationViewController.h"
#import "SimpleDBLibraryObjectStore.h"
#import "SplitEditViewController.h"
#import "Split.h"
#import "SplitConstants.h"
#import "Procedures.h"
#import "SplitFieldValidator.h"
#import "PCBLogWrapper.h"

@interface EditLocationViewController ()
{
    SimpleDBLibraryObjectStore *libraryObjectStore;
    NSString *newLocation;
    Split *editedSplit;
}

@end

@implementation EditLocationViewController
@synthesize selectedSplit, LocationField;

- (id)initWithSplit:(Split *)initSplit
{
    self = [super init];
    if (self) {
        selectedSplit = initSplit;
        libraryObjectStore = [[SimpleDBLibraryObjectStore alloc] initInLocalDirectory:@"ProjectCrystalBlue/Data"
                                                                     WithDatabaseName:@"test_database.db"];
        
        UINavigationItem *n = [self navigationItem];
        [n setTitle:@"Change Split Location"];
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
    [Procedures moveSplit:selectedSplit toLocation:newLocation inStore:libraryObjectStore];
    NSUInteger temp = self.navigationController.viewControllers.count - 3;
    UIViewController* tempController = [self.navigationController.viewControllers objectAtIndex:temp];
    [self.navigationController popToViewController:tempController animated:YES];
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

- (BOOL)validateTextFieldValues
{
    BOOL validationPassed = YES;
    
    ValidationResponse *locationOK = [SplitFieldValidator validateCurrentLocation:[LocationField text]];
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
