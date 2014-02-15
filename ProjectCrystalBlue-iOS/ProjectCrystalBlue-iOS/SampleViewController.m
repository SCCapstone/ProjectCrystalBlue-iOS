//
//  SampleViewController.m
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 2/8/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "SampleViewController.h"
#import "Sample.h"
#import "SourceStore.h"
#import "SampleStore.h"
#import "DDLog.h"
#import "SampleEditViewController.h"

@interface SampleViewController ()

@end

@implementation SampleViewController

@synthesize option, sampleSet;

- (id)init {
    // Call the superclass's designated initializer
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
        UINavigationItem *n = [self navigationItem];
        [n setTitle:@"Samples"];
        
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc]
                                initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self
                                action:@selector(addNewItem:)];
        UIBarButtonItem *backbtn = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(goBack:)];
        
        [[self navigationItem] setRightBarButtonItem:bbi];
        [[self navigationItem] setLeftBarButtonItem:backbtn];
        
        
    }
    return self;
}

- (id)initWithStyle:(UITableViewStyle)style {
    return [self init]; }

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int counter = 0;
    NSString *aSampleKey = [[[SampleStore sharedStore] clickedSource] key];
    NSString *bSampleKey;
    NSInteger len = [aSampleKey length];
    
    
    for(int i = 0; i < [[[SampleStore sharedStore] allSamples] count]; i++)
    {
        
        bSampleKey = [[[[[SampleStore sharedStore] allSamples] objectAtIndex:i] key] substringToIndex:len];
                                                                                             
        if( [bSampleKey isEqualToString:aSampleKey])
            {
                 counter= counter + 1;
            }
    }
    
    return counter;
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
   
    NSString *aSampleKey = [[[SampleStore sharedStore] clickedSource] key];
    NSString *bSampleKey;
    NSInteger len = [aSampleKey length];
    NSMutableArray *temp = [[NSMutableArray alloc] init];
    
    
    for(int i = 0; i < [[[SampleStore sharedStore] allSamples] count]; i++)
    {
        
        bSampleKey = [[[[[SampleStore sharedStore] allSamples] objectAtIndex:i] key] substringToIndex:len];
        
        if( [bSampleKey isEqualToString:aSampleKey])
        {
            [temp addObject:[[[SampleStore sharedStore] allSamples] objectAtIndex:i]];
        }
    }
    
    
    Sample *p = [temp
                 objectAtIndex:[indexPath row]]; [[cell textLabel] setText:[p description]];
    sampleSet = temp;
    
    return cell;
}

-(void) goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tableView:(UITableView *)aTableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    //NSMutableArray *samples = [[SampleStore sharedStore] allSamples];
    Sample *selectedSample = [sampleSet objectAtIndex:[indexPath row]];
    
    SampleEditViewController *sampleEditViewController = [[SampleEditViewController alloc] initWithSample:selectedSample];
    
    UIActionSheet *message = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Perform Procedure", @"View Sample", nil];
    
    [message showInView:[UIApplication sharedApplication].keyWindow];
    
    while ((!message.hidden) && (message.superview != nil))
    {
        [[NSRunLoop currentRunLoop] limitDateForMode:NSDefaultRunLoopMode];
        
    }
    
    if([option isEqualToString:@"PROC"])
    {

    }
    
    if([option isEqualToString:@"VIEW"])
    {
        [sampleEditViewController setSample:selectedSample];
        [[self navigationController] pushViewController:sampleEditViewController  animated:YES];
    }
    
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
            option = @"PROC";
            NSLog(@"proc");
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
