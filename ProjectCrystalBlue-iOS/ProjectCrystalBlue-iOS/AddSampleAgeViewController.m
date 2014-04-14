//
//  AddSampleAgeViewController.m
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 3/31/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "AddSampleAgeViewController.h"
#import "AddSampleSevenViewController.h"
#import "Source.h"

@interface AddSampleAgeViewController ()
{
    NSArray *ageArray;
}
@end

@implementation AddSampleAgeViewController
@synthesize sourceToAdd, libraryObjectStore;

- (id)initWithSource:(Source *)initSource WithLibraryObject:(AbstractCloudLibraryObjectStore *) initLibrary
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        sourceToAdd = initSource;
        libraryObjectStore = initLibrary;
        ageArray = [[NSMutableArray alloc] init];
        
        UINavigationItem *n = [self navigationItem];
        [n setTitle:@"Select Age Method"];
        
        
        UIBarButtonItem *backbtn = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(goBack:)];
        
        [[self navigationItem] setLeftBarButtonItem:backbtn];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    ageArray = [SourceConstants ageMethods];
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
    return 6;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"UITableViewCell"];
    }
    
    NSString *p = [ageArray objectAtIndex:[indexPath row]];
    [[cell textLabel] setText:p];
    return cell;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    AddSampleSevenViewController *assViewController = [[AddSampleSevenViewController alloc] initWithSource:sourceToAdd WithLibraryObject:libraryObjectStore];
    
    [sourceToAdd.attributes setObject:[ageArray objectAtIndex:indexPath.row] forKey:SRC_AGE_METHOD];
    [[self navigationController] pushViewController:assViewController  animated:YES];
}


@end
