//
//  IntialsViewController.m
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 3/22/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "InitialsViewController.h"
#import "Sample.h"
#import "Procedures.h"
#import "ProcedureFieldValidator.h"


@interface InitialsViewController ()
{
    NSString* initials;
}

@end

@implementation InitialsViewController

@synthesize initialsField, selectedSample, libraryObjectStore, selectedRow, titleNav, descriptionLabel;

- (id)initWithSample:(Sample*)initSample withLibrary:(AbstractCloudLibraryObjectStore*)initLibrary withRow:(int) initRow withTitle:(NSString*)initTitle
{
    selectedSample = initSample;
    libraryObjectStore = initLibrary;
    selectedRow = initRow;
    titleNav = initTitle;
    
    if (self) {
        UINavigationItem *n = [self navigationItem];
        [n setTitle:[selectedSample key]];
        
        UIBarButtonItem *nextbtn = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(procedure:)];
        UIBarButtonItem *backbtn = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(goBack:)];
        
        [[self navigationItem] setLeftBarButtonItem:backbtn];
        [[self navigationItem] setRightBarButtonItem:nextbtn];
    }
    return self;
}

- (IBAction)procedure:(id)sender {
    if (![self validateTextFieldValues]) {
        return;
    }
    
    initials = [initialsField text];
    
    if (selectedRow == 1)
    {
        [Procedures makeSlabfromSample:selectedSample withInitials:initials inStore:libraryObjectStore];
    }
    
    else if (selectedRow == 2)
    {
        [Procedures makeBilletfromSample:selectedSample withInitials:initials inStore:libraryObjectStore];
    }
    
    else if (selectedRow == 3)
    {
        [Procedures makeThinSectionfromSample:selectedSample withInitials:initials inStore:libraryObjectStore];
    }
    
    else if (selectedRow == 4)
    {
        [Procedures trimSample:selectedSample withInitials:initials inStore:libraryObjectStore];
    }

    else if (selectedRow == 5)
    {
        [Procedures pulverizeSample:selectedSample withInitials:initials inStore:libraryObjectStore];
    }
    
    else if (selectedRow == 6)
    {
        [Procedures jawCrushSample:selectedSample withInitials:initials inStore:libraryObjectStore];
    }
    
    else if (selectedRow == 7)
    {
        [Procedures geminiSample:selectedSample withInitials:initials inStore:libraryObjectStore];
    }
    
    else if (selectedRow == 8)
    {
        [Procedures panSample:selectedSample withInitials:initials inStore:libraryObjectStore];
    }
    
    else if (selectedRow == 9)
    {
        [Procedures sievesTenSample:selectedSample withInitials:initials inStore:libraryObjectStore];
    }

    else if (selectedRow == 10)
    {
        [Procedures heavyLiquid_330_Sample:selectedSample withInitials:initials inStore:libraryObjectStore];
    }
    
    else if (selectedRow == 11)
    {
        [Procedures heavyLiquid_290_Sample:selectedSample withInitials:initials inStore:libraryObjectStore];
    }
    
    else if (selectedRow == 12)
    {
        [Procedures heavyLiquid_265_Sample:selectedSample withInitials:initials inStore:libraryObjectStore];
    }

    else if (selectedRow == 13)
    {
        [Procedures heavyLiquid_255_Sample:selectedSample withInitials:initials inStore:libraryObjectStore];
    }

    else if (selectedRow == 14)
    {
        [Procedures handMagnetSample:selectedSample withInitials:initials inStore:libraryObjectStore];
    }
    
    else if (selectedRow == 15)
    {
        [Procedures  magnet02AmpsSample:selectedSample withInitials:initials inStore:libraryObjectStore];
    }
    
    else if (selectedRow == 16)
    {
        [Procedures  magnet04AmpsSample:selectedSample withInitials:initials inStore:  libraryObjectStore];
    }
    
    else if (selectedRow == 17)
    {
        [Procedures  magnet06AmpsSample:selectedSample withInitials:initials inStore:libraryObjectStore];
    }
    
    else if (selectedRow == 18)
    {
        [Procedures  magnet08AmpsSample:selectedSample withInitials:initials inStore:libraryObjectStore];
    }
    
    else if (selectedRow == 19)
    {
        [Procedures  magnet10AmpsSample:selectedSample withInitials:initials inStore:libraryObjectStore];
    }
    
    else if (selectedRow == 20)
    {
        [Procedures  magnet12AmpsSample:selectedSample withInitials:initials inStore:libraryObjectStore];
    }
    
    else if (selectedRow == 21)
    {
        [Procedures  magnet14AmpsSample:selectedSample withInitials:initials inStore:libraryObjectStore];
    }
    
    int temp = self.navigationController.viewControllers.count - 3;
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
    tempString = [tempString stringByAppendingString:[selectedSample key]];
    [descriptionLabel setText:tempString];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
@end
