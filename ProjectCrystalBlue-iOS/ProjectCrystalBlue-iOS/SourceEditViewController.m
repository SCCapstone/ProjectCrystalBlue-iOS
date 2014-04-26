//
//  SourceEditViewController.m
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 1/31/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "SourceEditViewController.h"
#import "Source.h"
#import "Split.h"
#import "AbstractCloudLibraryObjectStore.h"
#import "SourceConstants.h"
#import "SourceImagesViewController.h"
#import "SourceFieldValidator.h"
#import <MapKit/MapKit.h>
#import "MapViewController.h"

@interface SourceEditViewController ()
{
    NSString* textString;
    UIImage* img;
    BOOL navigateToRoot;
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    CLLocation *start;
}

@end

@implementation SourceEditViewController

@synthesize selectedSource, scroller, libraryObjectStore;

- (id)initWithSource:(Source*)initSource
         WithLibrary:(AbstractCloudLibraryObjectStore*)initLibrary
AndNavigateBackToRoot:(BOOL)navigateBackToRoot;
{
    self = [super init];
    if (self) {
        selectedSource = initSource;
        libraryObjectStore = initLibrary;
        navigateToRoot = navigateBackToRoot;
        
        UINavigationItem *n = [self navigationItem];
        [n setTitle:[selectedSource key]];
        
        UIBarButtonItem *backbtn = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(goBack:)];
        UIBarButtonItem *savebtn = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleBordered target:self action:@selector(save:)];
        
        [[self navigationItem] setLeftBarButtonItem:backbtn];
        [[self navigationItem] setRightBarButtonItem:savebtn];
    }
    return self;
}

- (IBAction)picturedTapped:(id)sender {
    SourceImagesViewController *imgViewController = [[SourceImagesViewController alloc] initWithSource:selectedSource
                                                                                           withLibrary:libraryObjectStore];
    [[self navigationController] pushViewController:imgViewController  animated:YES];
}

- (IBAction)showRockTypeOptions:(id)sender
{
    SimpleTableViewController *typeOptions = [[SimpleTableViewController alloc] initWithNibName:@"SimpleTableViewController"
                                                                                         bundle:nil];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:typeOptions];
    typeOptions.tableData = [SourceConstants rockTypes];
    typeOptions.tag = 0;
    typeOptions.navigationItem.title = @"Rock Types";
    typeOptions.delegate = self;
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)showLithologyOptions:(id)sender
{
    NSArray *lithologies = [SourceConstants lithologiesForRockType:TypeField.text];
    if (!lithologies) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"There are no known lithologies for the entered rock type."
                              message:nil
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    SimpleTableViewController *lithologyOptions = [[SimpleTableViewController alloc] initWithNibName:@"SimpleTableViewController"
                                                                                              bundle:nil];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:lithologyOptions];
    lithologyOptions.tableData = lithologies;
    lithologyOptions.tag = 1;
    lithologyOptions.navigationItem.title = @"Lithologies";
    lithologyOptions.delegate = self;
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)showDeposytemOptions:(id)sender
{
    NSArray *deposystems = [SourceConstants deposystemsForRockType:TypeField.text];
    if (!deposystems) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"There are no known deposystems for the entered rock type."
                              message:nil
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    SimpleTableViewController *deposystemOptions = [[SimpleTableViewController alloc] initWithNibName:@"SimpleTableViewController"
                                                                                               bundle:nil];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:deposystemOptions];
    deposystemOptions.tableData = deposystems;
    deposystemOptions.tag = 2;
    deposystemOptions.navigationItem.title = @"Deposystems";
    deposystemOptions.delegate = self;
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)showAgeMethodOptions:(id)sender
{
    SimpleTableViewController *ageMethodOptions = [[SimpleTableViewController alloc] initWithNibName:@"SimpleTableViewController"
                                                                                              bundle:nil];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:ageMethodOptions];
    ageMethodOptions.tableData = [SourceConstants ageMethods];
    ageMethodOptions.tag = 3;
    ageMethodOptions.navigationItem.title = @"Age Methods";
    ageMethodOptions.delegate = self;
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)itemSelectedAtRow:(NSInteger)row
                  WithTag:(NSUInteger)tag
{
    NSString *oldRockType = TypeField.text;

    if (tag == 0) {
        NSString *newRockType = [[SourceConstants rockTypes] objectAtIndex:row];
        [TypeField setText:newRockType];
        TypeLabel.textColor = [UIColor redColor];
        
        [LithologyField setText:@""];
        LithologyLabel.textColor = [UIColor redColor];
        
        if ([newRockType isEqualToString:@"Siliciclastic"] || [newRockType isEqualToString:@"Carbonate"] ||
                [newRockType isEqualToString:@"Authigenic"] || [newRockType isEqualToString:@"Volcanic"] ||
                [newRockType isEqualToString:@"Fossil"]) {
            DeposystemLabel.textColor = [UIColor redColor];
            [DeposystemField setText:@""];
        }
        else {
            DeposystemLabel.textColor = [UIColor redColor];
            [DeposystemField setText:@"N/A"];
        }
    }
    else if (tag == 1) {
        [LithologyField setText:[[SourceConstants lithologiesForRockType:oldRockType] objectAtIndex:row]];
        LithologyLabel.textColor = [UIColor redColor];
    }
    else if (tag == 2) {
        [DeposystemField setText:[[SourceConstants deposystemsForRockType:oldRockType] objectAtIndex:row]];
        DeposystemLabel.textColor = [UIColor redColor];
    }
    else if (tag == 3) {
        [AgeMethodField setText:[[SourceConstants ageMethods] objectAtIndex:row]];
        AgeMethodLabel.textColor = [UIColor redColor];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.scroller setScrollEnabled:YES];
    [scroller setContentSize:CGSizeMake(320, 1050)];
    
    [[self view] setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
    
    locationManager = [[CLLocationManager alloc] init];
    start = [[CLLocation alloc] initWithLatitude:[[LatitudeField text] floatValue] longitude:[[LongitudeField text] floatValue]];
    
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
    [CollectedField setText:[[selectedSource attributes] objectForKey:SRC_COLLECTED_BY]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"mm/dd/yyyy, hh:mm a"];
    NSDate *newDate = [formatter dateFromString:[[selectedSource attributes] objectForKey:SRC_DATE_COLLECTED]];
    if (!newDate)
        newDate = [NSDate dateWithTimeIntervalSince1970:0];
    [DatePicker setDate:newDate];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[self view] endEditing:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)backgroundTapped:(id)sender
{
    [[self view] endEditing:YES];
}

- (void)goBack:(id)sender
{
    if (navigateToRoot)
        [self.navigationController popToRootViewControllerAnimated:YES];
    else
        [self.navigationController popViewControllerAnimated:YES];
}

- (void)save:(id)sender
{
    if (![self validateTextFieldValues])
    {
        return;
    }
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
    [[selectedSource attributes] setObject:[CollectedField text] forKey:SRC_COLLECTED_BY];
    
    // Logic to set to current time and user entered date
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterShortStyle];
    [formatter setTimeStyle:NSDateFormatterShortStyle];
    
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *now = [NSDate date];
    NSDateComponents *nowComp = [calendar components:(NSHourCalendarUnit | NSMinuteCalendarUnit) fromDate:now];
    NSDate *date = DatePicker.date;
    NSDateComponents *comp = [calendar components:(NSDayCalendarUnit | NSMonthCalendarUnit | NSYearCalendarUnit) fromDate:date];
    
    comp.hour = nowComp.hour;
    comp.minute = nowComp.minute;
    date = [calendar dateFromComponents:comp];
    
    NSString *dateString = [formatter stringFromDate:date];
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
    CollectedLabel.textColor = [UIColor blackColor];
    DateLabel.textColor = [UIColor blackColor];
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    textString = [textField text];
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    if (![textString isEqualToString:[textField text]])
    {
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
        if(textField == CollectedField)
        {
            CollectedLabel.textColor = [UIColor redColor];
        }
    }
}

- (BOOL)validateTextFieldValues
{
    BOOL validationPassed = YES;

    ValidationResponse *formationOK = [SourceFieldValidator validateFormation:[FormationField text]];
    if (!formationOK.isValid && validationPassed == YES) {
        validationPassed = NO;
        
        NSString *message = [formationOK alertWithFieldName:@"formation" fieldValue:[FormationField text]];
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:message
                              message:nil
                              delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil, nil];
        [alert show];
    }
    
    ValidationResponse *memberOK = [SourceFieldValidator validateMember:[MemberField text]];
    if (!memberOK.isValid && validationPassed == YES) {
        validationPassed = NO;
        
        NSString *message = [memberOK alertWithFieldName:@"member" fieldValue:[MemberField text]];
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:message
                              message:nil
                              delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil, nil];
        [alert show];
    }
    
    ValidationResponse *regionOK = [SourceFieldValidator validateRegion:[RegionField text]];
    if (!regionOK.isValid && validationPassed == YES) {
        validationPassed = NO;
        
        NSString *message = [regionOK alertWithFieldName:@"region" fieldValue:[RegionField text]];
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:message
                              message:nil
                              delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil, nil];
        [alert show];
    }
    
    ValidationResponse *localityOK = [SourceFieldValidator validateLocality:[LocalityField text]];
    if (!localityOK.isValid && validationPassed == YES) {
        validationPassed = NO;
        
        NSString *message = [localityOK alertWithFieldName:@"locality" fieldValue:[LocalityField text]];
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:message
                              message:nil
                              delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil, nil];
        [alert show];
    }
    
    ValidationResponse *sectionOK = [SourceFieldValidator validateContinent:[SectionField text]];
    if (!sectionOK.isValid && validationPassed == YES) {
        validationPassed = NO;
        
        NSString *message = [sectionOK alertWithFieldName:@"section" fieldValue:[SectionField text]];
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:message
                              message:nil
                              delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil, nil];
        [alert show];
    }
    
    ValidationResponse *meterOK = [SourceFieldValidator validateMeters:[MeterField text]];
    if (!meterOK.isValid && validationPassed == YES) {
        validationPassed = NO;
        
        NSString *message = [meterOK alertWithFieldName:@"meter" fieldValue:[MeterField text]];
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:message
                              message:nil
                              delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil, nil];
        [alert show];
    }
    
    ValidationResponse *latitudeOK = [SourceFieldValidator validateLatitude:[LatitudeField text]];
    if (!latitudeOK.isValid && validationPassed == YES) {
        validationPassed = NO;
        
        NSString *message = [latitudeOK alertWithFieldName:@"latitude" fieldValue:[LatitudeField text]];
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:message
                              message:nil
                              delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil, nil];
        [alert show];
    }
    
    ValidationResponse *longitudeOK = [SourceFieldValidator validateLongitude:[LongitudeField text]];
    if (!longitudeOK.isValid && validationPassed == YES) {
        validationPassed = NO;
        
        NSString *message = [longitudeOK alertWithFieldName:@"longitude" fieldValue:[LongitudeField text]];
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:message
                              message:nil
                              delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil, nil];
        [alert show];
    }
    
    ValidationResponse *ageOK = [SourceFieldValidator validateAge:[AgeField text]];
    if (!ageOK.isValid && validationPassed == YES) {
        validationPassed = NO;
        
        NSString *message = [ageOK alertWithFieldName:@"age" fieldValue:[AgeField text]];
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:message
                              message:nil
                              delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil, nil];
        [alert show];
    }
    
    ValidationResponse *ageDatatypeOK = [SourceFieldValidator validateAgeDatatype:[AgeDataTypeField text]];
    if (!ageDatatypeOK.isValid && validationPassed == YES) {
        validationPassed = NO;
        
        NSString *message = [ageDatatypeOK alertWithFieldName:@"age datatype" fieldValue:[AgeDataTypeField text]];
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:message
                              message:nil
                              delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil, nil];
        [alert show];
    }
    
    ValidationResponse *collectedOK = [SourceFieldValidator validateCollectedBy:[CollectedField text]];
    if (!collectedOK.isValid && validationPassed == YES) {
        validationPassed = NO;
        
        NSString *message = [collectedOK alertWithFieldName:@"collected by" fieldValue:[CollectedField text]];
        
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

- (IBAction)getLocation:(id)sender
{
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    [locationManager startUpdatingLocation];
    

}

- (IBAction)dateChanged:(id)sender
{
    DateLabel.textColor = [UIColor redColor];
}

- (IBAction)viewMap:(id)sender
{
    bool doIt = [self validateCoordinates];
    if(!doIt)
    {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:@"Invalid/Blank Latitude and Longitude Fields"
                              message:nil
                              delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        MapViewController* mapViewController = [[MapViewController alloc] initWithKey:[selectedSource key] withLat:[LatitudeField text] withLong:[LongitudeField text]];
        
        [[self navigationController] pushViewController:mapViewController  animated:YES];
    }
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    currentLocation = newLocation;
    
    if (currentLocation != nil) {
        LatitudeField.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
        LongitudeField.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
    }
    if(currentLocation != start)
    {
        LatitudeLabel.textColor = [UIColor redColor];
        LongitudeLabel.textColor = [UIColor redColor];
    }
    [locationManager stopUpdatingLocation];
}

- (BOOL)validateCoordinates
{
    BOOL validationPassed = YES;
    
    ValidationResponse *latitudeOK = [SourceFieldValidator validateLatitude:[LatitudeField text]];
    if (!latitudeOK.isValid && validationPassed == YES) {
        validationPassed = NO;
    }
    
    ValidationResponse *longitudeOK = [SourceFieldValidator validateLongitude:[LongitudeField text]];
    if (!longitudeOK.isValid && validationPassed == YES) {
        validationPassed = NO;
    }
    
    if([LongitudeField.text isEqualToString:@""])
    {
        validationPassed = NO;
    }
    
    if([LatitudeField.text isEqualToString:@""])
    {
        validationPassed = NO;
    }
    return validationPassed;
}
@end
