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
    selectedSample = initSample;
    if (self) {
        libraryObjectStore = [[SimpleDBLibraryObjectStore alloc] initInLocalDirectory:@"ProjectCrystalBlue/Data"WithDatabaseName:@"test_database.db"];
        
        UINavigationItem *n = [self navigationItem];
        [n setTitle:@"Change Sample Location"];
    }
    return self;
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

- (IBAction)updateLocation:(id)sender {
    newLocation = [LocationField text];
    [Procedures moveSample:selectedSample toLocation:newLocation inStore:libraryObjectStore];
     [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cancel:(id)sender {
     [self.navigationController popViewControllerAnimated:YES];
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

@end