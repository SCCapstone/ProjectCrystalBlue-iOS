//
//  SourceViewController.m
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 1/31/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "SourceViewController.h"
#import "Source.h"
#import "DDLog.h"
#import "SourceEditViewController.h"
#import "SampleViewController.h"
#import "Sample.h"
#import "AbstractCloudLibraryObjectStore.h"
#import "SimpleDBLibraryObjectStore.h"

#ifdef DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@interface SourceViewController()
{
    AbstractCloudLibraryObjectStore *libraryObjectStore;
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
        
        UINavigationItem *n = [self navigationItem];
        [n setTitle:@"Sources"];
        
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc]
                                initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self
                                action:@selector(addNewItem:)];
        
        [[self navigationItem] setRightBarButtonItem:bbi];
        [[self navigationItem] setLeftBarButtonItem:[self editButtonItem]];
        
        
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style {
    return [self init]; }

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [libraryObjectStore countInTable:[SourceConstants tableName]];
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
    
    Source *source = [[libraryObjectStore getAllLibraryObjectsFromTable:[SourceConstants tableName]]
                      objectAtIndex:indexPath.row];
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

- (IBAction)addNewItem:(id)sender {
    
    SourceEditViewController *sourceEditViewController = [[SourceEditViewController alloc] initForNewSource:YES];
    
    
    [sourceEditViewController setSource:nil];
    [sourceEditViewController setDismissBlock:^{
        [[self tableView] reloadData];
    }];
    


    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:sourceEditViewController];
    [navController setModalPresentationStyle:UIModalPresentationFormSheet];
    [navController setModalTransitionStyle:UIModalTransitionStyleFlipHorizontal];
    [self presentViewController:navController animated:YES completion:nil];
    
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        Source *source = [[libraryObjectStore getAllLibraryObjectsFromTable:[SourceConstants tableName]]
                          objectAtIndex:indexPath.row];
        [libraryObjectStore deleteLibraryObjectWithKey:[source key] FromTable:[SourceConstants tableName]];
        
        [[self tableView] deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SourceEditViewController *sourceEditViewController = [[SourceEditViewController alloc] init];
    SampleViewController *sampleViewController = [[SampleViewController alloc] init];
    
    Source *selectedSource = [[libraryObjectStore getAllLibraryObjectsFromTable:[SourceConstants tableName]]
                              objectAtIndex:indexPath.row];
    
    UIActionSheet *message = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Edit Source", @"View Children", nil];
    
    [message showInView:[UIApplication sharedApplication].keyWindow];
    
    while ((!message.hidden) && (message.superview != nil))
    {
        [[NSRunLoop currentRunLoop] limitDateForMode:NSDefaultRunLoopMode];
        
    }
    
    if([option isEqualToString:@"EDIT"])
    {
        [sourceEditViewController setSource:selectedSource];
        [[self navigationController] pushViewController:sourceEditViewController  animated:YES];
    }
    
    if([option isEqualToString:@"VIEW"])
    {
        [sampleViewController setSelectedSource:selectedSource];
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
            break;
    }
}

@end
