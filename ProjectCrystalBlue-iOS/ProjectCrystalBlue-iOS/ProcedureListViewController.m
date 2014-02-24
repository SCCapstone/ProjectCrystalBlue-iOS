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
    return 23;
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
    [procedureNames addObject:@"Move Sample"];
    [procedureNames addObject:@"Make Slab"];
    [procedureNames addObject:@"Make Billet"];
    [procedureNames addObject:@"Make Thin Section"];
    [procedureNames addObject:@"Trim"];
    [procedureNames addObject:@"Pulverizer"];
    [procedureNames addObject:@"Jaw Crusher"];
    [procedureNames addObject:@"Gemini Up"];
    [procedureNames addObject:@"Gemini Down"];
    [procedureNames addObject:@"Pan Up"];
    [procedureNames addObject:@"Pan Down"];
    [procedureNames addObject:@"Sieves Up"];
    [procedureNames addObject:@"Sieves Down"];
    [procedureNames addObject:@"Heavy Liquid 330 Up"];
    [procedureNames addObject:@"Heavy Liquid 330 Down"];
    [procedureNames addObject:@"Heavy Liquid 290 Up"];
    [procedureNames addObject:@"Heavy Liquid 290 Down"];
    [procedureNames addObject:@"Heavy Liquid 265 Up"];
    [procedureNames addObject:@"Heavy Liquid 265 Down"];
    [procedureNames addObject:@"Heavy Liquid 255 Up"];
    [procedureNames addObject:@"Heavy Liquid 255 Down"];
    [procedureNames addObject:@"Hand Magnet Up"];
    [procedureNames addObject:@"Hand Magnet Down"];
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *dummyInitials = @"ANONYMOUS";
    if ([indexPath row] == 0) {
        
    }
    
    if([indexPath row] == 1)
    {
        [Procedures makeSlabfromSample:selectedSample withInitials:dummyInitials inStore:libraryObjectStore];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if([indexPath row] == 2)
    {
        [Procedures makeBilletfromSample:selectedSample withInitials:dummyInitials inStore:libraryObjectStore];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if([indexPath row] == 3)
    {
        [Procedures makeThinSectionfromSample:selectedSample withInitials:dummyInitials inStore:libraryObjectStore];
        [self.navigationController popViewControllerAnimated:YES];
    }
    if([indexPath row] == 4)
    {
        [Procedures trimSample:selectedSample withInitials:dummyInitials inStore:libraryObjectStore];
        [self.navigationController popViewControllerAnimated:YES];    }
    
    if([indexPath row] == 5)
    {
        [Procedures pulverizeSample:selectedSample withInitials:dummyInitials inStore:libraryObjectStore];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if([indexPath row] == 6)
    {
        [Procedures jawCrushSample:selectedSample withInitials:dummyInitials inStore:libraryObjectStore];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if([indexPath row] == 7)
    {
        [Procedures geminiUpSample:selectedSample withInitials:dummyInitials inStore:libraryObjectStore];
        [self.navigationController popViewControllerAnimated:YES];    }
    
    if([indexPath row] == 8)
    {
        [Procedures geminiDownSample:selectedSample withInitials:dummyInitials inStore:libraryObjectStore];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if([indexPath row] == 9)
    {
        [Procedures panUpSample:selectedSample withInitials:dummyInitials inStore:libraryObjectStore];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if([indexPath row] == 10)
    {
        [Procedures panDownSample:selectedSample withInitials:dummyInitials inStore:libraryObjectStore];
        [self.navigationController popViewControllerAnimated:YES];    }
    
    if([indexPath row] == 11)
    {
        [Procedures sievesTenUpSample:selectedSample withInitials:dummyInitials inStore:libraryObjectStore];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if([indexPath row] == 12)
    {
        [Procedures sievesTenDownSample:selectedSample withInitials:dummyInitials inStore:libraryObjectStore];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if([indexPath row] == 13)
    {
        [Procedures heavyLiquid_330_UpSample:selectedSample withInitials:dummyInitials inStore:libraryObjectStore];
        [self.navigationController popViewControllerAnimated:YES];    }
    
    if([indexPath row] == 14)
    {
        [Procedures heavyLiquid_330_DownSample:selectedSample withInitials:dummyInitials inStore:libraryObjectStore];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if([indexPath row] == 15)
    {
        [Procedures heavyLiquid_290_UpSample:selectedSample withInitials:dummyInitials inStore:libraryObjectStore];
        [self.navigationController popViewControllerAnimated:YES];    }
    
    if([indexPath row] == 16)
    {
        [Procedures heavyLiquid_290_DownSample:selectedSample withInitials:dummyInitials inStore:libraryObjectStore];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if([indexPath row] == 17)
    {
        [Procedures heavyLiquid_265_UpSample:selectedSample withInitials:dummyInitials inStore:libraryObjectStore];
        [self.navigationController popViewControllerAnimated:YES];    }
    
    if([indexPath row] == 18)
    {
        [Procedures heavyLiquid_265_DownSample:selectedSample withInitials:dummyInitials inStore:libraryObjectStore];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if([indexPath row] == 19)
    {
        [Procedures heavyLiquid_255_UpSample:selectedSample withInitials:dummyInitials inStore:libraryObjectStore];
        [self.navigationController popViewControllerAnimated:YES];    }
    
    if([indexPath row] == 20)
    {
        [Procedures heavyLiquid_255_DownSample:selectedSample withInitials:dummyInitials inStore:libraryObjectStore];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if([indexPath row] == 21)
    {
        [Procedures handMagnetUpSample:selectedSample withInitials:dummyInitials inStore:libraryObjectStore];
        [self.navigationController popViewControllerAnimated:YES];    }
    
    if([indexPath row] == 22)
    {
        [Procedures handMagnetDownSample:selectedSample withInitials:dummyInitials inStore:libraryObjectStore];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}


@end
