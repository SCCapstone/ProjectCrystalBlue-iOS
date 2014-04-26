//
//  AddSampleFourViewController.m
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 3/1/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "Sample.h"
#import "AddSampleFourViewController.h"
#import "AddSampleFiveViewController.h"

@interface AddSampleFourViewController ()
{
    NSArray *depoArray;
}
@end

@implementation AddSampleFourViewController

@synthesize sampleToAdd, libraryObjectStore, typeSelected;

- (id)initWithSample:(Sample *)initSample
   WithLibraryObject:(AbstractCloudLibraryObjectStore *)initLibrary
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        sampleToAdd = initSample;
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
    return depoArray.count;
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
    depoArray = [SampleConstants deposystemsForRockType:typeSelected];
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddSampleFiveViewController *viewControllerFive = [[AddSampleFiveViewController alloc] initWithSample:sampleToAdd
                                                                                        WithLibraryObject:libraryObjectStore];
    NSString *deposystemSelected = [depoArray objectAtIndex:indexPath.row];
    
    // If lithology selected is unknown, set to empty string
    [sampleToAdd.attributes setObject:deposystemSelected forKey:SMP_DEPOSYSTEM];
    [[self navigationController] pushViewController:viewControllerFive animated:YES];
}

@end
