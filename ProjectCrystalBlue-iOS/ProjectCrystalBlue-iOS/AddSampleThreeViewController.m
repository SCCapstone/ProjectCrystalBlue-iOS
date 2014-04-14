//
//  AddSampleThreeViewController.m
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 3/1/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//


#import "Source.h"
#import "AddSampleThreeViewController.h"
#import "AddSampleFourViewController.h"
#import "AddSampleFiveViewController.h"

@interface AddSampleThreeViewController ()
{
    NSArray *lithArray;
}
@end

@implementation AddSampleThreeViewController

@synthesize sourceToAdd, libraryObjectStore, typeSelected, numRows;

- (id)initWithSource:(Source *)initSource WithLibraryObject:(AbstractCloudLibraryObjectStore *) initLibrary
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        sourceToAdd = initSource;
        libraryObjectStore = initLibrary;
        lithArray = [[NSArray alloc] init];
        
        UINavigationItem *n = [self navigationItem];
        [n setTitle:@"Select Lithology"];
        
        UIBarButtonItem *backbtn = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(goBack:)];
        
        [[self navigationItem] setLeftBarButtonItem:backbtn];
    }
    return self;
}


-(void) goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return numRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"UITableViewCell"];
    }
    
    NSString *p = [lithArray objectAtIndex:[indexPath row]];
    [[cell textLabel] setText:p];
    return cell;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    lithArray = [SourceConstants lithologiesForRockType:typeSelected];
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *lithologySelected = [lithArray objectAtIndex:indexPath.row];
    NSArray *deposystems = [SourceConstants deposystemsForRockType:typeSelected];
    
    // Has available deposystems, next view
    if (deposystems) {
        AddSampleFourViewController *viewControllerFour = [[AddSampleFourViewController alloc] initWithSource:sourceToAdd WithLibraryObject:libraryObjectStore];
        [viewControllerFour setTypeSelected:typeSelected];
        [viewControllerFour setNumRows:deposystems.count];
        [sourceToAdd.attributes setObject:lithologySelected forKey:SRC_LITHOLOGY];
        [[self navigationController] pushViewController:viewControllerFour animated:YES];
    }
    // No deposystems available, skip fifth view
    else {
        AddSampleFiveViewController *viewControllerFive = [[AddSampleFiveViewController alloc] initWithSource:sourceToAdd WithLibraryObject:libraryObjectStore];
        
        // If lithology selected is unknown, set to empty string
        lithologySelected = [lithologySelected isEqualToString:@"Unknown"] ? @"" : lithologySelected;
        [sourceToAdd.attributes setObject:lithologySelected forKey:SRC_LITHOLOGY];
        [sourceToAdd.attributes setObject:@"" forKey:SRC_DEPOSYSTEM];
        [[self navigationController] pushViewController:viewControllerFive animated:YES];
    }
}

@end
