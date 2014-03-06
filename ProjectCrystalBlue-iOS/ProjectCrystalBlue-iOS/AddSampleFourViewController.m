//
//  AddSampleFourViewController.m
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 3/1/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "Source.h"
#import "AddSampleFourViewController.h"
#import "AddSampleFiveViewController.h"

@interface AddSampleFourViewController ()
{
    NSMutableArray *depoArray;
}
@end

@implementation AddSampleFourViewController

@synthesize sourceToAdd, libraryObjectStore, typeSelected, numRows;

- (id)initWithSource:(Source *)initSource WithLibraryObject:(AbstractCloudLibraryObjectStore *) initLibrary
{
    sourceToAdd = initSource;
    libraryObjectStore = initLibrary;
    depoArray = [[NSMutableArray alloc] init];
    
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
        UINavigationItem *n = [self navigationItem];
        [n setTitle:@"Select Deposystem"];
        
        
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
    return numRows;
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
    
    NSString *p = [depoArray objectAtIndex:[indexPath row]];
    
    [[cell textLabel] setText:p];
    return cell;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([typeSelected isEqualToString:@"Siliciclastic"]) {
        [depoArray addObject:@"Alluvial Fan"];
        [depoArray addObject:@"Fluvial Megafan"];
        [depoArray addObject:@"Meandering Fluvial"];
        [depoArray addObject:@"Alpine Glacial"];
        [depoArray addObject:@"Ice Sheet"];
        [depoArray addObject:@"Lacustrine"];
        [depoArray addObject:@"Eolian"];
        [depoArray addObject:@"Deltac"];
        [depoArray addObject:@"Estuarine"];
        [depoArray addObject:@"Shallow Marine"];
        [depoArray addObject:@"Shelf"];
        [depoArray addObject:@"Pelagic"];
        [depoArray addObject:@"Alluvial Fan"];
        [depoArray addObject:@"Submarine Fan"];
        [depoArray addObject:@"Unknown"];
    }
    
    if ([typeSelected isEqualToString:@"Carbonate"]) {
        [depoArray addObject:@"Carbonate Platform"];
        [depoArray addObject:@"Carbonate Reef"];
        [depoArray addObject:@"Pelagic"];
        [depoArray addObject:@"Eolian"];
        [depoArray addObject:@"Unknown"];
    }
   
    
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddSampleFiveViewController *asfViewController = [[AddSampleFiveViewController alloc] initWithSource:sourceToAdd WithLibraryObject:libraryObjectStore];
    
    if ([typeSelected isEqualToString:@"Siliciclastic"]) {
        if ([indexPath row] == 0)
        {
            [[sourceToAdd attributes] setObject:@"Alluvial Fan" forKey:SRC_DEPOSYSTEM];
            [[self navigationController] pushViewController:asfViewController  animated:YES];
        }
        
        if ([indexPath row] == 1)
        {
            [[sourceToAdd attributes] setObject:@"Fluvial Megafan" forKey:SRC_DEPOSYSTEM];
            [[self navigationController] pushViewController:asfViewController  animated:YES];
        }
        
        if ([indexPath row] == 2)
        {
            [[sourceToAdd attributes] setObject:@"Meandearing Fluvial" forKey:SRC_DEPOSYSTEM];
            [[self navigationController] pushViewController:asfViewController  animated:YES];
        }
        
        if ([indexPath row] == 3)
        {
            [[sourceToAdd attributes] setObject:@"Braided Fluvial" forKey:SRC_DEPOSYSTEM];
            [[self navigationController] pushViewController:asfViewController  animated:YES];
        }
        
        if ([indexPath row] == 4)
        {
            [[sourceToAdd attributes] setObject:@"Alpine Glacial" forKey:SRC_DEPOSYSTEM];
            [[self navigationController] pushViewController:asfViewController  animated:YES];
        }
        
        if ([indexPath row] == 5)
        {
            [[sourceToAdd attributes] setObject:@"Ice Sheet" forKey:SRC_DEPOSYSTEM];
            [[self navigationController] pushViewController:asfViewController  animated:YES];
        }
        
        if ([indexPath row] == 6)
        {
            [[sourceToAdd attributes] setObject:@"Lacustrine" forKey:SRC_DEPOSYSTEM];
            [[self navigationController] pushViewController:asfViewController  animated:YES];
        }
        
        if ([indexPath row] == 7)
        {
            [[sourceToAdd attributes] setObject:@"Eolian" forKey:SRC_DEPOSYSTEM];
            [[self navigationController] pushViewController:asfViewController  animated:YES];
        }
        
        if ([indexPath row] == 8)
        {
            [[sourceToAdd attributes] setObject:@"Deltaic" forKey:SRC_DEPOSYSTEM];
            [[self navigationController] pushViewController:asfViewController  animated:YES];
        }
        
        if ([indexPath row] == 9)
        {
            [[sourceToAdd attributes] setObject:@"Estuarine" forKey:SRC_DEPOSYSTEM];
            [[self navigationController] pushViewController:asfViewController  animated:YES];
        }
        
        if ([indexPath row] == 10)
        {
            [[sourceToAdd attributes] setObject:@"Shallow Marine" forKey:SRC_DEPOSYSTEM];
            [[self navigationController] pushViewController:asfViewController  animated:YES];
        }
        
        if ([indexPath row] == 11)
        {
            [[sourceToAdd attributes] setObject:@"Shelf" forKey:SRC_DEPOSYSTEM];
            [[self navigationController] pushViewController:asfViewController  animated:YES];
        }
        
        if ([indexPath row] == 12)
        {
            [[sourceToAdd attributes] setObject:@"Pelagic" forKey:SRC_DEPOSYSTEM];
            [[self navigationController] pushViewController:asfViewController  animated:YES];
        }
        
        if ([indexPath row] == 13)
        {
            [[sourceToAdd attributes] setObject:@"Submarine Fan" forKey:SRC_DEPOSYSTEM];
            [[self navigationController] pushViewController:asfViewController  animated:YES];
        }
        
        if ([indexPath row] == 14)
        {
            [[sourceToAdd attributes] setObject:@"N/A" forKey:SRC_DEPOSYSTEM];
            [[self navigationController] pushViewController:asfViewController  animated:YES];
        }
    }
    
    if ([typeSelected isEqualToString:@"Carbonate"]) {
        if ([indexPath row] == 0)
        {
            [[sourceToAdd attributes] setObject:@"Carbonate Platform" forKey:SRC_DEPOSYSTEM];
            [[self navigationController] pushViewController:asfViewController  animated:YES];
        }
        
        if ([indexPath row] == 1)
        {
            [[sourceToAdd attributes] setObject:@"Carbonate Reef" forKey:SRC_DEPOSYSTEM];
            [[self navigationController] pushViewController:asfViewController  animated:YES];
        }
        
        if ([indexPath row] == 2)
        {
            [[sourceToAdd attributes] setObject:@"Pelagic" forKey:SRC_DEPOSYSTEM];
            [[self navigationController] pushViewController:asfViewController  animated:YES];
        }
        
        if ([indexPath row] == 3)
        {
            [[sourceToAdd attributes] setObject:@"Eolian" forKey:SRC_DEPOSYSTEM];
            [[self navigationController] pushViewController:asfViewController  animated:YES];
        }
        
        if ([indexPath row] == 4)
        {
            [[sourceToAdd attributes] setObject:@"N/A" forKey:SRC_DEPOSYSTEM];
            [[self navigationController] pushViewController:asfViewController  animated:YES];
        }
    }
}

@end
