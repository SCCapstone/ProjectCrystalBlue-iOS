//
//  SourceEditViewController.m
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 1/31/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "SourceEditViewController.h"
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

@interface SourceEditViewController ()
{
    NSString* textString;
}

@end

@implementation SourceEditViewController

@synthesize selectedSource, scroller, libraryObjectStore;

- (id)initWithSource:(Source*)initSource withLibrary:(AbstractCloudLibraryObjectStore*)initLibrary
{
    selectedSource = initSource;
    libraryObjectStore = initLibrary;
    if (self) {
        UINavigationItem *n = [self navigationItem];
        [n setTitle:[selectedSource key]];
        
        UIBarButtonItem *backbtn = [[UIBarButtonItem alloc] initWithTitle:@"Return" style:UIBarButtonItemStyleBordered target:self action:@selector(goBack:)];
        UIBarButtonItem *savebtn = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleBordered target:self action:@selector(save:)];
        
        [[self navigationItem] setLeftBarButtonItem:backbtn];
        [[self navigationItem] setRightBarButtonItem:savebtn];
    }
    return self;
}

- (void)viewDidLoad {
    [self.scroller setScrollEnabled:YES];
    [scroller setContentSize:CGSizeMake(320, 850)];
    
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
    [TypeField setText:[[selectedSource attributes] objectForKey:SRC_TYPE]];
    [LithologyField setText:[[selectedSource attributes] objectForKey:SRC_LITHOLOGY]];
    [DeposystemField setText:[[selectedSource attributes] objectForKey:SRC_DEPOSYSTEM]];
    [GroupField setText:[[selectedSource attributes] objectForKey:SRC_GROUP]];
    [FormationField setText:[[selectedSource attributes] objectForKey:SRC_FORMATION]];
    [MemberField setText:[[selectedSource attributes] objectForKey:SRC_MEMBER]];
    [RegionField setText:[[selectedSource attributes] objectForKey:SRC_REGION]];
    [LocalityField setText:[[selectedSource attributes] objectForKey:SRC_LOCALITY]];
    [SectionField setText:[[selectedSource attributes] objectForKey:SRC_SECTION]];
    [MeterLevelField setText:[[selectedSource attributes] objectForKey:SRC_METER_LEVEL]];
    [LatitudeField setText:[[selectedSource attributes] objectForKey:SRC_LATITUDE]];
    [LongitudeField setText:[[selectedSource attributes] objectForKey:SRC_LONGITUDE]];
    [AgeField setText:[[selectedSource attributes] objectForKey:SRC_AGE]];
    [AgeBasis1Field setText:[[selectedSource attributes] objectForKey:SRC_AGE_BASIS1]];
    [AgeBasis2Field setText:[[selectedSource attributes] objectForKey:SRC_AGE_BASIS2]];
    [ProjectField setText:[[selectedSource attributes] objectForKey:SRC_PROJECT]];
    [SubprojectField setText:[[selectedSource attributes] objectForKey:SRC_SUBPROJECT]];
    [DateField setText:[[selectedSource attributes] objectForKey:SRC_DATE_COLLECTED]];
  
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[self view] endEditing:YES];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)backgroundTapped:(id)sender {
    [[self view] endEditing:YES];
}

-(void) goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) save:(id)sender
{
    [[selectedSource attributes] setObject:[TypeField text] forKey:SRC_TYPE];
    [[selectedSource attributes] setObject:[LithologyField text] forKey:SRC_LITHOLOGY];
    [[selectedSource attributes] setObject:[DeposystemField text] forKey:SRC_DEPOSYSTEM];
    [[selectedSource attributes] setObject:[GroupField text] forKey:SRC_GROUP];
    [[selectedSource attributes] setObject:[FormationField text] forKey:SRC_FORMATION];
    [[selectedSource attributes] setObject:[MemberField text] forKey:SRC_MEMBER];
    [[selectedSource attributes] setObject:[RegionField text] forKey:SRC_REGION];
    [[selectedSource attributes] setObject:[LocalityField text] forKey:SRC_LOCALITY];
    [[selectedSource attributes] setObject:[SectionField text] forKey:SRC_SECTION];
    [[selectedSource attributes] setObject:[MeterLevelField text] forKey:SRC_METER_LEVEL];
    [[selectedSource attributes] setObject:[LatitudeField text] forKey:SRC_LATITUDE];
    [[selectedSource attributes] setObject:[LongitudeField text] forKey:SRC_LONGITUDE];
    [[selectedSource attributes] setObject:[AgeField text] forKey:SRC_AGE];
    [[selectedSource attributes] setObject:[AgeBasis1Field text] forKey:SRC_AGE_BASIS1];
    [[selectedSource attributes] setObject:[AgeBasis2Field text] forKey:SRC_AGE_BASIS2];
    [[selectedSource attributes] setObject:[ProjectField text] forKey:SRC_PROJECT];
    [[selectedSource attributes] setObject:[SubprojectField text] forKey:SRC_SUBPROJECT];
    [[selectedSource attributes] setObject:[DateField text] forKey:SRC_DATE_COLLECTED];
    
    [libraryObjectStore updateLibraryObject:selectedSource IntoTable:[SourceConstants tableName]];
    
    TypeLabel.textColor = [UIColor blackColor];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    textString = [textField text];
    [self animateTextField: textField up: YES];
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField: textField up: NO];
    if (![textString isEqualToString:[textField text]]) {
        
        if(textField == TypeField)
        {
            TypeLabel.textColor = [UIColor redColor];
        }
    }
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
