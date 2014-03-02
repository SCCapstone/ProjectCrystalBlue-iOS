//
//  SourceEdit1ViewController.m
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 3/2/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "SourceEdit1ViewController.h"
#import "Source.h"
#import "LibraryObject.h"
#import "DDLog.h"
#import "Sample.h"
#import "AbstractCloudLibraryObjectStore.h"
#import "SimpleDBLibraryObjectStore.h"
#import "SourceConstants.h"

#ifdef DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@interface SourceEdit1ViewController ()

@end

@implementation SourceEdit1ViewController

@synthesize source, scroller, libraryObjectStore;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [self.scroller setScrollEnabled:YES];
    [scroller setContentSize:CGSizeMake(320, 950)];
    
    [super viewDidLoad];
    [[self view] setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [TypeField setText:[[source attributes] objectForKey:SRC_TYPE]];
    [LithologyField setText:[[source attributes] objectForKey:SRC_LITHOLOGY]];
    [DeposystemField setText:[[source attributes] objectForKey:SRC_DEPOSYSTEM]];
    [GroupField setText:[[source attributes] objectForKey:SRC_GROUP]];
    [FormationField setText:[[source attributes] objectForKey:SRC_FORMATION]];
    [MemberField setText:[[source attributes] objectForKey:SRC_MEMBER]];
    [RegionField setText:[[source attributes] objectForKey:SRC_REGION]];
    [LocalityField setText:[[source attributes] objectForKey:SRC_LOCALITY]];
    [SectionField setText:[[source attributes] objectForKey:SRC_SECTION]];
    [MeterLevelField setText:[[source attributes] objectForKey:SRC_METER_LEVEL]];
    [LatitudeField setText:[[source attributes] objectForKey:SRC_LATITUDE]];
    [LongitudeField setText:[[source attributes] objectForKey:SRC_LONGITUDE]];
    [AgeField setText:[[source attributes] objectForKey:SRC_AGE]];
    [AgeBasis1Field setText:[[source attributes] objectForKey:SRC_AGE_BASIS1]];
    [AgeBasis2Field setText:[[source attributes] objectForKey:SRC_AGE_BASIS2]];
    [ProjectField setText:[[source attributes] objectForKey:SRC_PROJECT]];
    [SubprojectField setText:[[source attributes] objectForKey:SRC_SUBPROJECT]];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[self view] endEditing:YES];
    
    //BOOL keyExists = [libraryObjectStore libraryObjectExistsForKey:[KeyField text] FromTable:[SourceConstants tableName]];
    
    
    [[source attributes] setObject:[TypeField text] forKey:SRC_TYPE];
    [[source attributes] setObject:[LithologyField text] forKey:SRC_LITHOLOGY];
    [[source attributes] setObject:[DeposystemField text] forKey:SRC_DEPOSYSTEM];
    [[source attributes] setObject:[GroupField text] forKey:SRC_GROUP];
    [[source attributes] setObject:[FormationField text] forKey:SRC_FORMATION];
    [[source attributes] setObject:[MemberField text] forKey:SRC_MEMBER];
    [[source attributes] setObject:[RegionField text] forKey:SRC_REGION];
    [[source attributes] setObject:[LocalityField text] forKey:SRC_LOCALITY];
    [[source attributes] setObject:[SectionField text] forKey:SRC_SECTION];
    [[source attributes] setObject:[MeterLevelField text] forKey:SRC_METER_LEVEL];
    [[source attributes] setObject:[LatitudeField text] forKey:SRC_LATITUDE];
    [[source attributes] setObject:[LongitudeField text] forKey:SRC_LONGITUDE];
    [[source attributes] setObject:[AgeField text] forKey:SRC_AGE];
    [[source attributes] setObject:[AgeBasis1Field text] forKey:SRC_AGE_BASIS1];
    [[source attributes] setObject:[AgeBasis2Field text] forKey:SRC_AGE_BASIS2];
    [[source attributes] setObject:[ProjectField text] forKey:SRC_PROJECT];
    [[source attributes] setObject:[SubprojectField text] forKey:SRC_SUBPROJECT];
    
    [libraryObjectStore updateLibraryObject:source IntoTable:[SourceConstants tableName]];
    
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)backgroundTapped:(id)sender {
    [[self view] endEditing:YES];
}


- (void)save:(id)sender
{
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:_dismissBlock];
}

- (void)cancel:(id)sender
{
    //[[SourceStore sharedStore] removeSource:source];
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:_dismissBlock];
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
