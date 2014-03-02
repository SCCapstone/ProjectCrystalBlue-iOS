//
//  SourceViewController.m
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 1/31/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "DeleteSourcesViewController.h"
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

@interface DeleteSourcesViewController()
{
    SimpleDBLibraryObjectStore *libraryObjectStore;
    NSString *option;
}

@end

@implementation DeleteSourcesViewController

- (id)init {
    // Call the superclass's designated initializer
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        libraryObjectStore = [[SimpleDBLibraryObjectStore alloc] initInLocalDirectory:@"ProjectCrystalBlue/Data" WithDatabaseName:@"test_database.db"];
        
        UINavigationItem *n = [self navigationItem];
        [n setTitle:@"Delete Sources"];
        
        UIBarButtonItem *backbtn = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(goBack:)];
        
        [[self navigationItem] setRightBarButtonItem:[self editButtonItem]];
        [[self navigationItem] setLeftBarButtonItem:backbtn];
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

-(void) goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete)
    {
        Source *source = [[libraryObjectStore getAllLibraryObjectsFromTable:[SourceConstants tableName]]
                          objectAtIndex:indexPath.row];
        [libraryObjectStore deleteLibraryObjectWithKey:[source key] FromTable:[SourceConstants tableName]];
        // [libraryObjectStore deleteAllSamplesForSourceKey:[source key]];
        
        [[self tableView] deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}


@end
