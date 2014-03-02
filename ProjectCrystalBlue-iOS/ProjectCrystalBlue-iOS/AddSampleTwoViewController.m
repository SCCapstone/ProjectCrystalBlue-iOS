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

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddSampleThreeViewController *astViewController = [[AddSampleThreeViewController alloc] initWithSource:sourceToAdd];
    
    if ([indexPath row] == 0)
    {
        [astViewController setTypeSelected:@"Siliciclastic"];
        [astViewController setNumRows:8];
        [[sourceToAdd attributes] setObject:@"Siliciclastic" forKey:SRC_LATITUDE];
        [[self navigationController] pushViewController:astViewController  animated:YES];
    }
    
    if ([indexPath row] == 1)
    {
        [astViewController setTypeSelected:@"Carbonate"];
        [astViewController setNumRows:7];
        [[sourceToAdd attributes] setObject:@"Carbonate" forKey:SRC_LATITUDE];
        [astViewController setSourceToAdd:sourceToAdd];
        [[self navigationController] pushViewController:astViewController  animated:YES];
    }
    
    if ([indexPath row] == 2)
    {
        [astViewController setTypeSelected:@"Authigenic"];
        [astViewController setNumRows:2];
        [[sourceToAdd attributes] setObject:@"Authigenic" forKey:SRC_LATITUDE];
        [astViewController setSourceToAdd:sourceToAdd];
        [[self navigationController] pushViewController:astViewController  animated:YES];
    }
    
    if ([indexPath row] == 3)
    {
        [astViewController setTypeSelected:@"Plutonic"];
        [astViewController setNumRows:9];
        [[sourceToAdd attributes] setObject:@"Plutonic" forKey:SRC_LATITUDE];
        [astViewController setSourceToAdd:sourceToAdd];
        [[self navigationController] pushViewController:astViewController  animated:YES];
    }
    
    if ([indexPath row] == 4)
    {
        [astViewController setTypeSelected:@"Volcanic"];
        [astViewController setNumRows:7];
         [[sourceToAdd attributes] setObject:@"Volcanic" forKey:SRC_LATITUDE];
        [astViewController setSourceToAdd:sourceToAdd];
        [[self navigationController] pushViewController:astViewController  animated:YES];
    }
    
    if ([indexPath row] == 5)
    {
        [astViewController setTypeSelected:@"Metasedimentary"];
        [astViewController setNumRows:5];
         [[sourceToAdd attributes] setObject:@"Metasedimentary" forKey:SRC_LATITUDE];
        [astViewController setSourceToAdd:sourceToAdd];
        [[self navigationController] pushViewController:astViewController  animated:YES];
    }
    
    if ([indexPath row] == 6)
    {
        [astViewController setTypeSelected:@"Metaigneous"];
        [astViewController setNumRows:6];
         [[sourceToAdd attributes] setObject:@"Metaigneous" forKey:SRC_LATITUDE];
        [astViewController setSourceToAdd:sourceToAdd];
        [[self navigationController] pushViewController:astViewController  animated:YES];
    }
    
    if ([indexPath row] == 7)
    {
        [astViewController setTypeSelected:@"Igneous"];
    }
    
    if ([indexPath row] == 8)
    {
        [astViewController setTypeSelected:@"Metamorphic"];
    }
    
    if ([indexPath row] == 9)
    {
        [astViewController setTypeSelected:@"Unknown"];
    }
}

@end
