//
//  ProcedureListViewController.m
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 2/17/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "ProcedureListViewController.h"
#import "Sample.h"
#import "Procedures.h"
#import "PrimitiveProcedures.h"
#import "AbstractCloudLibraryObjectStore.h"
#import "SimpleDBLibraryObjectStore.h"

@interface ProcedureListViewController ()
{
    NSMutableArray *procedureNames;
     SimpleDBLibraryObjectStore *libraryObjectStore;
}
@end

@implementation ProcedureListViewController
@synthesize selectedSample;

- (id)initWithSample:(Sample*)initSample {
    // Call the superclass's designated initializer
    
    libraryObjectStore = [[SimpleDBLibraryObjectStore alloc] initInLocalDirectory:@"ProjectCrystalBlue/Data" WithDatabaseName:@"test_database.db"];
    selectedSample = initSample;
    procedureNames = [[NSMutableArray alloc] init];
    
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
        UINavigationItem *n = [self navigationItem];
        [n setTitle:[selectedSample key]];
        
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc]
                                initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self
                                action:@selector(addNewItem:)];
        UIBarButtonItem *backbtn = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(goBack:)];
        
        [[self navigationItem] setRightBarButtonItem:bbi];
        [[self navigationItem] setLeftBarButtonItem:backbtn];
        
    }
    return self;
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
    return 3;
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
    //Sample *p = [samples objectAtIndex:[indexPath row]];
    NSString *p = [procedureNames objectAtIndex:[indexPath row]];
    [[cell textLabel] setText:p];
    
    return cell;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [procedureNames addObject:@"Jaw Crusher"];
    [procedureNames addObject:@"Pulverizer"];
    [procedureNames addObject:@"Pan-Up"];
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *dummyInitials = @"ANONYMOUS";
    if([indexPath row] == 0)
    {
        [Procedures jawCrushSample:selectedSample withInitials:dummyInitials inStore:libraryObjectStore];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if([indexPath row] == 1)
    {
        [Procedures pulverizeSample:selectedSample withInitials:dummyInitials inStore:libraryObjectStore];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if([indexPath row] == 2)
    {
        [Procedures panUpSample:selectedSample withInitials:dummyInitials inStore:libraryObjectStore];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}


@end
