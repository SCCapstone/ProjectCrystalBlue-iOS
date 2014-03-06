//
//  AddSampleOneViewController.m
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 3/1/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "AddSampleOneViewController.h"
#import "AbstractLibraryObjectStore.h"
#import "SourceConstants.h"
#import "Source.h"
#import "AddSampleTwoViewController.h"

@interface AddSampleOneViewController ()
{
    AbstractCloudLibraryObjectStore *libraryObjectStore;
    Source *sourceToAdd;
    CLLocationManager *locationManager;
}
@end

@implementation AddSampleOneViewController
@synthesize KeyField, LatitudeField, LongitudeField, DateField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        libraryObjectStore = [[SimpleDBLibraryObjectStore alloc] initInLocalDirectory:@"ProjectCrystalBlue/Data"WithDatabaseName:@"test_database.db"];
        
        UINavigationItem *n = [self navigationItem];
        [n setTitle:@"Add Sample"];
        
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:self action:@selector(addSource:)];
        
        UIBarButtonItem *backbtn = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(goBack:)];
        
        [[self navigationItem] setRightBarButtonItem:bbi];
        [[self navigationItem] setLeftBarButtonItem:backbtn];

    }
    return self;
}

- (IBAction)addSource:(id)sender {
    
    if (![libraryObjectStore libraryObjectExistsForKey:[KeyField text] FromTable:[SourceConstants tableName]])
    {
        sourceToAdd = [[Source alloc] initWithKey:[KeyField text]
                                        AndWithValues:[SourceConstants attributeDefaultValues]];
    
        [[sourceToAdd attributes] setObject:[LatitudeField text] forKey:SRC_LATITUDE];
        [[sourceToAdd attributes] setObject:[LongitudeField text] forKey:SRC_LONGITUDE];
        [[sourceToAdd attributes] setObject:[DateField text] forKey:SRC_DATE_COLLECTED];
    
        AddSampleTwoViewController *astViewController = [[AddSampleTwoViewController alloc] initWithSource:sourceToAdd WithLibraryObject:libraryObjectStore];
    
        [astViewController setLibraryObjectStore:libraryObjectStore];
        [[self navigationController] pushViewController:astViewController  animated:YES];
    }
    
    else
    {
        NSString *message = @"Source already exist for key '";
        message = [message stringByAppendingString:[KeyField text]];
        message = [message stringByAppendingString:@"'"];
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:message
                              message:nil
                              delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil, nil];
        [alert show];
    }
}


-(void) goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    locationManager = [[CLLocationManager alloc] init];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //uncomment to get the time only
    //[formatter setDateFormat:@"hh:mm a"];
    //[formatter setDateFormat:@"MMM dd, YYYY"];
    [formatter setDateStyle:NSDateFormatterMediumStyle];
    
    
    //get the date today
    NSString *dateToday = [formatter stringFromDate:[NSDate date]];
    
    DateField.text = dateToday;
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

- (IBAction)getLocation:(id)sender
{
    locationManager.delegate = self;
    locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    
    [locationManager startUpdatingLocation];
}

#pragma mark - CLLocationManagerDelegate

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
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        LatitudeField.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        LongitudeField.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
    }
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
    const int movementDistance = 30; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

@end
