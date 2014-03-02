//
//  AddSampleTwoViewController.m
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 3/1/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "AddSampleTwoViewController.h"
#import "Source.h"

@interface AddSampleTwoViewController ()
{
    NSMutableArray *typeArray;
}
@end

@implementation AddSampleTwoViewController

@synthesize sourceToAdd, libraryObjectStore;

-(id)initWithSource:(Source *)initSource
{
    sourceToAdd = initSource;
    typeArray = [[NSMutableArray alloc] init];
    
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
        UINavigationItem *n = [self navigationItem];
        [n setTitle:@"Select Type"];
        
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
    [typeArray addObject:@"Siliciclastic"];
    [typeArray addObject:@"Carbonate"];
    [typeArray addObject:@"Authigenic"];
    [typeArray addObject:@"Plutonic"];
    [typeArray addObject:@"Volcanic"];
    [typeArray addObject:@"Metasedimentary"];
    [typeArray addObject:@"Metaigneous"];
    [typeArray addObject:@"Igneous"];
    [typeArray addObject:@"Metamorphic"];
    [typeArray addObject:@"Unknown"];
}

@end
