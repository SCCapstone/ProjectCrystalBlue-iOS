//
//  ProcedureListViewController.m
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 2/17/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "ProcedureListViewController.h"
#import "Split.h"
#import "Procedures.h"
#import "AbstractCloudLibraryObjectStore.h"
#import "ProcedureNameConstants.h"
#import "EditLocationViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "InitialsViewController.h"
#import "PCBLogWrapper.h"

@interface ProcedureListViewController ()
{
    NSMutableArray *procedureNames0;
    NSMutableArray *procedureNames1;
    NSMutableArray *procedureNames2;
    NSMutableArray *procedureNames3;
    NSMutableArray *procedureNames4;
}
@end

@implementation ProcedureListViewController
@synthesize selectedSplit, libraryObjectStore;

- (id)initWithSplit:(Split*)initSplit
        WithLibrary:(AbstractCloudLibraryObjectStore *)library
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        selectedSplit = initSplit;
        libraryObjectStore = library;
        procedureNames0 = [[NSMutableArray alloc] init];
        procedureNames1 = [[NSMutableArray alloc] init];
        procedureNames2 = [[NSMutableArray alloc] init];
        procedureNames3 = [[NSMutableArray alloc] init];
        procedureNames4 = [[NSMutableArray alloc] init];
        
        UINavigationItem *n = [self navigationItem];
        [n setTitle:[selectedSplit key]];
        
        UIBarButtonItem *backbtn = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(goBack:)];
        
        [[self navigationItem] setLeftBarButtonItem:backbtn];
    }
    return self;
}

-(void) goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (id)initWithStyle:(UITableViewStyle)style
{
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell)
    {
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
    [procedureNames0 addObject:@"Move Split"];
    [procedureNames1 addObject:@"Make Slab"];
    [procedureNames1 addObject:@"Make Billet"];
    [procedureNames1 addObject:@"Make Thin Section"];
    [procedureNames1 addObject:@"Trim"];
    [procedureNames2 addObject:@"Jaw Crusher"];
    [procedureNames2 addObject:@"Pulverizer"];
    [procedureNames2 addObject:@"Gemeni"];
    [procedureNames2 addObject:@"Pan"];
    [procedureNames2 addObject:@"Sieves"];
    [procedureNames3 addObject:@"Heavy Liquid 3.30"];
    [procedureNames3 addObject:@"Heavy Liquid 2.90"];
    [procedureNames3 addObject:@"Heavy Liquid 2.65"];
    [procedureNames3 addObject:@"Heavy Liquid 2.55"];
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
    InitialsViewController *initialsViewController = [[InitialsViewController alloc] initWithSplit:selectedSplit
                                                                                       withLibrary:libraryObjectStore
                                                                                           withRow:0
                                                                                         withTitle:NULL];
    
    if(indexPath.section == 0)
    {
        if ([indexPath row] == 0)
        {
            EditLocationViewController *editLocationViewController = [[EditLocationViewController alloc] initWithSplit:selectedSplit];
            [[self navigationController] pushViewController:editLocationViewController  animated:YES];
        }
    }

    else if(indexPath.section == 1)
    {
        if([indexPath row] == 0)
        {
            initialsViewController.selectedRow = 1;
            initialsViewController.titleNav = @"Make Slab";
            [[self navigationController] pushViewController:initialsViewController  animated:YES];
        }
    
        else if([indexPath row] == 1)
        {
            initialsViewController.selectedRow = 2;
            initialsViewController.titleNav = @"Make Billet";
            [[self navigationController] pushViewController:initialsViewController  animated:YES];
        }
    
        else if([indexPath row] == 2)
        {
             initialsViewController.selectedRow = 3;
             initialsViewController.titleNav = @"Make Thin Section";
             [[self navigationController] pushViewController:initialsViewController  animated:YES];

        }
        else if([indexPath row] == 3)
        {
            initialsViewController.selectedRow = 4;
             initialsViewController.titleNav = @"Trim";
             [[self navigationController] pushViewController:initialsViewController  animated:YES];
        }
    }
    
    else if(indexPath.section == 2)
    {
        if([indexPath row] == 0)
        {
            initialsViewController.selectedRow = 5;
             initialsViewController.titleNav = @"Jaw Crush";
             [[self navigationController] pushViewController:initialsViewController  animated:YES];

        }
    
        else if([indexPath row] == 1)
        {
            initialsViewController.selectedRow = 6;
            initialsViewController.titleNav = @"Pulverize";
            [[self navigationController] pushViewController:initialsViewController  animated:YES];
        }
    
        else if([indexPath row] == 2)
        {
            initialsViewController.selectedRow = 7;
            initialsViewController.titleNav = @"Gemeni";
            [[self navigationController] pushViewController:initialsViewController  animated:YES];

        }
    
        else if([indexPath row] == 3)
        {
             initialsViewController.selectedRow = 8;
                 initialsViewController.titleNav = @"Pan";
                 [[self navigationController] pushViewController:initialsViewController  animated:YES];
        }
    
        else if([indexPath row] == 4)
        {
            initialsViewController.selectedRow = 9;
            initialsViewController.titleNav = @"Sieves";
            [[self navigationController] pushViewController:initialsViewController  animated:YES];
        }
    }
        
    else if(indexPath.section == 3)
    {
        if([indexPath row] == 0)
        {
            initialsViewController.selectedRow = 10;
            initialsViewController.titleNav = @"Heavy Liquid 3.30";
            [[self navigationController] pushViewController:initialsViewController  animated:YES];
        }
    
        else if([indexPath row] == 1)
        {
            initialsViewController.selectedRow = 11;
            initialsViewController.titleNav = @"Heavy Liquid 2.90";
            [[self navigationController] pushViewController:initialsViewController  animated:YES];
        }
    
        else if([indexPath row] == 2)
        {
            initialsViewController.selectedRow = 12;
            initialsViewController.titleNav = @"Heavy Liquid 2.65";
            [[self navigationController] pushViewController:initialsViewController  animated:YES];

        }
    
        else if([indexPath row] == 3)
        {
            initialsViewController.selectedRow = 13;
            initialsViewController.titleNav = @"Heavy Liquid 2.55";
            [[self navigationController] pushViewController:initialsViewController  animated:YES];
        }
    }
    
    else if(indexPath.section == 4)
    {
        if([indexPath row] == 0)
        {
            initialsViewController.selectedRow = 14;
            initialsViewController.titleNav = @"Hand Magnet";
            [[self navigationController] pushViewController:initialsViewController  animated:YES];
        }
    
        else if([indexPath row] == 1)
        {
            initialsViewController.selectedRow = 15;
            initialsViewController.titleNav = @"Magnet 0.2A";
            [[self navigationController] pushViewController:initialsViewController  animated:YES];

        }
    
        else if([indexPath row] == 2)
        {
            initialsViewController.selectedRow = 16;
            initialsViewController.titleNav = @"Magnet 0.4A";
            [[self navigationController] pushViewController:initialsViewController  animated:YES];
        }
    
        else if([indexPath row] == 3)
        {
            initialsViewController.selectedRow = 17;
            initialsViewController.titleNav = @"Magnet 0.6A";
            [[self navigationController] pushViewController:initialsViewController  animated:YES];
        }
    
        else if([indexPath row] == 4)
        {
            initialsViewController.selectedRow = 18;
            initialsViewController.titleNav = @"Magnet 0.8A";
            [[self navigationController] pushViewController:initialsViewController  animated:YES];
        }
    
        else if([indexPath row] == 5)
        {
            initialsViewController.selectedRow = 19;
            initialsViewController.titleNav = @"Magnet 1.0A";
            [[self navigationController] pushViewController:initialsViewController  animated:YES];
        }
    
        else if([indexPath row] == 6)
        {
            initialsViewController.selectedRow = 20;
            initialsViewController.titleNav = @"Magnet 1.2A";
            [[self navigationController] pushViewController:initialsViewController  animated:YES];
        }
  
        else if([indexPath row] == 7)
        {
            initialsViewController.selectedRow = 21;
            initialsViewController.titleNav = @"Magnet 1.4A";
            [[self navigationController] pushViewController:initialsViewController  animated:YES];
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
        return @"Density Separation";
    }
    else //section == 4
    {
        return @"Magnetic Separation";
    }
}

@end
