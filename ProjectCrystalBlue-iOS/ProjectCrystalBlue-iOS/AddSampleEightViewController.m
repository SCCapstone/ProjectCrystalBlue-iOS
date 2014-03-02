//
//  AddSampleSixViewController.m
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 3/1/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "AddSampleEightViewController.h"
#import "SourceConstants.h"
#import "AbstractCloudLibraryObjectStore.h"
#import "Sample.h"
#import "SampleConstants.h"
#import "DDLog.h"

#ifdef DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif
@interface AddSampleEightViewController ()

@end

@implementation AddSampleEightViewController
@synthesize libraryObjectStore, sourceToAdd, ProjectField, SubprojectField;

- (id)initWithSource:(Source *)initSource
{
    if (self) {
        sourceToAdd = initSource;
        
        UINavigationItem *n = [self navigationItem];
        [n setTitle:@"Add Sample Cont."];
        
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(addSource:)];
        
        UIBarButtonItem *backbtn = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(goBack:)];
        
        [[self navigationItem] setRightBarButtonItem:bbi];
        [[self navigationItem] setLeftBarButtonItem:backbtn];
        
    }
    return self;
    
}

- (IBAction)addSource:(id)sender {

    DDLogInfo(@"Adding new source %@", sourceToAdd.key);
    [[sourceToAdd attributes] setObject:[ProjectField text] forKey:SRC_PROJECT];
    [[sourceToAdd attributes] setObject:[SubprojectField text] forKey:SRC_SUBPROJECT];
    [libraryObjectStore putLibraryObject:sourceToAdd IntoTable:[SourceConstants tableName]];
    
    NSString *newSampleKey = [NSString stringWithFormat:@"%@%@", [sourceToAdd key], @".001"];
    Sample *newSample = [[Sample alloc] initWithKey:newSampleKey
                                      AndWithValues:[SampleConstants attributeDefaultValues]];
    [[newSample attributes] setObject:[sourceToAdd key] forKey:@"sourceKey"];
    [libraryObjectStore putLibraryObject:newSample IntoTable:[SampleConstants tableName]];

    [[self navigationController] popToRootViewControllerAnimated:YES];
    
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