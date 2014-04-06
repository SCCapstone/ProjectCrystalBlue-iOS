//
//  AddSampleAgeViewController.m
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 3/31/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "AddSampleAgeViewController.h"
#import "AddSampleSevenViewController.h"
#import "Source.h"

@interface AddSampleAgeViewController ()
{
    NSMutableArray *ageArray;
}
@end

@implementation AddSampleAgeViewController
@synthesize sourceToAdd, libraryObjectStore;

- (id)initWithSource:(Source *)initSource WithLibraryObject:(AbstractCloudLibraryObjectStore *) initLibrary
{
    sourceToAdd = initSource;
    libraryObjectStore = initLibrary;
    ageArray = [[NSMutableArray alloc] init];
    
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
        UINavigationItem *n = [self navigationItem];
        [n setTitle:@"Select Age Method"];
        
        
        UIBarButtonItem *backbtn = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(goBack:)];
        
        [[self navigationItem] setLeftBarButtonItem:backbtn];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [ageArray addObject:@"Biostratigraphy"];
    [ageArray addObject:@"Magnetostratigraphy"];
    [ageArray addObject:@"Chemostratigraphy"];
    [ageArray addObject:@"Geochronology"];
    [ageArray addObject:@"Thermochronology"];
    [ageArray addObject:@"Unknown"];
}

-(void) goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (id)initWithStyle:(UITableViewStyle)style {
    return [self init];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Create an instance of UITableViewCell, with default appearance
    // Check for a reusable cell first, use that if it exists
    UITableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    // If there is no reusable cell of this type, create a new one
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"UITableViewCell"];
    }
    // Set the text on the cell with the description of the item // that is at the nth index of items, where n = row this cell // will appear in on the tableview
    
    NSString *p = [ageArray objectAtIndex:[indexPath row]];
    
    [[cell textLabel] setText:p];
    return cell;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddSampleSevenViewController *assViewController = [[AddSampleSevenViewController alloc] initWithSource:sourceToAdd WithLibraryObject:libraryObjectStore];

    if ([indexPath row] == 0)
    {
        [[sourceToAdd attributes] setObject:@"Biostratigraphy" forKey:SRC_AGE_METHOD];
        [[self navigationController] pushViewController:assViewController  animated:YES];
    }
    
    if ([indexPath row] == 1)
    {
        [[sourceToAdd attributes] setObject:@"Magnetostratigraphy" forKey:SRC_AGE_METHOD];
        [[self navigationController] pushViewController:assViewController  animated:YES];
    }
    
    if ([indexPath row] == 2)
    {
        [[sourceToAdd attributes] setObject:@"Chemostratigraphy" forKey:SRC_AGE_METHOD];
        [[self navigationController] pushViewController:assViewController  animated:YES];
    }
    
    if ([indexPath row] == 3)
    {
        [[sourceToAdd attributes] setObject:@"Geochronology" forKey:SRC_AGE_METHOD];
        [[self navigationController] pushViewController:assViewController  animated:YES];
    }
    
    if ([indexPath row] == 4)
    {
        [[sourceToAdd attributes] setObject:@"Thermochronology" forKey:SRC_AGE_METHOD];
        [[self navigationController] pushViewController:assViewController  animated:YES];
    }
    
    if ([indexPath row] == 5)
    {
        [[sourceToAdd attributes] setObject:@"N/A" forKey:SRC_AGE_METHOD];
        [[self navigationController] pushViewController:assViewController  animated:YES];
    }
}


@end