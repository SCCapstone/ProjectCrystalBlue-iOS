//
//  AddSampleSixViewController.m
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 3/1/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "AddSampleSevenViewController.h"
#import "AddSampleImageViewController.h"
#import "Sample.h"
#import "DDLog.h"


@interface AddSampleSevenViewController ()

@end

@implementation AddSampleSevenViewController
@synthesize libraryObjectStore, sourceToAdd, AgeField, AgeMethodField, AgeDataTypeField;

- (id)initWithSource:(Source *)initSource WithLibraryObject:(AbstractCloudLibraryObjectStore *) initLibrary{
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
    [[sourceToAdd attributes] setObject:[AgeField text] forKey:SRC_AGE];
    [[sourceToAdd attributes] setObject:[AgeMethodField text] forKey:SRC_AGE_METHOD];
    [[sourceToAdd attributes] setObject:[AgeDataTypeField text] forKey:SRC_AGE_DATATYPE];
    
    AddSampleImageViewController *asiViewController = [[AddSampleImageViewController alloc] initWithSource:sourceToAdd WithLibraryObject:libraryObjectStore WithTitle:@"Far View Outcrop"];
    
    [[self navigationController] pushViewController:asiViewController  animated:YES];

    /**
    DDLogInfo(@"Adding new source %@", sourceToAdd.key);
    [libraryObjectStore putLibraryObject:sourceToAdd IntoTable:[SourceConstants tableName]];
    
    NSString *newSampleKey = [NSString stringWithFormat:@"%@%@", [sourceToAdd key], @".001"];
    Sample *newSample = [[Sample alloc] initWithKey:newSampleKey
                                      AndWithValues:[SampleConstants attributeDefaultValues]];
    [[newSample attributes] setObject:[sourceToAdd key] forKey:@"sourceKey"];
    [libraryObjectStore putLibraryObject:newSample IntoTable:[SampleConstants tableName]];
     [self navigationController] popToRootViewControllerAnimated:YES];
     **/
    
    
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