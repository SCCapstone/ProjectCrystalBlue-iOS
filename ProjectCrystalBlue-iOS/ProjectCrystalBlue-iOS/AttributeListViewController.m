//
//  AttributeListViewController.m
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 12/5/13.
//  Copyright (c) 2013 Project Crystal Blue. All rights reserved.
//

#import "AttributeListViewController.h"
#import "Sample.h"
#import "EditTaskViewController.h"
#import "SampleListViewController.h"

@interface AttributeListViewController ()

@end

@implementation AttributeListViewController

@synthesize attributes = _attributes;
@synthesize currentSample = _currentSample;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    // Return the number of rows in the section.
    return 4;
}

//for Justin/Logan: here is where we are going to be assigning cell values fro the attributes. you can use if(indexPath.row == 'row number') to get the correct attribute to populate each row. I just don't know how to get the "currentSample" to be in this method (since in the SampleListViewController samples is the array)... because we do need a current sample.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    //Sample *clickedSample = [self.currentSample objectAtIndex:indexPath.row];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    //I don't know if the right sides of these work... but this is how we would specify the seperate cells
    if (indexPath.row == 0) {
        cell.textLabel.text = [NSString stringWithFormat:(@"%d"), self.currentSample.rockId];
    }
    if (indexPath.row == 1) {
        cell.textLabel.text = self.currentSample.rockType;
    }
    if (indexPath.row == 2) {
        cell.textLabel.text = self.currentSample.coordinates;
    }
    //if (indexPath.row == 3) {
        //cell.textLabel.text = self.currentSample.isPulverized;
    //}
    return cell;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    [self.tableView reloadData];
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    if ([segue.identifier isEqualToString:@"EditSampleSegue"]){
        EditTaskViewController *editTaskViewController = segue.destinationViewController;
        editTaskViewController.sample = [self.attributes objectAtIndex:self.tableView.indexPathForSelectedRow.row];
    }
}
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a story board-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

 */

@end
