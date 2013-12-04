//
//  AddSampleViewController.m
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 12/4/13.
//  Copyright (c) 2013 Project Crystal Blue. All rights reserved.
//

#import "AddSampleViewController.h"
#import "SampleListViewController.h"
#import "Sample.h"

@interface AddSampleViewController ()

@end

@implementation AddSampleViewController

@synthesize nameField;
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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBActions

-(void)canceLButtonPressed:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}

-(void)nextButtonPressed:(id)sender{
    Sample *newSample = [[Sample alloc] initWithName:self.nameField.text pulverized:NO];
    [self.sampleListViewController.samples addObject:newSample];
    [self dismissModalViewControllerAnimated:YES];
   
}

@end
