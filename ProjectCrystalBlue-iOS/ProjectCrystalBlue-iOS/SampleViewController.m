//
//  SampleViewController.m
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 2/8/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "SampleViewController.h"
#import "Sample.h"
#import "DDLog.h"
#import "SampleEditViewController.h"
#import "ProcedureListViewController.h"
#import "AbstractCloudLibraryObjectStore.h"
#import "Procedures.h"
#import "PrimitiveProcedures.h"
#import "Reachability.h"

@interface SampleViewController ()
{
    NSArray *samples;
    NSString* option;
}
@end

@implementation SampleViewController

@synthesize selectedSource, libraryObjectStore;

- (id)initWithSource:(Source *) initSource
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        samples = [libraryObjectStore getAllSamplesForSourceKey:selectedSource.key];
        selectedSource = initSource;
        
        UINavigationItem *n = [self navigationItem];
        NSString *title = selectedSource.key;
        title = [title stringByAppendingString:@" Samples"];
        [n setTitle:title];
        
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc]
                                initWithTitle:@"Add New" style:UIBarButtonItemStyleBordered target:self action:@selector(addNewItem:)];
        UIBarButtonItem *backbtn = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(goBack:)];
        
        [[self navigationItem] setRightBarButtonItem:bbi];
        [[self navigationItem] setLeftBarButtonItem:backbtn];
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Control for sync visual cue
    UIRefreshControl *refreshControl = [[UIRefreshControl alloc] init];
    [refreshControl addTarget:self
                       action:@selector(syncSamples)
             forControlEvents:UIControlEventValueChanged];
    
    self.refreshControl = refreshControl;
}

- (void)syncSamples
{
    Reachability *reach = [Reachability reachabilityForInternetConnection];
    if ([reach isReachable]) {
        [libraryObjectStore synchronizeWithCloud];
    }
    
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

-(void)viewDidAppear:(BOOL)animated
{
    samples = [libraryObjectStore getAllSamplesForSourceKey:selectedSource.key];
    [self.tableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [samples count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"UITableViewCell"];
    }
    
    Sample *sample = [samples objectAtIndex:[indexPath row]];
    [[cell textLabel] setText:[sample description]];
    
    return cell;
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Sample *selectedSample = [samples objectAtIndex:[indexPath row]];
    UIActionSheet *message;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        
        message = [[UIActionSheet alloc] initWithTitle:@"Action:" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Perform Procedure", @"View Sample", nil];
    }
    else
    {
        message = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Perform Procedure", @"View Sample", nil];
    }
    
    CGRect cellRect = [self.tableView cellForRowAtIndexPath:indexPath].frame;
    cellRect.origin.y += cellRect.size.height;
    cellRect.origin.y -= self.tableView.contentOffset.y;
    cellRect.size.height = 1;
    
    [message showFromRect:cellRect inView:[UIApplication sharedApplication].keyWindow animated:YES];
    
    while ((!message.hidden) && (message.superview != nil))
    {
        [[NSRunLoop currentRunLoop] limitDateForMode:NSDefaultRunLoopMode];
    }
    
    if([option isEqualToString:@"PROC"])
    {
        ProcedureListViewController *procedureListViewController = [[ProcedureListViewController alloc] initWithSample:selectedSample WithLibrary:libraryObjectStore];
        [[self navigationController] pushViewController:procedureListViewController  animated:YES];
    }
    
    if([option isEqualToString:@"VIEW"])
    {
        SampleEditViewController *sampleEditViewController =
        [[SampleEditViewController alloc] initWithSample:selectedSample
                                             WithLibrary:libraryObjectStore
                                   AndNavigateBackToRoot:NO];
        
        [[self navigationController] pushViewController:sampleEditViewController animated:YES];
    }
}

-(void) goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) addNewItem:(id)sender
{
    samples = [libraryObjectStore getAllSamplesForSourceKey:selectedSource.key];
    if([samples count] != 0)
    {
        [Procedures addFreshSample:[samples objectAtIndex:0] inStore:libraryObjectStore];
    }
    else
    {
        NSString *temp = selectedSource.key;
        temp = [temp stringByAppendingString:@".001"];
        
        NSString *key = [PrimitiveProcedures uniqueKeyBasedOn:selectedSource.key
                                                      inStore:libraryObjectStore
                                                      inTable:[SampleConstants tableName]];
        
        Sample *sample = [[Sample alloc] initWithKey:key
                           AndWithAttributes:[SampleConstants attributeNames]
                                   AndValues:[SampleConstants attributeDefaultValues]];
        [sample.attributes setObject:selectedSource.key
                              forKey:SMP_SOURCE_KEY];
        
        [libraryObjectStore putLibraryObject:sample IntoTable:[SampleConstants tableName]];
    }
    samples = [libraryObjectStore getAllSamplesForSourceKey:selectedSource.key];
    [self.tableView reloadData];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
            option = @"PROC";
            break;
        case 1:
            option = @"VIEW";
            break;
        case 2:
            option = @"NOTHING";
            break;
    }
}

@end
