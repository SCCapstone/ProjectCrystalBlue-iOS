//
//  AddSampleTwoViewController.m
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 3/1/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "AddSampleTwoViewController.h"
#import "Source.h"
#import "AddSampleThreeViewController.h"
#import "AddSampleFiveViewController.h"

@interface AddSampleTwoViewController ()
{
    NSArray *typeArray;
}
@end

@implementation AddSampleTwoViewController

@synthesize sourceToAdd, libraryObjectStore;

- (id)initWithSource:(Source *)initSource WithLibraryObject:(AbstractCloudLibraryObjectStore *) initLibrary
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        sourceToAdd = initSource;
        libraryObjectStore = initLibrary;
        typeArray = [[NSArray alloc] init];
        
        UINavigationItem *n = [self navigationItem];
        [n setTitle:@"Select Type"];
        
        
        UIBarButtonItem *backbtn = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(goBack:)];
        
        [[self navigationItem] setLeftBarButtonItem:backbtn];
        
    }
    return self;
}

-(void) goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (id)initWithStyle:(UITableViewStyle)style {
    return [self init]; }

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
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
    
    NSString *p = [typeArray objectAtIndex:[indexPath row]];
    
    [[cell textLabel] setText:p];
    return cell;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    typeArray = [SourceConstants rockTypes];
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *typeSelected = [typeArray objectAtIndex:indexPath.row];
    NSArray *lithologies = [SourceConstants lithologiesForRockType:typeSelected];
    
    // Has available lithologies, next view
    if (lithologies) {
        AddSampleThreeViewController *viewControllerThree = [[AddSampleThreeViewController alloc] initWithSource:sourceToAdd
                                                                                               WithLibraryObject:libraryObjectStore];
        [viewControllerThree setTypeSelected:typeSelected];
        [viewControllerThree setNumRows:lithologies.count];
        [sourceToAdd.attributes setObject:typeSelected forKey:SRC_TYPE];
        [[self navigationController] pushViewController:viewControllerThree animated:YES];
    }
    // Does not, skip to fifth view
    else {
        AddSampleFiveViewController *viewControllerFive = [[AddSampleFiveViewController alloc] initWithSource:sourceToAdd
                                                                                            WithLibraryObject:libraryObjectStore];
        // If type selected is unknown, set to empty string
        typeSelected = [typeSelected isEqualToString:@"Unknown"] ? @"" : typeSelected;
        [sourceToAdd.attributes setObject:typeSelected forKey:SRC_TYPE];
        [sourceToAdd.attributes setObject:@"" forKey:SRC_LITHOLOGY];
        [sourceToAdd.attributes setObject:@"" forKey:SRC_DEPOSYSTEM];
        [[self navigationController] pushViewController:viewControllerFive animated:YES];
    }
}

@end
