//
//  SourceViewController.m
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 1/31/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "SourceViewController.h"
#import "Source.h"
#import "SourceStore.h"
#import "DDLog.h"
#import "SourceEditViewController.h"

#ifdef DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@implementation SourceViewController
@synthesize option;


- (id)init {
    // Call the superclass's designated initializer
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
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
    return [[[SourceStore sharedStore] allSources] count];
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
    Source *p = [[[SourceStore sharedStore] allSources]
                 objectAtIndex:[indexPath row]]; [[cell textLabel] setText:[p description]];
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
    
    //Source *newSource = [[SourceStore sharedStore] createSource];
    Source *newSource = [[SourceStore sharedStore] createSourceWithKey:@""];
    SourceEditViewController *sourceEditViewController = [[SourceEditViewController alloc] initForNewSource:YES];
    
    
    [sourceEditViewController setSource:newSource];
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
        Source *source = [[[SourceStore sharedStore] allSources] objectAtIndex:indexPath.row];
        [[SourceStore sharedStore] removeSource:source];
        
        [[self tableView] deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath
      toIndexPath:(NSIndexPath *)destinationIndexPath
{
    [[SourceStore sharedStore] moveItemAtIndex:[sourceIndexPath row]
                                       toIndex:[destinationIndexPath row]];
}


- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SourceEditViewController *sourceEditViewController = [[SourceEditViewController alloc] init];
    
    NSMutableArray *sources = [[SourceStore sharedStore] allSources];
    Source *selectedSource = [sources objectAtIndex:[indexPath row]];
    
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
    
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
            option = @"EDIT";
            NSLog(@"edit");
            break;
        case 1:
            option = @"VIEW";
            NSLog(@"view");
            break;
        case 2:
            NSLog(@"Cancel");
    }
}



@end
