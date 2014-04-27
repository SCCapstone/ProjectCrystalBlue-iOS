//
//  IntialsViewController.m
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 3/22/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "InitialsViewController.h"
#import "Split.h"
#import "Procedures.h"
#import "ProcedureFieldValidator.h"


@interface InitialsViewController ()
{
    NSString* initials;
}

@end

@implementation InitialsViewController

@synthesize initialsField, selectedSplit, libraryObjectStore, selectedRow, titleNav, descriptionLabel;

- (id)initWithSplit:(Split*)initSplit
        withLibrary:(AbstractCloudLibraryObjectStore*)initLibrary
            withRow:(int) initRow
          withTitle:(NSString*)initTitle
{
    self = [super init];
    if (self) {
        selectedSplit = initSplit;
        libraryObjectStore = initLibrary;
        selectedRow = initRow;
        titleNav = initTitle;
        
        UINavigationItem *n = [self navigationItem];
        [n setTitle:[selectedSplit key]];
        
        UIBarButtonItem *nextbtn = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(procedure:)];
        UIBarButtonItem *backbtn = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(goBack:)];
        
        [[self navigationItem] setLeftBarButtonItem:backbtn];
        [[self navigationItem] setRightBarButtonItem:nextbtn];
    }
    return self;
}

- (IBAction)procedure:(id)sender
{
    if (![self validateTextFieldValues])
    {
        return;
    }
    
    initials = [initialsField text];
    
    if (selectedRow == 1)
    {
        [Procedures makeSlabfromSplit:selectedSplit withInitials:initials inStore:libraryObjectStore];
    }
    
    else if (selectedRow == 2)
    {
        [Procedures makeBilletfromSplit:selectedSplit withInitials:initials inStore:libraryObjectStore];
    }
    
    else if (selectedRow == 3)
    {
        [Procedures makeThinSectionfromSplit:selectedSplit withInitials:initials inStore:libraryObjectStore];
    }
    
    else if (selectedRow == 4)
    {
        [Procedures trimSplit:selectedSplit withInitials:initials inStore:libraryObjectStore];
    }

    else if (selectedRow == 5)
    {
        [Procedures jawCrushSplit:selectedSplit withInitials:initials inStore:libraryObjectStore];
    }
    
    else if (selectedRow == 6)
    {
        [Procedures pulverizeSplit:selectedSplit withInitials:initials inStore:libraryObjectStore];
    }
    
    else if (selectedRow == 7)
    {
        [Procedures gemeniSplit:selectedSplit withInitials:initials inStore:libraryObjectStore];
    }
    
    else if (selectedRow == 8)
    {
        [Procedures panSplit:selectedSplit withInitials:initials inStore:libraryObjectStore];
    }
    
    else if (selectedRow == 9)
    {
        [Procedures sievesTenSplit:selectedSplit withInitials:initials inStore:libraryObjectStore];
    }

    else if (selectedRow == 10)
    {
        [Procedures heavyLiquid_330_Split:selectedSplit withInitials:initials inStore:libraryObjectStore];
    }
    
    else if (selectedRow == 11)
    {
        [Procedures heavyLiquid_290_Split:selectedSplit withInitials:initials inStore:libraryObjectStore];
    }
    
    else if (selectedRow == 12)
    {
        [Procedures heavyLiquid_265_Split:selectedSplit withInitials:initials inStore:libraryObjectStore];
    }

    else if (selectedRow == 13)
    {
        [Procedures heavyLiquid_255_Split:selectedSplit withInitials:initials inStore:libraryObjectStore];
    }

    else if (selectedRow == 14)
    {
        [Procedures handMagnetSplit:selectedSplit withInitials:initials inStore:libraryObjectStore];
    }
    
    else if (selectedRow == 15)
    {
        [Procedures  magnet02AmpsSplit:selectedSplit withInitials:initials inStore:libraryObjectStore];
    }
    
    else if (selectedRow == 16)
    {
        [Procedures  magnet04AmpsSplit:selectedSplit withInitials:initials inStore:  libraryObjectStore];
    }
    
    else if (selectedRow == 17)
    {
        [Procedures  magnet06AmpsSplit:selectedSplit withInitials:initials inStore:libraryObjectStore];
    }
    
    else if (selectedRow == 18)
    {
        [Procedures  magnet08AmpsSplit:selectedSplit withInitials:initials inStore:libraryObjectStore];
    }
    
    else if (selectedRow == 19)
    {
        [Procedures  magnet10AmpsSplit:selectedSplit withInitials:initials inStore:libraryObjectStore];
    }
    
    else if (selectedRow == 20)
    {
        [Procedures  magnet12AmpsSplit:selectedSplit withInitials:initials inStore:libraryObjectStore];
    }
    
    else if (selectedRow == 21)
    {
        [Procedures  magnet14AmpsSplit:selectedSplit withInitials:initials inStore:libraryObjectStore];
    }
    
    NSUInteger temp = self.navigationController.viewControllers.count - 3;
    UIViewController* tempController = [self.navigationController.viewControllers objectAtIndex:temp];
    [self.navigationController popToViewController:tempController animated:YES];
}

-(void) goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void) viewDidAppear:(BOOL)animated
{
    NSString* tempString = @"Applying '";
    tempString = [tempString stringByAppendingString:titleNav];
    tempString = [tempString stringByAppendingString:@"' to "];
    tempString = [tempString stringByAppendingString:[selectedSplit key]];
    [descriptionLabel setText:tempString];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)validateTextFieldValues
{
    BOOL validationPassed = YES;
    
    ValidationResponse *initialsOK = [ProcedureFieldValidator validateInitials:[initialsField text]];
    if (!initialsOK.isValid && validationPassed == YES) {
        validationPassed = NO;
        
        NSString *message = [initialsOK alertWithFieldName:@"initials" fieldValue:[initialsField text]];
        
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

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)backgroundTapped:(id)sender
{
    [[self view] endEditing:YES];
}

@end
