//
//  AddSampleOneViewController.m
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 3/1/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "AddSampleOneViewController.h"
#import "SimpleDBLibraryObjectStore.h"
#import "SourceConstants.h"
#import "Source.h"
#import "AddSampleTwoViewController.h"

@interface AddSampleOneViewController ()
{
    SimpleDBLibraryObjectStore *libraryObjectStore;
    Source *sourceToAdd;
}
@end

@implementation AddSampleOneViewController
@synthesize KeyField, LatitudeField, LongitudeField, DateField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        libraryObjectStore = [[SimpleDBLibraryObjectStore alloc] initInLocalDirectory:@"ProjectCrystalBlue/Data"WithDatabaseName:@"test_database.db"];
        
        UINavigationItem *n = [self navigationItem];
        [n setTitle:@"Add Sample: Pg.1"];
        
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:self action:@selector(addSource:)];
        
        UIBarButtonItem *backbtn = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(goBack:)];
        
        [[self navigationItem] setRightBarButtonItem:bbi];
        [[self navigationItem] setLeftBarButtonItem:backbtn];

    }
    return self;
}

- (IBAction)addSource:(id)sender {
    
    sourceToAdd = [[Source alloc] initWithKey:[KeyField text]
                                      AndWithValues:[SourceConstants attributeDefaultValues]];
    
    [[sourceToAdd attributes] setObject:[LatitudeField text] forKey:SRC_LATITUDE];
    [[sourceToAdd attributes] setObject:[LongitudeField text] forKey:SRC_LONGITUDE];
    [[sourceToAdd attributes] setObject:[DateField text] forKey:SRC_DATE_COLLECTED];
    
    AddSampleTwoViewController *astViewController = [[AddSampleTwoViewController alloc] initWithSource:sourceToAdd];
    
    [astViewController setLibraryObjectStore:libraryObjectStore];
    [[self navigationController] pushViewController:astViewController  animated:YES];
    
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

@end
