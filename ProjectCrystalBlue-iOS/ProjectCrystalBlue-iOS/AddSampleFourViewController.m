//
//  AddSampleFourViewController.m
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 3/1/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "Source.h"
#import "AddSampleFourViewController.h"

@interface AddSampleFourViewController ()
{
    NSMutableArray *depoArray;
}
@end

@implementation AddSampleFourViewController

@synthesize sourceToAdd, libraryObjectStore, typeSelected, numRows;

-(id)initWithSource:(Source *)initSource
{
    sourceToAdd = initSource;
    depoArray = [[NSMutableArray alloc] init];
    
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
        UINavigationItem *n = [self navigationItem];
        [n setTitle:@"Select Deposystem"];
        
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:self action:@selector(addSource:)];
        
        UIBarButtonItem *backbtn = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(goBack:)];
        
        [[self navigationItem] setRightBarButtonItem:bbi];
        [[self navigationItem] setLeftBarButtonItem:backbtn];
        
    }
    return self;
}

- (IBAction)addSource:(id)sender {
    
    
    
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
    if ([typeSelected isEqualToString:@"Siliciclastic"]) {
        if ([indexPath row] == 0)
        {
            
        }
        
        if([indexPath row] == 1)
        {
            
        }
    }
    
}

@end
