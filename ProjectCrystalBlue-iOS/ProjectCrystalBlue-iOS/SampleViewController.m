//
//  SampleViewController.m
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 1/31/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "SampleViewController.h"
#import "Sample.h"
#import "SampleEditViewController.h"
#import "SplitViewController.h"
#import "Split.h"
#import "SimpleDBLibraryObjectStore.h"
#import "SampleImageUtils.h"
#import "AbstractMobileCloudImageStore.h"
#import "Reachability.h"

@interface SampleViewController()
{
    SimpleDBLibraryObjectStore *libraryObjectStore;
    NSMutableArray *displayedSamples;
    NSString *option;
    Sample *selectedSample;
    int selectedRow;
}

@end

@implementation SampleViewController

- (id)init
{
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        libraryObjectStore = [[SimpleDBLibraryObjectStore alloc] initInLocalDirectory:@"ProjectCrystalBlue/Data"
                                                                     WithDatabaseName:@"test_database.db"];
        
        NSArray *temp = [libraryObjectStore getAllLibraryObjectsFromTable:[SampleConstants tableName]];
        NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"key"
                                                                       ascending:YES
                                                                        selector:@selector(localizedCaseInsensitiveCompare:)];
        
        NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
        displayedSamples = [temp sortedArrayUsingDescriptors:sortDescriptors].mutableCopy;
        
        UINavigationItem *n = [self navigationItem];
        [n setTitle:@"Samples"];
        
        UIBarButtonItem *backbtn = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(goBack:)];
        
        [[self navigationItem] setRightBarButtonItem:[self editButtonItem]];
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
        [(AbstractMobileCloudImageStore *)[SampleImageUtils defaultImageStore] synchronizeWithCloud];
    }
    
    NSArray *temp = [libraryObjectStore getAllLibraryObjectsFromTable:[SampleConstants tableName]];
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"key"
                                                                   ascending:YES
                                                                    selector:@selector(localizedCaseInsensitiveCompare:)];
    
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    displayedSamples = [temp sortedArrayUsingDescriptors:sortDescriptors].mutableCopy;
    
    [self.tableView reloadData];
    [self.refreshControl endRefreshing];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return displayedSamples.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"UITableViewCell"];
    }

    Sample *sample = [displayedSamples objectAtIndex:indexPath.row];
    [[cell textLabel] setText:[sample description]];
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tableView.editing)
    {
        self.editButtonItem.title =  @"Done";
    }
    else
        self.editButtonItem.title = @"Delete";
    return YES;
}

- (IBAction)toggleEditingMode:(id)sender
{
    if ([self isEditing])
    {
        [sender setTitle:@"Edit" forState:UIControlStateNormal];
        [   self setEditing:NO animated:YES];
    }
    else
    {
        [sender setTitle:@"Done" forState:UIControlStateNormal];
        [self setEditing:YES animated:YES];
    }
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        Sample *sample = [displayedSamples objectAtIndex:indexPath.row];
        [libraryObjectStore deleteLibraryObjectWithKey:[sample key] FromTable:[SampleConstants tableName]];
        [displayedSamples removeObjectAtIndex:indexPath.row];
        
        [[self tableView] deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    selectedSample = [displayedSamples objectAtIndex:indexPath.row];
    
    UIActionSheet *message;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        message = [[UIActionSheet alloc] initWithTitle:@"Action:" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Edit Sample", @"View Splits", @"Delete Sample", nil];
    }
    else
    {
        message = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Edit Sample", @"View Splits", @"Delete Sample", nil];
    }
    
    CGRect cellRect = [self.tableView cellForRowAtIndexPath:indexPath].frame;
    cellRect.origin.y -= self.tableView.contentOffset.y;
    cellRect.size.height = 1;
    
    [message showFromRect:cellRect inView:[UIApplication sharedApplication].keyWindow animated:YES];
    
    while ((!message.hidden) && (message.superview != nil))
    {
        [[NSRunLoop currentRunLoop] limitDateForMode:NSDefaultRunLoopMode];
    }
    
    if([option isEqualToString:@"EDIT"])
    {
        SampleEditViewController *sampleEditViewController =
        [[SampleEditViewController alloc] initWithSample:selectedSample
                                             WithLibrary:libraryObjectStore
                                   AndNavigateBackToRoot:NO];
        [[self navigationController] pushViewController:sampleEditViewController animated:YES];
    }
    
    if([option isEqualToString:@"VIEW"])
    {
        SplitViewController *splitViewController = [[SplitViewController alloc] initWithSample:selectedSample];
        [splitViewController setLibraryObjectStore:libraryObjectStore];
        [[self navigationController] pushViewController:splitViewController animated:YES];
    }
    if([option isEqualToString:@"DEL"])
    {
        selectedRow = indexPath.row;
        NSString *alertMessage = @"Are you sure you want to delete ";
        alertMessage = [alertMessage stringByAppendingString:[selectedSample key]];
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:alertMessage
                              message:nil
                              delegate:self
                              cancelButtonTitle:@"No"
                              otherButtonTitles:@"Yes", nil];
        [alert show];
        
    }
}

-(void) goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
            option = @"EDIT";
            break;
        case 1:
            option = @"VIEW";
            break;
        case 2:
            option = @"DEL";
            break;
        case 3:
            option = @"NOTHING";
            break;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
            break;
        case 1:
        {
            [libraryObjectStore deleteLibraryObjectWithKey:[selectedSample key] FromTable:[SampleConstants tableName]];
            [displayedSamples removeObjectAtIndex:selectedRow];
            [self.tableView reloadData];
        }
    }
}

@end
