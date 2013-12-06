//
//  EditTaskViewController.m
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 12/4/13.
//  Copyright (c) 2013 Project Crystal Blue. All rights reserved.
//

#import "EditTaskViewController.h"
#import "Sample.h"

@interface EditTaskViewController ()

@end

@implementation EditTaskViewController

@synthesize nameField = _nameField;
@synthesize rocktypeField = _rocktypeField;
@synthesize locationField = _locationField;
@synthesize isPulverizedField = _isPulverizedField;
@synthesize sample = _sample;

@synthesize sampleListViewController;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.nameField.text = [NSString stringWithFormat:(@"%d"), (int)self.sample.rockId];
    self.rocktypeField.text = self.sample.rockType;
    self.locationField.text = self.sample.coordinates;
    self.isPulverizedField.text = self.sample.isPulverized ? @"YES" : @"NO";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

- (void)sampleDataChanged:(id)sender{
    self.sample.rockId = [self.nameField.text integerValue];
    self.sample.rockType = self.rocktypeField.text;
    self.sample.coordinates = self.locationField.text;
    self.sample.isPulverized = [self.isPulverizedField.text boolValue];
    [sampleListViewController.database updateSample:self.sample];
}

@end
