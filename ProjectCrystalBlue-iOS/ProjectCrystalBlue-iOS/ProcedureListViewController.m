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
#import "EditLocationViewController.h"

@interface ProcedureListViewController ()
{
    NSMutableArray *procedureNames0;
    NSMutableArray *procedureNames1;
    NSMutableArray *procedureNames2;
    NSMutableArray *procedureNames3;
    NSMutableArray *procedureNames4;
    SimpleDBLibraryObjectStore *libraryObjectStore;
}
@end

@implementation ProcedureListViewController
@synthesize selectedSample;

- (id)initWithSample:(Sample*)initSample {
    // Call the superclass's designated initializer
    
    libraryObjectStore = [[SimpleDBLibraryObjectStore alloc] initInLocalDirectory:@"ProjectCrystalBlue/Data" WithDatabaseName:@"test_database.db"];
    selectedSample = initSample;
    procedureNames0 = [[NSMutableArray alloc] init];
    procedureNames1 = [[NSMutableArray alloc] init];
    procedureNames2 = [[NSMutableArray alloc] init];
    procedureNames3 = [[NSMutableArray alloc] init];
    procedureNames4 = [[NSMutableArray alloc] init];
    
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
    if(section == 0)
    {
        return 1;
    }
    
    else if(section == 1)
    {
        return 4;
    }
    
    else if(section == 2)
    {
        return 5;
    }
    
    else if(section == 3)
    {
        return 4;
    }
    
    else //section == 4
    {
        return 8;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
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
    
    if (indexPath.section==0)
    {
        NSString *p = [procedureNames0 objectAtIndex:[indexPath row]];
        [[cell textLabel] setText:p];
    }
    
    else if (indexPath.section==1)
    {
        NSString *p = [procedureNames1 objectAtIndex:[indexPath row]];
        [[cell textLabel] setText:p];
    }
    
    else if (indexPath.section==2)
    {
        NSString *p = [procedureNames2 objectAtIndex:[indexPath row]];
        [[cell textLabel] setText:p];
    }
    
    else if (indexPath.section==3)
    {
        NSString *p = [procedureNames3 objectAtIndex:[indexPath row]];
        [[cell textLabel] setText:p];
    }
    
    else //indexPath.section == 4
    {
        NSString *p = [procedureNames4 objectAtIndex:[indexPath row]];
        [[cell textLabel] setText:p];
    }
    return cell;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [procedureNames0 addObject:@"Move Sample"];
    [procedureNames1 addObject:@"Make Slab"];
    [procedureNames1 addObject:@"Make Billet"];
    [procedureNames1 addObject:@"Make Thin Section"];
    [procedureNames1 addObject:@"Trim"];
    [procedureNames2 addObject:@"Pulverizer"];
    [procedureNames2 addObject:@"Jaw Crusher"];
    [procedureNames2 addObject:@"Gemini"];
    [procedureNames2 addObject:@"Pan"];
    [procedureNames2 addObject:@"Sieves"];
    [procedureNames3 addObject:@"Heavy Liquid 330"];
    [procedureNames3 addObject:@"Heavy Liquid 290"];
    [procedureNames3 addObject:@"Heavy Liquid 265"];
    [procedureNames3 addObject:@"Heavy Liquid 255"];
    [procedureNames4 addObject:@"Hand Magnet"];
    [procedureNames4 addObject:@"Magnet 0.2 Amps"];
    [procedureNames4 addObject:@"Magnet 0.4 Amps"];
    [procedureNames4 addObject:@"Magnet 0.6 Amps"];
    [procedureNames4 addObject:@"Magnet 0.8 Amps"];
    [procedureNames4 addObject:@"Magnet 1.0 Amps"];
    [procedureNames4 addObject:@"Magnet 1.2 Amps"];
    [procedureNames4 addObject:@"Magnet 1.4 Amps"];

    
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *dummyInitials = @"ANONYMOUS";
    
    if(indexPath.section == 0)
    {
        if ([indexPath row] == 0)
        {
            EditLocationViewController *editLocationViewController = [[EditLocationViewController alloc] initWithSample:selectedSample];
            [[self navigationController] pushViewController:editLocationViewController  animated:YES];
        }
    }

    if(indexPath.section == 1)
    {
        if([indexPath row] == 0)
        {
            [Procedures makeSlabfromSample:selectedSample withInitials:dummyInitials inStore:libraryObjectStore];
            [self.navigationController popViewControllerAnimated:YES];
        }
    
        if([indexPath row] == 1)
        {
            [Procedures makeBilletfromSample:selectedSample withInitials:dummyInitials inStore:libraryObjectStore];
            [self.navigationController popViewControllerAnimated:YES];
        }
    
        if([indexPath row] == 2)
        {
            [Procedures makeThinSectionfromSample:selectedSample withInitials:dummyInitials inStore:libraryObjectStore];
            [self.navigationController popViewControllerAnimated:YES];
        }
        if([indexPath row] == 3)
        {
            [Procedures trimSample:selectedSample withInitials:dummyInitials inStore:libraryObjectStore];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
    if(indexPath.section == 2)
    {
        if([indexPath row] == 0)
        {
            [Procedures pulverizeSample:selectedSample withInitials:dummyInitials inStore:libraryObjectStore];
            [self.navigationController popViewControllerAnimated:YES];
        }
    
        if([indexPath row] == 1)
        {
            [Procedures jawCrushSample:selectedSample withInitials:dummyInitials inStore:libraryObjectStore];
            [self.navigationController popViewControllerAnimated:YES];
        }
    
        if([indexPath row] == 2)
        {
            [Procedures geminiSample:selectedSample withInitials:dummyInitials inStore:libraryObjectStore];
            [self.navigationController popViewControllerAnimated:YES];
        }
    
        if([indexPath row] == 3)
        {
            [Procedures panSample:selectedSample withInitials:dummyInitials inStore:libraryObjectStore];
            [self.navigationController popViewControllerAnimated:YES];
        }
    
        if([indexPath row] == 4)
        {
            [Procedures sievesTenSample:selectedSample withInitials:dummyInitials inStore:libraryObjectStore];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    if(indexPath.section == 3)
    {
        if([indexPath row] == 0)
        {
            [Procedures heavyLiquid_330_Sample:selectedSample withInitials:dummyInitials inStore:libraryObjectStore];
            [self.navigationController popViewControllerAnimated:YES];
        }
    
    
        if([indexPath row] == 1)
        {
            [Procedures heavyLiquid_290_Sample:selectedSample withInitials:dummyInitials inStore:libraryObjectStore];
            [self.navigationController popViewControllerAnimated:YES];
        }
    
   
    
        if([indexPath row] == 2)
        {
            [Procedures heavyLiquid_265_Sample:selectedSample withInitials:dummyInitials inStore:libraryObjectStore];
            [self.navigationController popViewControllerAnimated:YES];
        }
    
    
        if([indexPath row] == 3)
        {
            [Procedures heavyLiquid_255_Sample:selectedSample withInitials:dummyInitials inStore:libraryObjectStore];
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
    
    if(indexPath.section == 4)
    {
        if([indexPath row] == 0)
        {
            [Procedures handMagnetSample:selectedSample withInitials:dummyInitials inStore:libraryObjectStore];
            [self.navigationController popViewControllerAnimated:YES];
        }
    
        if([indexPath row] == 1)
        {
            [Procedures  magnet02AmpsSample:selectedSample withInitials:dummyInitials inStore:libraryObjectStore];
            [self.navigationController popViewControllerAnimated:YES];
        }
    
    
        if([indexPath row] == 2)
        {
            [Procedures  magnet04AmpsSample:selectedSample withInitials:dummyInitials inStore:  libraryObjectStore];
            [self.navigationController popViewControllerAnimated:YES];
        }
    
    
        if([indexPath row] == 3)
        {
            [Procedures  magnet06AmpsSample:selectedSample withInitials:dummyInitials inStore:libraryObjectStore];
            [self.navigationController popViewControllerAnimated:YES];
        }
    
    
        if([indexPath row] == 4)
        {
            [Procedures  magnet08AmpsSample:selectedSample withInitials:dummyInitials inStore:libraryObjectStore];
            [self.navigationController popViewControllerAnimated:YES];
        }
    
    
        if([indexPath row] == 5)
        {
            [Procedures  magnet10AmpsSample:selectedSample withInitials:dummyInitials inStore:libraryObjectStore];
            [self.navigationController popViewControllerAnimated:YES];
        }
    
        if([indexPath row] == 6)
        {
            [Procedures  magnet12AmpsSample:selectedSample withInitials:dummyInitials inStore:libraryObjectStore];
            [self.navigationController popViewControllerAnimated:YES];
        }
  
        if([indexPath row] == 7)
        {
            [Procedures  magnet14AmpsSample:selectedSample withInitials:dummyInitials inStore:libraryObjectStore];
            [self.navigationController popViewControllerAnimated:YES];
        }
    
    }
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section == 0)
    {
        return @"Update Location";
    }
    else if(section ==1)
    {
        return @"Documentation";
    }
    else if(section ==2)
    {
        return @"Transformation";
    }
    else if(section ==3)
    {
        return @"Density Seperation";
    }
    else //section == 4
    {
        return @"Magnetic Seperation";
    }
}

@end
