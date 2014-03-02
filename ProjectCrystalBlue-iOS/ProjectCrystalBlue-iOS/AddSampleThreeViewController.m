//
//  AddSampleThreeViewController.m
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 3/1/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//


#import "Source.h"
#import "AddSampleThreeViewController.h"

@interface AddSampleThreeViewController ()
{
    NSMutableArray *lithArray;
}
@end

@implementation AddSampleThreeViewController

@synthesize sourceToAdd, libraryObjectStore, typeSelected, numRows;

-(id)initWithSource:(Source *)initSource
{
    sourceToAdd = initSource;
    lithArray = [[NSMutableArray alloc] init];
    
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
        UINavigationItem *n = [self navigationItem];
        [n setTitle:@"Select Lithology"];
        
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
    
    NSString *p = [lithArray objectAtIndex:[indexPath row]];
    
    [[cell textLabel] setText:p];
    return cell;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    if ([typeSelected isEqualToString:@"Siliciclastic"]) {
        [lithArray addObject:@"Conglomerate"];
        [lithArray addObject:@"Breccia"];
        [lithArray addObject:@"Sandstone"];
        [lithArray addObject:@"Mudstone"];
        [lithArray addObject:@"Gravel"];
        [lithArray addObject:@"Sand"];
        [lithArray addObject:@"Mud"];
        [lithArray addObject:@"Blank"];
    }
    if ([typeSelected isEqualToString:@"Carbonate"]) {
        [lithArray addObject:@"Marl"];
        [lithArray addObject:@"Micrate"];
        [lithArray addObject:@"Wackestone"];
        [lithArray addObject:@"Packstone"];
        [lithArray addObject:@"Grainstone"];
        [lithArray addObject:@"BoundStone"];
        [lithArray addObject:@"Blank"];
    }
    
    if ([typeSelected isEqualToString:@"Authigenic"]) {
        [lithArray addObject:@"Glauconite"];
        [lithArray addObject:@"Blank"];
    }
    
    if ([typeSelected isEqualToString:@"Plutonic"]) {
        [lithArray addObject:@"Granitoid"];
        [lithArray addObject:@"Granite"];
        [lithArray addObject:@"Granodiorite"];
        [lithArray addObject:@"Tonalite"];
        [lithArray addObject:@"Diorite"];
        [lithArray addObject:@"Gabbro"];
        [lithArray addObject:@"Monzonite"];
        [lithArray addObject:@"Syenite"];
        [lithArray addObject:@"Blank"];
    }
    
    if ([typeSelected isEqualToString:@"Volcanic"]) {
        [lithArray addObject:@"Ash"];
        [lithArray addObject:@"Rhyolite"];
        [lithArray addObject:@"Dacite"];
        [lithArray addObject:@"Andesite"];
        [lithArray addObject:@"Basalt"];
        [lithArray addObject:@"Trachyte"];
        [lithArray addObject:@"Blank"];
    }
    
    if ([typeSelected isEqualToString:@"Metasedimentary"]) {
        [lithArray addObject:@"Slate"];
        [lithArray addObject:@"Phyllite"];
        [lithArray addObject:@"Schist"];
        [lithArray addObject:@"Gneiss"];
        [lithArray addObject:@"Blank"];
    }
    
    if ([typeSelected isEqualToString:@"Metaigneous"]) {
        [lithArray addObject:@"Felsic Orthoschist"];
        [lithArray addObject:@"Felsic Orthogneiss"];
        [lithArray addObject:@"Intermediate Orthoschist"];
        [lithArray addObject:@"Intermediate Orthogneiss"];
        [lithArray addObject:@"Amphobite"];
        [lithArray addObject:@"Blank"];
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

@end
