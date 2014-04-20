//
//  AddSampleFourViewController.m
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 3/1/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "Source.h"
#import "AddSampleFourViewController.h"
#import "AddSampleFiveViewController.h"

@interface AddSampleFourViewController ()
{
    NSArray *depoArray;
}
@end

@implementation AddSampleFourViewController

@synthesize sourceToAdd, libraryObjectStore, typeSelected, numRows;

- (id)initWithSource:(Source *)initSource WithLibraryObject:(AbstractCloudLibraryObjectStore *) initLibrary
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        sourceToAdd = initSource;
        libraryObjectStore = initLibrary;
        depoArray = [[NSArray alloc] init];
        
        UINavigationItem *n = [self navigationItem];
        [n setTitle:@"Select Deposystem"];
        
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
    return numRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"UITableViewCell"];
    }
    
    NSString *p = [depoArray objectAtIndex:[indexPath row]];
    [[cell textLabel] setText:p];
    return cell;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    depoArray = [SourceConstants deposystemsForRockType:typeSelected];
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddSampleFiveViewController *viewControllerFive = [[AddSampleFiveViewController alloc] initWithSource:sourceToAdd WithLibraryObject:libraryObjectStore];
    NSString *deposystemSelected = [depoArray objectAtIndex:indexPath.row];
    
    // If lithology selected is unknown, set to empty string
    [sourceToAdd.attributes setObject:deposystemSelected forKey:SRC_DEPOSYSTEM];
    [[self navigationController] pushViewController:viewControllerFive animated:YES];
}

@end
