//
//  SampleEditViewController.m
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 1/31/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "SampleEditViewController.h"
#import "Sample.h"
#import "Split.h"
#import "AbstractCloudLibraryObjectStore.h"
#import "SampleConstants.h"
#import "SampleImagesViewController.h"
#import "SampleFieldValidator.h"
#import <MapKit/MapKit.h>
#import "MapViewController.h"

@interface SampleEditViewController ()
{
    NSString* textString;
    UIImage* img;
    BOOL navigateToRoot;
    CLLocationManager *locationManager;
    CLLocation *currentLocation;
    CLLocation *start;
}

@end

@implementation SampleEditViewController

@synthesize selectedSample, scroller, libraryObjectStore;

- (id)initWithSample:(Sample*)initSample
         WithLibrary:(AbstractCloudLibraryObjectStore*)initLibrary
AndNavigateBackToRoot:(BOOL)navigateBackToRoot;
{
    self = [super init];
    if (self) {
        selectedSample = initSample;
        libraryObjectStore = initLibrary;
        navigateToRoot = navigateBackToRoot;
        
        UINavigationItem *n = [self navigationItem];
        [n setTitle:[selectedSample key]];
        
        UIBarButtonItem *backbtn = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(goBack:)];
        UIBarButtonItem *savebtn = [[UIBarButtonItem alloc] initWithTitle:@"Save" style:UIBarButtonItemStyleBordered target:self action:@selector(save:)];
        
        [[self navigationItem] setLeftBarButtonItem:backbtn];
        [[self navigationItem] setRightBarButtonItem:savebtn];
    }
    return self;
}

- (IBAction)picturedTapped:(id)sender {
    SampleImagesViewController *imgViewController = [[SampleImagesViewController alloc] initWithSample:selectedSample
                                                                                           withLibrary:libraryObjectStore];
    [[self navigationController] pushViewController:imgViewController  animated:YES];
}

- (IBAction)showRockTypeOptions:(id)sender
{
    SimpleTableViewController *typeOptions = [[SimpleTableViewController alloc] initWithNibName:@"SimpleTableViewController"
                                                                                         bundle:nil];
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:typeOptions];
    typeOptions.tableData = [SampleConstants rockTypes];
    typeOptions.tag = 0;
    typeOptions.navigationItem.title = @"Rock Types";
    typeOptions.delegate = self;
    [self presentViewController:navController animated:YES completion:nil];
}

- (void)showLithologyOptions:(id)sender
{
    NSArray *lithologies = [SampleConstants lithologiesForRockType:TypeField.text];
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
    NSArray *deposystems = [SampleConstants deposystemsForRockType:TypeField.text];
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
    ageMethodOptions.tableData = [SampleConstants ageMethods];
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
        NSString *newRockType = [[SampleConstants rockTypes] objectAtIndex:row];
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
        [LithologyField setText:[[SampleConstants lithologiesForRockType:oldRockType] objectAtIndex:row]];
        LithologyLabel.textColor = [UIColor redColor];
    }
    else if (tag == 2) {
        [DeposystemField setText:[[SampleConstants deposystemsForRockType:oldRockType] objectAtIndex:row]];
        DeposystemLabel.textColor = [UIColor redColor];
    }
    else if (tag == 3) {
        [AgeMethodField setText:[[SampleConstants ageMethods] objectAtIndex:row]];
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
    
    [TypeField setText:[[selectedSample attributes] objectForKey:SMP_TYPE]];
    [LithologyField setText:[[selectedSample attributes] objectForKey:SMP_LITHOLOGY]];
    [DeposystemField setText:[[selectedSample attributes] objectForKey:SMP_DEPOSYSTEM]];
    [GroupField setText:[[selectedSample attributes] objectForKey:SMP_GROUP]];
    [FormationField setText:[[selectedSample attributes] objectForKey:SMP_FORMATION]];
    [MemberField setText:[[selectedSample attributes] objectForKey:SMP_MEMBER]];
    [RegionField setText:[[selectedSample attributes] objectForKey:SMP_REGION]];
    [LocalityField setText:[[selectedSample attributes] objectForKey:SMP_LOCALITY]];
    [SectionField setText:[[selectedSample attributes] objectForKey:SMP_SECTION]];
    [MeterField setText:[[selectedSample attributes] objectForKey:SMP_METER]];
    [LatitudeField setText:[[selectedSample attributes] objectForKey:SMP_LATITUDE]];
    [LongitudeField setText:[[selectedSample attributes] objectForKey:SMP_LONGITUDE]];
    [AgeField setText:[[selectedSample attributes] objectForKey:SMP_AGE]];
    [AgeMethodField setText:[[selectedSample attributes] objectForKey:SMP_AGE_METHOD]];
    [AgeDataTypeField setText:[[selectedSample attributes] objectForKey:SMP_AGE_DATATYPE]];
    [CollectedField setText:[[selectedSample attributes] objectForKey:SMP_COLLECTED_BY]];
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"mm/dd/yyyy, hh:mm a"];
    NSDate *newDate = [formatter dateFromString:[[selectedSample attributes] objectForKey:SMP_DATE_COLLECTED]];
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
    [[selectedSample attributes] setObject:[TypeField text] forKey:SMP_TYPE];
    [[selectedSample attributes] setObject:[LithologyField text] forKey:SMP_LITHOLOGY];
    [[selectedSample attributes] setObject:[DeposystemField text] forKey:SMP_DEPOSYSTEM];
    [[selectedSample attributes] setObject:[GroupField text] forKey:SMP_GROUP];
    [[selectedSample attributes] setObject:[FormationField text] forKey:SMP_FORMATION];
    [[selectedSample attributes] setObject:[MemberField text] forKey:SMP_MEMBER];
    [[selectedSample attributes] setObject:[RegionField text] forKey:SMP_REGION];
    [[selectedSample attributes] setObject:[LocalityField text] forKey:SMP_LOCALITY];
    [[selectedSample attributes] setObject:[SectionField text] forKey:SMP_SECTION];
    [[selectedSample attributes] setObject:[MeterField text] forKey:SMP_METER];
    [[selectedSample attributes] setObject:[LatitudeField text] forKey:SMP_LATITUDE];
    [[selectedSample attributes] setObject:[LongitudeField text] forKey:SMP_LONGITUDE];
    [[selectedSample attributes] setObject:[AgeField text] forKey:SMP_AGE];
    [[selectedSample attributes] setObject:[AgeMethodField text] forKey:SMP_AGE_METHOD];
    [[selectedSample attributes] setObject:[AgeDataTypeField text] forKey:SMP_AGE_DATATYPE];
    [[selectedSample attributes] setObject:[CollectedField text] forKey:SMP_COLLECTED_BY];
    
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
    [[selectedSample attributes] setObject:dateString forKey:SMP_DATE_COLLECTED];

    
    [libraryObjectStore updateLibraryObject:selectedSample IntoTable:[SampleConstants tableName]];
    
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

    ValidationResponse *formationOK = [SampleFieldValidator validateFormation:[FormationField text]];
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
    
    ValidationResponse *memberOK = [SampleFieldValidator validateMember:[MemberField text]];
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
    
    ValidationResponse *regionOK = [SampleFieldValidator validateRegion:[RegionField text]];
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
    
    ValidationResponse *localityOK = [SampleFieldValidator validateLocality:[LocalityField text]];
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
    
    ValidationResponse *sectionOK = [SampleFieldValidator validateContinent:[SectionField text]];
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
    
    ValidationResponse *meterOK = [SampleFieldValidator validateMeters:[MeterField text]];
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
    
    ValidationResponse *latitudeOK = [SampleFieldValidator validateLatitude:[LatitudeField text]];
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
    
    ValidationResponse *longitudeOK = [SampleFieldValidator validateLongitude:[LongitudeField text]];
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
    
    ValidationResponse *ageOK = [SampleFieldValidator validateAge:[AgeField text]];
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
    
    ValidationResponse *ageDatatypeOK = [SampleFieldValidator validateAgeDatatype:[AgeDataTypeField text]];
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
    
    ValidationResponse *collectedOK = [SampleFieldValidator validateCollectedBy:[CollectedField text]];
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
        MapViewController* mapViewController = [[MapViewController alloc] initWithKey:[selectedSample key] withLat:[LatitudeField text] withLong:[LongitudeField text]];
        
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
    
    ValidationResponse *latitudeOK = [SampleFieldValidator validateLatitude:[LatitudeField text]];
    if (!latitudeOK.isValid && validationPassed == YES) {
        validationPassed = NO;
    }
    
    ValidationResponse *longitudeOK = [SampleFieldValidator validateLongitude:[LongitudeField text]];
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
