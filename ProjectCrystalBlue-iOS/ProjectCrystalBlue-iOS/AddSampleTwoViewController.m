//
//  AddSampleTwoViewController.m
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 3/1/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "AddSampleTwoViewController.h"
#import "Sample.h"
#import "AddSampleThreeViewController.h"
#import "AddSampleFiveViewController.h"
#import "PCBLogWrapper.h"

@interface AddSampleTwoViewController ()
{
    NSArray *typeArray;
}
@end

@implementation AddSampleTwoViewController

@synthesize sampleToAdd, libraryObjectStore;

- (id)initWithSample:(Sample *)initSample
   WithLibraryObject:(AbstractCloudLibraryObjectStore *)initLibrary
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        sampleToAdd = initSample;
        libraryObjectStore = initLibrary;
        typeArray = [[NSArray alloc] init];
        
        UINavigationItem *n = [self navigationItem];
        [n setTitle:@"Select Type"];
        
        
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
    return 10;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"UITableViewCell"];
    }
    
    NSString *p = [typeArray objectAtIndex:[indexPath row]];
    [[cell textLabel] setText:p];
    return cell;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    typeArray = [SampleConstants rockTypes];
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *typeSelected = [typeArray objectAtIndex:indexPath.row];
    NSArray *lithologies = [SampleConstants lithologiesForRockType:typeSelected];
    
    // Has available lithologies, next view
    if (lithologies) {
        AddSampleThreeViewController *viewControllerThree = [[AddSampleThreeViewController alloc] initWithSample:sampleToAdd
                                                                                               WithLibraryObject:libraryObjectStore];
        [viewControllerThree setTypeSelected:typeSelected];
        [sampleToAdd.attributes setObject:typeSelected forKey:SMP_TYPE];
        [[self navigationController] pushViewController:viewControllerThree animated:YES];
    }
    // Does not, skip to fifth view
    else {
        AddSampleFiveViewController *viewControllerFive = [[AddSampleFiveViewController alloc] initWithSample:sampleToAdd
                                                                                            WithLibraryObject:libraryObjectStore];
        
        [sampleToAdd.attributes setObject:typeSelected forKey:SMP_TYPE];
        [sampleToAdd.attributes setObject:@"" forKey:SMP_LITHOLOGY];
        
        if ([typeSelected isEqualToString:@"Siliciclastic"] || [typeSelected isEqualToString:@"Carbonate"] ||
            [typeSelected isEqualToString:@"Authigenic"] || [typeSelected isEqualToString:@"Volcanic"] ||
            [typeSelected isEqualToString:@"Fossil"])
            [sampleToAdd.attributes setObject:@"" forKey:SMP_DEPOSYSTEM];
        else
            [sampleToAdd.attributes setObject:@"N/A" forKey:SMP_DEPOSYSTEM];
        
        [[self navigationController] pushViewController:viewControllerFive animated:YES];
    }
}

@end
