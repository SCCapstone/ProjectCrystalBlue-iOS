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


@interface AddSampleFiveViewController ()

{
    UITableView *autocompleteTableView;
}

@end

@implementation AddSampleFiveViewController
@synthesize GroupField, FormationField, MemberField, sourceToAdd, libraryObjectStore;

- (id)initWithSource:(Source *)initSource WithLibraryObject:(AbstractCloudLibraryObjectStore *) initLibrary
{
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
    autocompleteTableView.hidden = YES;
    
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
    // Dispose of any resources that can be recreated.
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    autocompleteTableView.hidden = YES;
    return YES;
}

- (IBAction)backgroundTapped:(id)sender {
    autocompleteTableView.hidden = YES;
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
    
    //if (textField == FormationField) {
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



@end
