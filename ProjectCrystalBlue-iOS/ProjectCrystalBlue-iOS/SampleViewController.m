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
#import "SimpleDBLibraryObjectStore.h"
#import "Procedures.h"
#import "PrimitiveProcedures.h"

@interface SampleViewController ()
{
    NSArray *samples;
    NSString* option;
}

@end

@implementation SampleViewController

@synthesize selectedSource, libraryObjectStore;

- (id)initWithSource:(Source *) initSource {
    // Call the superclass's designated initializer
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        samples = [[NSArray alloc] init];
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

- (id)initWithStyle:(UITableViewStyle)style {
    return [self init];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    samples = [libraryObjectStore getAllSamplesForSourceKey:selectedSource.key];
}

-(void)viewDidAppear:(BOOL)animated
{
    samples = [libraryObjectStore getAllSamplesForSourceKey:selectedSource.key];
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    Sample *selectedSample = [samples objectAtIndex:[indexPath row]];
    
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
    cellRect.origin.y += cellRect.size.height;
    cellRect.origin.y -= self.tableView.contentOffset.y;
    cellRect.size.height = 1;

    //[message showInView:[UIApplication sharedApplication].keyWindow];
    [message showFromRect:cellRect inView:[UIApplication sharedApplication].keyWindow animated:YES];

    while ((!message.hidden) && (message.superview != nil))
    {
        [[NSRunLoop currentRunLoop] limitDateForMode:NSDefaultRunLoopMode];
        
    }
    
    if([option isEqualToString:@"PROC"])
    {
        ProcedureListViewController *procedureListViewController = [[ProcedureListViewController alloc] initWithSample:selectedSample];
        [[self navigationController] pushViewController:procedureListViewController  animated:YES];
    }
    
    if([option isEqualToString:@"VIEW"])
    {
        SampleEditViewController *sampleEditViewController = [[SampleEditViewController alloc] initWithSample:selectedSample WithOption:@"EDIT"];
        //[sampleEditViewController setSelectedSample:selectedSample];
        [sampleEditViewController setLibraryObjectStore:libraryObjectStore];
        [[self navigationController] pushViewController:sampleEditViewController  animated:YES];
    }
    
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
