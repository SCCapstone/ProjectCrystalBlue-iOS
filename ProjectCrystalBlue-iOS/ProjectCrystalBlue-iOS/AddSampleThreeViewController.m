//
//  AddSampleThreeViewController.m
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 3/1/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//


#import "Source.h"
#import "AddSampleThreeViewController.h"
#import "AddSampleFourViewController.h"
#import "AddSampleFiveViewController.h"

@interface AddSampleThreeViewController ()
{
    NSMutableArray *lithArray;
}
@end

@implementation AddSampleThreeViewController

@synthesize sourceToAdd, libraryObjectStore, typeSelected, numRows;

- (id)initWithSource:(Source *)initSource WithLibraryObject:(AbstractCloudLibraryObjectStore *) initLibrary
{
    sourceToAdd = initSource;
    libraryObjectStore = initLibrary;
    lithArray = [[NSMutableArray alloc] init];
    
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
        UINavigationItem *n = [self navigationItem];
        [n setTitle:@"Select Lithology"];
        
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
        AddSampleFourViewController *asfViewController = [[AddSampleFourViewController alloc] initWithSource:sourceToAdd WithLibraryObject:libraryObjectStore];

        if ([indexPath row] == 0)
        {
            [asfViewController setTypeSelected:@"Siliciclastic"];
            [asfViewController setNumRows:15];
            [[sourceToAdd attributes] setObject:@"Conglomerate" forKey:SRC_LITHOLOGY];
            [[self navigationController] pushViewController:asfViewController  animated:YES];
        }
    
        if ([indexPath row] == 1)
        {
            [asfViewController setTypeSelected:@"Siliciclastic"];
            [asfViewController setNumRows:15];
            [[sourceToAdd attributes] setObject:@"Conglomerate" forKey:SRC_LITHOLOGY];
            [[self navigationController] pushViewController:asfViewController  animated:YES];
        }
        
        if ([indexPath row] == 2)
        {
            [asfViewController setTypeSelected:@"Siliciclastic"];
            [asfViewController setNumRows:15];
            [[sourceToAdd attributes] setObject:@"Breccia" forKey:SRC_LITHOLOGY];
            [[self navigationController] pushViewController:asfViewController  animated:YES];
        }
        
        if ([indexPath row] == 3)
        {
            [asfViewController setTypeSelected:@"Siliciclastic"];
            [asfViewController setNumRows:15];
            [[sourceToAdd attributes] setObject:@"Sandstone" forKey:SRC_LITHOLOGY];
            [[self navigationController] pushViewController:asfViewController  animated:YES];
        }
        
        if ([indexPath row] == 4)
        {
            [asfViewController setTypeSelected:@"Siliciclastic"];
            [asfViewController setNumRows:15];
            [[sourceToAdd attributes] setObject:@"Mudstone" forKey:SRC_LITHOLOGY];
            [[self navigationController] pushViewController:asfViewController  animated:YES];
        }
        
        if ([indexPath row] == 5)
        {
            [asfViewController setTypeSelected:@"Siliciclastic"];
            [asfViewController setNumRows:15];
            [[sourceToAdd attributes] setObject:@"Gravel" forKey:SRC_LITHOLOGY];
            [[self navigationController] pushViewController:asfViewController  animated:YES];
        }
        
        if ([indexPath row] == 6)
        {
            [asfViewController setTypeSelected:@"Siliciclastic"];
            [asfViewController setNumRows:15];
            [[sourceToAdd attributes] setObject:@"Sand" forKey:SRC_LITHOLOGY];
            [[self navigationController] pushViewController:asfViewController  animated:YES];
        }
        
        if ([indexPath row] == 7)
        {
            [asfViewController setTypeSelected:@"Siliciclastic"];
            [asfViewController setNumRows:15];
            [[sourceToAdd attributes] setObject:@"Mud" forKey:SRC_LITHOLOGY];
            [[self navigationController] pushViewController:asfViewController  animated:YES];
        }
    }
    
    if ([typeSelected isEqualToString:@"Carbonate"]) {
        AddSampleFourViewController *asfViewController = [[AddSampleFourViewController alloc] initWithSource:sourceToAdd WithLibraryObject:libraryObjectStore];
        
        if ([indexPath row] == 0)
        {
            [asfViewController setTypeSelected:@"Carbonate"];
            [asfViewController setNumRows:5];
            [[sourceToAdd attributes] setObject:@"Marl" forKey:SRC_LITHOLOGY];
            [[self navigationController] pushViewController:asfViewController  animated:YES];
        }
        
        if ([indexPath row] == 1)
        {
            [asfViewController setTypeSelected:@"Carbonate"];
            [asfViewController setNumRows:5];
            [[sourceToAdd attributes] setObject:@"Micrite" forKey:SRC_LITHOLOGY];
            [[self navigationController] pushViewController:asfViewController  animated:YES];
        }
        
        if ([indexPath row] == 2)
        {
            [asfViewController setTypeSelected:@"Carbonate"];
            [asfViewController setNumRows:5];
            [[sourceToAdd attributes] setObject:@"Wackestone" forKey:SRC_LITHOLOGY];
            [[self navigationController] pushViewController:asfViewController  animated:YES];
        }
        
        if ([indexPath row] == 3)
        {
            [asfViewController setTypeSelected:@"Carbonate"];
            [asfViewController setNumRows:5];
            [[sourceToAdd attributes] setObject:@"Packstone" forKey:SRC_LITHOLOGY];
            [[self navigationController] pushViewController:asfViewController  animated:YES];
        }
        
        if ([indexPath row] == 4)
        {
            [asfViewController setTypeSelected:@"Carbonate"];
            [asfViewController setNumRows:5];
            [[sourceToAdd attributes] setObject:@"Grainstone" forKey:SRC_LITHOLOGY];
            [[self navigationController] pushViewController:asfViewController  animated:YES];
        }
        
        if ([indexPath row] == 5)
        {
            [asfViewController setTypeSelected:@"Carbonate"];
            [asfViewController setNumRows:5];
            [[sourceToAdd attributes] setObject:@"Boundstone" forKey:SRC_LITHOLOGY];
            [[self navigationController] pushViewController:asfViewController  animated:YES];
        }
        
        if ([indexPath row] == 6)
        {
            [asfViewController setTypeSelected:@"Carbonate"];
            [asfViewController setNumRows:5];
            [[sourceToAdd attributes] setObject:@"Unknown" forKey:SRC_LITHOLOGY];
            [[self navigationController] pushViewController:asfViewController  animated:YES];
        }
    }
    
    if ([typeSelected isEqualToString:@"Authigenic"]) {
        AddSampleFiveViewController *asfViewController = [[AddSampleFiveViewController alloc] initWithSource:sourceToAdd WithLibraryObject:libraryObjectStore];
        [asfViewController setLibraryObjectStore:libraryObjectStore];

        
        if ([indexPath row] == 0)
        {
            [[sourceToAdd attributes] setObject:@"Glauconite" forKey:SRC_LITHOLOGY];
            [[sourceToAdd attributes] setObject:@"N/A" forKey:SRC_DEPOSYSTEM];
            [[self navigationController] pushViewController:asfViewController  animated:YES];
        }
        
        if ([indexPath row] == 1)
        {
            [[sourceToAdd attributes] setObject:@"N/A" forKey:SRC_LITHOLOGY];
            [[sourceToAdd attributes] setObject:@"N/A" forKey:SRC_DEPOSYSTEM];
            [[self navigationController] pushViewController:asfViewController  animated:YES];
        }
    }
    
    if ([typeSelected isEqualToString:@"Plutonic"]) {
        AddSampleFiveViewController *asfViewController = [[AddSampleFiveViewController alloc] initWithSource:sourceToAdd WithLibraryObject:libraryObjectStore];
        [asfViewController setLibraryObjectStore:libraryObjectStore];

        
        if ([indexPath row] == 0)
        {
            [[sourceToAdd attributes] setObject:@"Granitoid" forKey:SRC_LITHOLOGY];
            [[sourceToAdd attributes] setObject:@"N/A" forKey:SRC_DEPOSYSTEM];
            [[self navigationController] pushViewController:asfViewController  animated:YES];
        }
        
        if ([indexPath row] == 1)
        {
            [[sourceToAdd attributes] setObject:@"Granite" forKey:SRC_LITHOLOGY];
            [[sourceToAdd attributes] setObject:@"N/A" forKey:SRC_DEPOSYSTEM];
            [[self navigationController] pushViewController:asfViewController  animated:YES];
        }
        
        if ([indexPath row] == 2)
        {
            [[sourceToAdd attributes] setObject:@"Granodiorite" forKey:SRC_LITHOLOGY];
            [[sourceToAdd attributes] setObject:@"N/A" forKey:SRC_DEPOSYSTEM];
            [[self navigationController] pushViewController:asfViewController  animated:YES];
        }
        
        if ([indexPath row] == 3)
        {
            [[sourceToAdd attributes] setObject:@"Tonalite" forKey:SRC_LITHOLOGY];
            [[sourceToAdd attributes] setObject:@"N/A" forKey:SRC_DEPOSYSTEM];
            [[self navigationController] pushViewController:asfViewController  animated:YES];
        }
        
        if ([indexPath row] == 4)
        {
            [[sourceToAdd attributes] setObject:@"Diorite" forKey:SRC_LITHOLOGY];
            [[sourceToAdd attributes] setObject:@"N/A" forKey:SRC_DEPOSYSTEM];
            [[self navigationController] pushViewController:asfViewController  animated:YES];
        }
        
        if ([indexPath row] == 5)
        {
            [[sourceToAdd attributes] setObject:@"Gabbro" forKey:SRC_LITHOLOGY];
            [[sourceToAdd attributes] setObject:@"N/A" forKey:SRC_DEPOSYSTEM];
            [[self navigationController] pushViewController:asfViewController  animated:YES];
        }
        
        if ([indexPath row] == 6)
        {
            [[sourceToAdd attributes] setObject:@"Monzonite" forKey:SRC_LITHOLOGY];
            [[sourceToAdd attributes] setObject:@"N/A" forKey:SRC_DEPOSYSTEM];
            [[self navigationController] pushViewController:asfViewController  animated:YES];
        }
        
        if ([indexPath row] == 7)
        {
            [[sourceToAdd attributes] setObject:@"Syenite" forKey:SRC_LITHOLOGY];
            [[sourceToAdd attributes] setObject:@"N/A" forKey:SRC_DEPOSYSTEM];
            [[self navigationController] pushViewController:asfViewController  animated:YES];
        }
        
        if ([indexPath row] == 8)
        {
            [[sourceToAdd attributes] setObject:@"N/A" forKey:SRC_LITHOLOGY];
            [[sourceToAdd attributes] setObject:@"N/A" forKey:SRC_DEPOSYSTEM];
            [[self navigationController] pushViewController:asfViewController  animated:YES];
        }
    }
    
    if ([typeSelected isEqualToString:@"Volcanic"]) {
        AddSampleFiveViewController *asfViewController = [[AddSampleFiveViewController alloc] initWithSource:sourceToAdd WithLibraryObject:libraryObjectStore];
        
        if ([indexPath row] == 0)
        {
            [[sourceToAdd attributes] setObject:@"Ash" forKey:SRC_LITHOLOGY];
            [[sourceToAdd attributes] setObject:@"N/A" forKey:SRC_DEPOSYSTEM];
            [[self navigationController] pushViewController:asfViewController  animated:YES];
        }
        
        if ([indexPath row] == 1)
        {
            [[sourceToAdd attributes] setObject:@"Rhyolite" forKey:SRC_LITHOLOGY];
            [[sourceToAdd attributes] setObject:@"N/A" forKey:SRC_DEPOSYSTEM];
            [[self navigationController] pushViewController:asfViewController  animated:YES];
        }
        
        if ([indexPath row] == 2)
        {
            [[sourceToAdd attributes] setObject:@"Dacite" forKey:SRC_LITHOLOGY];
            [[sourceToAdd attributes] setObject:@"N/A" forKey:SRC_DEPOSYSTEM];
            [[self navigationController] pushViewController:asfViewController  animated:YES];
        }
        
        if ([indexPath row] == 3)
        {
            [[sourceToAdd attributes] setObject:@"Andesite" forKey:SRC_LITHOLOGY];
            [[sourceToAdd attributes] setObject:@"N/A" forKey:SRC_DEPOSYSTEM];
            [[self navigationController] pushViewController:asfViewController  animated:YES];
        }
        
        if ([indexPath row] == 4)
        {
            [[sourceToAdd attributes] setObject:@"Basalt" forKey:SRC_LITHOLOGY];
            [[sourceToAdd attributes] setObject:@"N/A" forKey:SRC_DEPOSYSTEM];
            [[self navigationController] pushViewController:asfViewController  animated:YES];
        }
        
        if ([indexPath row] == 5)
        {
            [[sourceToAdd attributes] setObject:@"Trachyte" forKey:SRC_LITHOLOGY];
            [[sourceToAdd attributes] setObject:@"N/A" forKey:SRC_DEPOSYSTEM];
            [[self navigationController] pushViewController:asfViewController  animated:YES];
        }
        
        if ([indexPath row] == 6)
        {
            [[sourceToAdd attributes] setObject:@"N/A" forKey:SRC_LITHOLOGY];
            [[sourceToAdd attributes] setObject:@"N/A" forKey:SRC_DEPOSYSTEM];
            [[self navigationController] pushViewController:asfViewController  animated:YES];
        }
    }
    
    if ([typeSelected isEqualToString:@"Metasedimentary"]) {
        AddSampleFiveViewController *asfViewController = [[AddSampleFiveViewController alloc] initWithSource:sourceToAdd WithLibraryObject:libraryObjectStore];

        
        if ([indexPath row] == 0)
        {
            [[sourceToAdd attributes] setObject:@"Slate" forKey:SRC_LITHOLOGY];
            [[sourceToAdd attributes] setObject:@"N/A" forKey:SRC_DEPOSYSTEM];
            [[self navigationController] pushViewController:asfViewController  animated:YES];
        }
        
        if ([indexPath row] == 1)
        {
            [[sourceToAdd attributes] setObject:@"Phyllite" forKey:SRC_LITHOLOGY];
            [[sourceToAdd attributes] setObject:@"N/A" forKey:SRC_DEPOSYSTEM];
            [[self navigationController] pushViewController:asfViewController  animated:YES];
        }
        
        if ([indexPath row] == 2)
        {
            [[sourceToAdd attributes] setObject:@"Schist" forKey:SRC_LITHOLOGY];
            [[sourceToAdd attributes] setObject:@"N/A" forKey:SRC_DEPOSYSTEM];
            [[self navigationController] pushViewController:asfViewController  animated:YES];
        }
        
        if ([indexPath row] == 3)
        {
            [[sourceToAdd attributes] setObject:@"Gneiss" forKey:SRC_LITHOLOGY];
            [[sourceToAdd attributes] setObject:@"N/A" forKey:SRC_DEPOSYSTEM];
            [[self navigationController] pushViewController:asfViewController  animated:YES];
        }
        
        if ([indexPath row] == 4)
        {
            [[sourceToAdd attributes] setObject:@"N/A" forKey:SRC_LITHOLOGY];
            [[sourceToAdd attributes] setObject:@"N/A" forKey:SRC_DEPOSYSTEM];
            [[self navigationController] pushViewController:asfViewController  animated:YES];
        }
    }
    
    if ([typeSelected isEqualToString:@"Metaigneous"]) {
        AddSampleFiveViewController *asfViewController = [[AddSampleFiveViewController alloc] initWithSource:sourceToAdd WithLibraryObject:libraryObjectStore];

        
        if ([indexPath row] == 0)
        {
            [[sourceToAdd attributes] setObject:@"Felsic Orthoschist" forKey:SRC_LITHOLOGY];
            [[sourceToAdd attributes] setObject:@"N/A" forKey:SRC_DEPOSYSTEM];
            [[self navigationController] pushViewController:asfViewController  animated:YES];
        }
        
        if ([indexPath row] == 1)
        {
            [[sourceToAdd attributes] setObject:@"Felsic Orthogneiss" forKey:SRC_LITHOLOGY];
            [[sourceToAdd attributes] setObject:@"N/A" forKey:SRC_DEPOSYSTEM];
            [[self navigationController] pushViewController:asfViewController  animated:YES];
        }

        
        if ([indexPath row] == 2)
        {
            [[sourceToAdd attributes] setObject:@"Intermediate Orthoschist" forKey:SRC_LITHOLOGY];
            [[sourceToAdd attributes] setObject:@"N/A" forKey:SRC_DEPOSYSTEM];
            [[self navigationController] pushViewController:asfViewController  animated:YES];
        }

        
        if ([indexPath row] == 3)
        {
            [[sourceToAdd attributes] setObject:@"Intermediate Orthogneiss" forKey:SRC_LITHOLOGY];
            [[sourceToAdd attributes] setObject:@"N/A" forKey:SRC_DEPOSYSTEM];
            [[self navigationController] pushViewController:asfViewController  animated:YES];
        }

        
        if ([indexPath row] == 4)
        {
            [[sourceToAdd attributes] setObject:@"Amphibolite" forKey:SRC_LITHOLOGY];
            [[sourceToAdd attributes] setObject:@"N/A" forKey:SRC_DEPOSYSTEM];
            [[self navigationController] pushViewController:asfViewController  animated:YES];
        }

        
        if ([indexPath row] == 5)
        {
            [[sourceToAdd attributes] setObject:@"N/A" forKey:SRC_LITHOLOGY];
            [[sourceToAdd attributes] setObject:@"N/A" forKey:SRC_DEPOSYSTEM];
            [[self navigationController] pushViewController:asfViewController  animated:YES];
        }
    }
}

@end
