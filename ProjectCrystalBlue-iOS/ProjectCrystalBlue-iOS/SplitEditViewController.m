//
//  SplitEditViewController.m
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 2/15/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "SplitEditViewController.h"
#import "ProcedureRecordParser.h"
#import "SampleEditViewController.h"
#import "ProcedureListViewController.h"

@interface SplitEditViewController ()

{
    NSArray *tags;
    NSString *optionAS;
    BOOL navigateToRoot;
}

@end

@implementation SplitEditViewController

@synthesize selectedSplit, libraryObjectStore;

- (id)initWithSplit:(Split *)initSplit
         WithLibrary:(AbstractCloudLibraryObjectStore*)initLibrary
AndNavigateBackToRoot:(BOOL)navigateBackToRoot
{
    // Call the superclass's designated initializer
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        selectedSplit = initSplit;
        libraryObjectStore = initLibrary;
        navigateToRoot = navigateBackToRoot;
        tags = [[NSMutableArray alloc] init];
        
        UINavigationItem *n = [self navigationItem];
        [n setTitle:[selectedSplit key]];
        
        UIBarButtonItem *actions = [[UIBarButtonItem alloc] initWithTitle:@"Options" style:UIBarButtonItemStyleBordered target:self action:@selector(multiOptions:)];
        
        UIBarButtonItem *backbtn = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(goBack:)];
        
        [[self navigationItem] setRightBarButtonItem:actions];
        [[self navigationItem] setLeftBarButtonItem:backbtn];
    }
    return self;
}


-(void) goBack:(id)sender
{
    if (navigateToRoot)
        [self.navigationController popToRootViewControllerAnimated:YES];
    else
        [self.navigationController popViewControllerAnimated:YES];
}

-(void) multiOptions:(id)sender
{
    UIActionSheet *message;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        message = [[UIActionSheet alloc] initWithTitle:@"Action:" delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:@"View Sample", @"Apply Procedure", nil];
    }
    else
    {
        message = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"View Sample", @"Apply Procedure", nil];
    }
    
    [message showInView:[UIApplication sharedApplication].keyWindow];
    
    while ((!message.hidden) && (message.superview != nil))
    {
        [[NSRunLoop currentRunLoop] limitDateForMode:NSDefaultRunLoopMode];
    }
    
    if([optionAS isEqualToString:@"VIEW"])
    {
        
        NSString *temp = [selectedSplit sampleKey];
        Sample *selectedSample = (Sample*)[libraryObjectStore getLibraryObjectForKey:temp FromTable:[SampleConstants tableName]];
        
        SampleEditViewController *sampleEditViewController =
            [[SampleEditViewController alloc] initWithSample:selectedSample
                                                 WithLibrary:libraryObjectStore
                                       AndNavigateBackToRoot:NO];
        
        [[self navigationController] pushViewController:sampleEditViewController animated:YES];
    }
    
    if([optionAS isEqualToString:@"APPLY"])
    {
        ProcedureListViewController *procedureListViewController = [[ProcedureListViewController alloc] initWithSplit:selectedSplit WithLibrary:libraryObjectStore];
        [[self navigationController] pushViewController:procedureListViewController  animated:YES];
    }
}

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
            optionAS = @"VIEW";
            break;
        case 1:
            optionAS = @"APPLY";
            break;
        case 2:
            optionAS = @"NOTHING";
            break;
    }
}

- (id)initWithStyle:(UITableViewStyle)style
{
    return [self init];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 1;
    }
    else
    {
        if([tags count] == 0)
            return 1;
        else
            return [tags count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (!cell)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                      reuseIdentifier:@"UITableViewCell"];
    }
 
    if (indexPath.section==0)
    {
        NSString *p = [[selectedSplit attributes] objectForKey:SPL_CURRENT_LOCATION];
         [[cell textLabel] setText:p];
        return cell;
    }
    
    if ([tags count] > 0)
    {
        NSString *p = [tags objectAtIndex:[indexPath row]];
        [[cell textLabel] setText:p];
    }
    else
        [[cell textLabel] setText:@"No Procedures Done"];
    return cell;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    tags = [ProcedureRecordParser nameArrayFromRecordList:[[selectedSplit attributes] objectForKey:SPL_TAGS]];
}

-(void)viewDidAppear:(BOOL)animated
{
     tags = [ProcedureRecordParser nameArrayFromRecordList:[[selectedSplit attributes] objectForKey:SPL_TAGS]];
    [self.tableView reloadData];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if(section == 0)
    {
        return @"Current Location";
    }
    else
    {
        return @"Procedures Applied";
    }
}

@end
