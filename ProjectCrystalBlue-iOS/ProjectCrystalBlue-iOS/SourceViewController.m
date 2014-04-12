//
//  SourceViewController.m
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 1/31/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "SourceViewController.h"
#import "Source.h"
#import "SourceEditViewController.h"
#import "SampleViewController.h"
#import "Sample.h"
#import "AbstractCloudLibraryObjectStore.h"
#import "SimpleDBLibraryObjectStore.h"
#import "Reachability.h"

@interface SourceViewController()
{
    SimpleDBLibraryObjectStore *libraryObjectStore;
    NSMutableArray *displayedSources;
    NSString *option;
}

@end

@implementation SourceViewController

- (id)init {
    // Call the superclass's designated initializer
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        libraryObjectStore = [[SimpleDBLibraryObjectStore alloc] initInLocalDirectory:@"ProjectCrystalBlue/Data"
                                                                     WithDatabaseName:@"test_database.db"];
        
        // Sync if can connect to internet
        Reachability *reach = [Reachability reachabilityForInternetConnection];
        if ([reach isReachable])
            [libraryObjectStore synchronizeWithCloud];
        
        displayedSources = [libraryObjectStore getAllLibraryObjectsFromTable:[SourceConstants tableName]].mutableCopy;
        
        UINavigationItem *n = [self navigationItem];
        [n setTitle:@"Sources"];
        
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return displayedSources.count;
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
    
    Source *source = [displayedSources objectAtIndex:indexPath.row];
    [[cell textLabel] setText:[source description]];
    return cell;
}


- (IBAction)toggleEditingMode:(id)sender {
    // If we are currently in editing mode...
    if ([self isEditing]) {
        [sender setTitle:@"Edit" forState:UIControlStateNormal]; // Turn off editing mode
        [   self setEditing:NO animated:YES];
    }
    else {
        [sender setTitle:@"Done" forState:UIControlStateNormal]; // Enter editing mode
        [self setEditing:YES animated:YES];
    }
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.tableView.editing) {
        self.editButtonItem.title =  @"Done";
    }
    else
        self.editButtonItem.title = @"Delete";
    return YES;
}
         
-(void) goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        Source *source = [displayedSources objectAtIndex:indexPath.row];
        [libraryObjectStore deleteLibraryObjectWithKey:[source key] FromTable:[SourceConstants tableName]];
        [displayedSources removeObjectAtIndex:indexPath.row];
        
        [[self tableView] deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
    }
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Source *selectedSource = [displayedSources objectAtIndex:indexPath.row];
    
    UIActionSheet *message;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        message = [[UIActionSheet alloc] initWithTitle:@"Action:" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"Edit Source", @"View Samples", nil];
    }
    else
    {
        message = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Edit Source", @"View Samples", nil];
    }
    
    CGRect cellRect = [self.tableView cellForRowAtIndexPath:indexPath].frame;
   // cellRect.origin.y += cellRect.size.height;
    cellRect.origin.y -= self.tableView.contentOffset.y;
    cellRect.size.height = 1;
    
    //[message showInView:[UIApplication sharedApplication].keyWindow];
    [message showFromRect:cellRect inView:[UIApplication sharedApplication].keyWindow animated:YES];
    
    while ((!message.hidden) && (message.superview != nil))
    {
        [[NSRunLoop currentRunLoop] limitDateForMode:NSDefaultRunLoopMode];
        
    }
    
    if([option isEqualToString:@"EDIT"])
    {
        SourceEditViewController *sourceEditViewController = [[SourceEditViewController alloc] initWithSource:selectedSource withLibrary:libraryObjectStore];
        [[self navigationController] pushViewController:sourceEditViewController  animated:YES];
    }
    
    if([option isEqualToString:@"VIEW"])
    {
        SampleViewController *sampleViewController = [[SampleViewController alloc] initWithSource:selectedSource];
        [sampleViewController setLibraryObjectStore:libraryObjectStore];
        [[self navigationController] pushViewController:sampleViewController  animated:YES];
    }
    
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
            option = @"NOTHING";
            break;
    }
}

@end
