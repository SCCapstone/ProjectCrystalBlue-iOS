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
#import "ProcedureNameConstants.h"

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
    return [self init];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 22;
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
    [procedureNames addObject:@"Gemini"];
    [procedureNames addObject:@"Pan"];
    [procedureNames addObject:@"Sieves"];
    [procedureNames addObject:@"Heavy Liquid 330"];
    [procedureNames addObject:@"Heavy Liquid 290"];
    [procedureNames addObject:@"Heavy Liquid 265"];
    [procedureNames addObject:@"Heavy Liquid 255"];
    [procedureNames addObject:@"Hand Magnet"];
    [procedureNames addObject:@"Magnet 0.2 Amps"];
    [procedureNames addObject:@"Magnet 0.4 Amps"];
    [procedureNames addObject:@"Magnet 0.6 Amps"];
    [procedureNames addObject:@"Magnet 0.8 Amps"];
    [procedureNames addObject:@"Magnet 1.0 Amps"];
    [procedureNames addObject:@"Magnet 1.2 Amps"];
    [procedureNames addObject:@"Magnet 1.4 Amps"];

    
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
        [Procedures geminiSample:selectedSample withInitials:dummyInitials inStore:libraryObjectStore];
        [self.navigationController popViewControllerAnimated:YES];    }
    
    
    if([indexPath row] == 8)
    {
        [Procedures panSample:selectedSample withInitials:dummyInitials inStore:libraryObjectStore];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if([indexPath row] == 9)
    {
        [Procedures sievesTenSample:selectedSample withInitials:dummyInitials inStore:libraryObjectStore];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
    if([indexPath row] == 10)
    {
        [Procedures heavyLiquid_330_Sample:selectedSample withInitials:dummyInitials inStore:libraryObjectStore];
        [self.navigationController popViewControllerAnimated:YES];    }
    
    
    if([indexPath row] == 11)
    {
        [Procedures heavyLiquid_290_Sample:selectedSample withInitials:dummyInitials inStore:libraryObjectStore];
        [self.navigationController popViewControllerAnimated:YES];    }
    
   
    
    if([indexPath row] == 12)
    {
        [Procedures heavyLiquid_265_Sample:selectedSample withInitials:dummyInitials inStore:libraryObjectStore];
        [self.navigationController popViewControllerAnimated:YES];    }
    
    
    if([indexPath row] == 13)
    {
        [Procedures heavyLiquid_255_Sample:selectedSample withInitials:dummyInitials inStore:libraryObjectStore];
        [self.navigationController popViewControllerAnimated:YES];    }
    
    
    if([indexPath row] == 14)
    {
        [Procedures handMagnetSample:selectedSample withInitials:dummyInitials inStore:libraryObjectStore];
        [self.navigationController popViewControllerAnimated:YES];    }
    
    
    if([indexPath row] == 15)
    {
        [Procedures  magnet02AmpsSample:selectedSample withInitials:dummyInitials inStore:libraryObjectStore];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
    if([indexPath row] == 16)
    {
        [Procedures  magnet04AmpsSample:selectedSample withInitials:dummyInitials inStore:libraryObjectStore];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
    if([indexPath row] == 17)
    {
        [Procedures  magnet06AmpsSample:selectedSample withInitials:dummyInitials inStore:libraryObjectStore];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
    if([indexPath row] == 18)
    {
        [Procedures  magnet08AmpsSample:selectedSample withInitials:dummyInitials inStore:libraryObjectStore];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    
    if([indexPath row] == 19)
    {
        [Procedures  magnet10AmpsSample:selectedSample withInitials:dummyInitials inStore:libraryObjectStore];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    if([indexPath row] == 20)
    {
        [Procedures  magnet12AmpsSample:selectedSample withInitials:dummyInitials inStore:libraryObjectStore];
        [self.navigationController popViewControllerAnimated:YES];
    }
  
    if([indexPath row] == 21)
    {
        [Procedures  magnet14AmpsSample:selectedSample withInitials:dummyInitials inStore:libraryObjectStore];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}


@end
