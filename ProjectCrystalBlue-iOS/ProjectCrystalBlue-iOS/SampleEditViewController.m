//
//  SampleEditViewController.m
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 2/15/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "SampleEditViewController.h"
#

@interface SampleEditViewController ()

{
    NSMutableArray *tags;
}

@end

@implementation SampleEditViewController

@synthesize selectedSample, libraryObjectStore;

- (id)initWithSample:(Sample*)initSample {
    // Call the superclass's designated initializer
    selectedSample = initSample;
    tags = [[NSMutableArray alloc] init];
    
    self = [super initWithStyle:UITableViewStyleGrouped];
    if (self) {
        
        UINavigationItem *n = [self navigationItem];
        [n setTitle:[selectedSample key]];
        
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc]
                                initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self
                                action:@selector(addNewItem:)];
        UIBarButtonItem *backbtn = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(goBack:)];
        
        [[self navigationItem] setRightBarButtonItem:bbi];
        [[self navigationItem] setLeftBarButtonItem:backbtn];
        
    }
    return self;
}

-(void) goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (id)initWithStyle:(UITableViewStyle)style {
    return [self init]; }

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [tags count];
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
    //Sample *p = [samples objectAtIndex:[indexPath row]];
    NSString *p = [tags objectAtIndex:[indexPath row]];
    [[cell textLabel] setText:p];
    
    return cell;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    NSString *selectedSampleKey = [selectedSample key];
    NSString *tag = [[NSString alloc] init];
    NSString *currentChar = [[NSString alloc] init];
    NSMutableArray *tempTags = [[NSMutableArray alloc] init];
    NSInteger loopLength = [[[selectedSample attributes] objectForKey:@"tags"] length];
   
    
    
    
	for(int i = 0; i < loopLength; i++)
    {
        currentChar = [[selectedSample attributes] objectForKey:@"tags"];
        currentChar = [currentChar substringWithRange:NSMakeRange(i, 1)];
                      
        if((i == (loopLength-1)) || [currentChar isEqualToString:@"_"])
        {
            [tempTags addObject:tag];
            tag = @"";
        }
                       
       else if(![currentChar isEqualToString:@"_"])
        {
            tag = [tag stringByAppendingString:currentChar];
        }
    }
    
    tag = @"";
    
    for (int i = 0; i < tempTags.count; i++) {
        tag = [tempTags objectAtIndex:i];
        if ([tag isEqualToString: @"JC"]) {
            [tags addObject:@"Jaw Crusher"];
        }
        else if ([tag isEqualToString: @"PV"])
        {
            [tags addObject:@"Pulverizer"];
        }
    }
}

@end
