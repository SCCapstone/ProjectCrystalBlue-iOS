//
//  AddSampleThreeViewController.m
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 3/1/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "Sample.h"
#import "AddSampleThreeViewController.h"
#import "AddSampleFourViewController.h"
#import "AddSampleFiveViewController.h"
#import "PCBLogWrapper.h"

@interface AddSampleThreeViewController ()
{
    NSArray *lithArray;
}
@end

@implementation AddSampleThreeViewController

@synthesize sampleToAdd, libraryObjectStore, typeSelected;

- (id)initWithSample:(Sample *)initSample
   WithLibraryObject:(AbstractCloudLibraryObjectStore *)initLibrary
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        sampleToAdd = initSample;
        libraryObjectStore = initLibrary;
        lithArray = [[NSArray alloc] init];
        
        UINavigationItem *n = [self navigationItem];
        [n setTitle:@"Select Lithology"];
        
        UIBarButtonItem *backbtn = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(goBack:)];
        
        [[self navigationItem] setLeftBarButtonItem:backbtn];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    lithArray = [SampleConstants lithologiesForRockType:typeSelected];
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
    return lithArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"UITableViewCell"];
    }
    
    NSString *p = [lithArray objectAtIndex:[indexPath row]];
    [[cell textLabel] setText:p];
    return cell;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *lithologySelected = [lithArray objectAtIndex:indexPath.row];
    NSArray *deposystems = [SampleConstants deposystemsForRockType:typeSelected];
    
    // Has available deposystems, next view
    if (deposystems) {
        AddSampleFourViewController *viewControllerFour = [[AddSampleFourViewController alloc] initWithSample:sampleToAdd
                                                                                            WithLibraryObject:libraryObjectStore];
        [viewControllerFour setTypeSelected:typeSelected];
        [sampleToAdd.attributes setObject:lithologySelected forKey:SMP_LITHOLOGY];
        [[self navigationController] pushViewController:viewControllerFour animated:YES];
    }
    // No deposystems available, skip fifth view
    else {
        AddSampleFiveViewController *viewControllerFive = [[AddSampleFiveViewController alloc] initWithSample:sampleToAdd
                                                                                            WithLibraryObject:libraryObjectStore];
        
        // If lithology selected is unknown, set to empty string
        [sampleToAdd.attributes setObject:lithologySelected forKey:SMP_LITHOLOGY];
        [sampleToAdd.attributes setObject:@"" forKey:SMP_DEPOSYSTEM];
        [[self navigationController] pushViewController:viewControllerFive animated:YES];
    }
}

@end
