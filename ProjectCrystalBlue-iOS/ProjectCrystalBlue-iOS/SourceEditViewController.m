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
#import "SourceImageUtils.h"
#import "sourceImagesViewController.h"

#ifdef DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@interface SourceEditViewController ()
{
    NSString* textString;
    NSArray* imageArray;
    UIImage* img;
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

- (IBAction)picturedTapped:(id)sender {
    sourceImagesViewController *imgViewController = [[sourceImagesViewController alloc] initWithSource:selectedSource withLibrary:libraryObjectStore];
    [[self navigationController] pushViewController:imgViewController  animated:YES];

}

- (void)viewDidLoad {
    [self.scroller setScrollEnabled:YES];
    [scroller setContentSize:CGSizeMake(320, 1000)];
    
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
    [MeterField setText:[[selectedSource attributes] objectForKey:SRC_METER]];
    [LatitudeField setText:[[selectedSource attributes] objectForKey:SRC_LATITUDE]];
    [LongitudeField setText:[[selectedSource attributes] objectForKey:SRC_LONGITUDE]];
    [AgeField setText:[[selectedSource attributes] objectForKey:SRC_AGE]];
    [AgeMethodField setText:[[selectedSource attributes] objectForKey:SRC_AGE_METHOD]];
    [AgeDataTypeField setText:[[selectedSource attributes] objectForKey:SRC_AGE_DATATYPE]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    NSDate *newDate = [formatter dateFromString:[[selectedSource attributes] objectForKey:SRC_DATE_COLLECTED]];
    [DatePicker setDate:newDate];
    
    imageArray = [SourceImageUtils imagesForSource:selectedSource inImageStore:[SourceImageUtils defaultImageStore]];

    
    if([imageArray count] == 0)
    {
        img = [UIImage imageNamed:@"no_image.png"];
        [imageView setImage:img];
    }
    else
    {
        img = [imageArray objectAtIndex:0];
        [imageView setImage:img];
        
    }
     
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
    [[selectedSource attributes] setObject:[MeterField text] forKey:SRC_METER];
    [[selectedSource attributes] setObject:[LatitudeField text] forKey:SRC_LATITUDE];
    [[selectedSource attributes] setObject:[LongitudeField text] forKey:SRC_LONGITUDE];
    [[selectedSource attributes] setObject:[AgeField text] forKey:SRC_AGE];
    [[selectedSource attributes] setObject:[AgeMethodField text] forKey:SRC_AGE_METHOD];
    [[selectedSource attributes] setObject:[AgeDataTypeField text] forKey:SRC_AGE_DATATYPE];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    NSString *dateString = [formatter stringFromDate:DatePicker.date];
    [[selectedSource attributes] setObject:dateString forKey:SRC_DATE_COLLECTED];

    
    [libraryObjectStore updateLibraryObject:selectedSource IntoTable:[SourceConstants tableName]];
    
    TypeLabel.textColor = [UIColor blackColor];
    LithologyLabel.textColor = [UIColor blackColor];
    DeposystemLabel.textColor = [UIColor blackColor];
    GroupLabel.textColor = [UIColor blackColor];
    FormationLabel.textColor = [UIColor blackColor];
    MemberLabel.textColor = [UIColor blackColor];
    RegionLabel.textColor = [UIColor blackColor];
    LocalityLabel.textColor = [UIColor blackColor];
    SectionLabel.textColor = [UIColor blackColor];
    MeterLabel.textColor = [UIColor blackColor];
    LatitudeLabel.textColor = [UIColor blackColor];
    LongitudeLabel.textColor = [UIColor blackColor];
    AgeLabel.textColor = [UIColor blackColor];
    AgeMethodLabel.textColor = [UIColor blackColor];
    AgeDataTypeLabel.textColor = [UIColor blackColor];
    DateLabel.textColor = [UIColor blackColor];
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
        if(textField == LithologyField)
        {
            LithologyLabel.textColor = [UIColor redColor];
        }
        if(textField == DeposystemField)
        {
            DeposystemLabel.textColor = [UIColor redColor];
        }
        if(textField == GroupField)
        {
            GroupLabel.textColor = [UIColor redColor];
        }
        if(textField == FormationField)
        {
            FormationLabel.textColor = [UIColor redColor];
        }
        if(textField == MemberField)
        {
            MemberLabel.textColor = [UIColor redColor];
        }
        if(textField == RegionField)
        {
            RegionLabel.textColor = [UIColor redColor];
        }
        if(textField == LocalityField)
        {
            LocalityLabel.textColor = [UIColor redColor];
        }
        if(textField == SectionField)
        {
            SectionLabel.textColor = [UIColor redColor];
        }
        if(textField == MeterField)
        {
            MeterLabel.textColor = [UIColor redColor];
        }
        if(textField == LatitudeField)
        {
            LatitudeLabel.textColor = [UIColor redColor];
        }
        if(textField == LongitudeField)
        {
            LongitudeLabel.textColor = [UIColor redColor];
        }
        if(textField == AgeField)
        {
            AgeLabel.textColor = [UIColor redColor];
        }
        if(textField == AgeMethodField)
        {
            AgeMethodLabel.textColor = [UIColor redColor];
        }
        if(textField == AgeDataTypeField)
        {
            AgeDataTypeLabel.textColor = [UIColor redColor];
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
