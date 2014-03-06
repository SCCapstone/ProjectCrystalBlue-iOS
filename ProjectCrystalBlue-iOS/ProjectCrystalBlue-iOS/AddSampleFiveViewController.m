//
//  AddSampleFiveViewController.m
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 3/1/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "AddSampleFiveViewController.h"
#import "Source.h"
#import "AddSampleSixViewController.h"
#import "AbstractLibraryObjectStore.h"
#import "SampleConstants.h"


@interface AddSampleFiveViewController ()

{
    UITableView *autocompleteTableView;
}

@end

@implementation AddSampleFiveViewController
@synthesize GroupField, FormationField, MemberField, sourceToAdd, libraryObjectStore;
@synthesize pastGroups, pastFormations;
@synthesize autocompleteGroups, autocompleteFormations;

- (id)initWithSource:(Source *)initSource WithLibraryObject:(AbstractCloudLibraryObjectStore *) initLibrary
{
    if (self) {
        sourceToAdd = initSource;
        libraryObjectStore = initLibrary;
        
        UINavigationItem *n = [self navigationItem];
        [n setTitle:@"Add Sample Cont."];
        
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:self action:@selector(addSource:)];
        
        UIBarButtonItem *backbtn = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(goBack:)];
        
        [[self navigationItem] setRightBarButtonItem:bbi];
        [[self navigationItem] setLeftBarButtonItem:backbtn];
        
        
        autocompleteTableView = [[UITableView alloc] initWithFrame:
                                 CGRectMake(0, 120, 320, 120) style:UITableViewStyleGrouped];
        autocompleteTableView.delegate = self;
        autocompleteTableView.dataSource = self;
        autocompleteTableView.scrollEnabled = YES;
        autocompleteTableView.hidden = YES;
        [self.view addSubview:autocompleteTableView];
    }
    return self;

}

- (IBAction)addSource:(id)sender {
    autocompleteTableView.hidden = YES;
    
    [[sourceToAdd attributes] setObject:[GroupField text] forKey:SRC_GROUP];
    [[sourceToAdd attributes] setObject:[FormationField text] forKey:SRC_FORMATION];
    [[sourceToAdd attributes] setObject:[MemberField text] forKey:SRC_MEMBER];
    
    AddSampleSixViewController *assViewController = [[AddSampleSixViewController alloc] initWithSource:sourceToAdd WithLibraryObject:libraryObjectStore];
    
    [[self navigationController] pushViewController:assViewController  animated:YES];
    
}

-(void) goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    pastGroups = [[NSMutableArray alloc] init];
    autocompleteGroups = [[NSMutableArray alloc] init];
    
    pastGroups = [libraryObjectStore getUniqueAttributeValuesForAttributeName:SRC_GROUP FromTable:[SourceConstants tableName]];
    
    
    pastFormations = [[NSMutableArray alloc] init];
    autocompleteFormations = [[NSMutableArray alloc] init];
    
    [pastFormations addObject:@"Form1"];
    [pastFormations addObject:@"Form3"];
    [pastFormations addObject:@"NewForm1"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    autocompleteTableView.hidden = YES;
    return YES;
}

- (IBAction)backgroundTapped:(id)sender {
    autocompleteTableView.hidden = YES;
    [[self view] endEditing:YES];
}


- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField: textField up: YES];
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField: textField up: NO];
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    int movementDistance = 0;
    float movementDuration = 0.0;
    
    if (textField == GroupField) {
       movementDistance = 40; // tweak as needed
       movementDuration = 0.3f; // tweak as needed
    }
    
    if (textField == FormationField) {
        movementDistance = 120; // tweak as needed
        movementDuration = 0.3f; // tweak as needed
    }
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

- (BOOL)textField:(UITextField *)textField
    shouldChangeCharactersInRange:(NSRange)range
        replacementString:(NSString *)string {
   
    autocompleteTableView.hidden = NO;
    
    NSString *substring = [NSString stringWithString:textField.text];
    substring = [substring
                 stringByReplacingCharactersInRange:range withString:string];
    [self searchAutocompleteEntriesWithSubstring:substring];
    return YES;
}

- (void)searchAutocompleteEntriesWithSubstring:(NSString *)substring {
    
    // Put anything that starts with this substring into the autocompleteUrls array
    // The items in this array is what will show up in the table view
    
    NSArray *temp = [[NSArray alloc] init];
    
    if ([GroupField isFirstResponder]) {
        temp = pastGroups;
    }
    
    if ([FormationField isFirstResponder]) {
        temp = pastFormations;
    }
    
    [autocompleteGroups removeAllObjects];
    for(NSString *curString in temp) {
        NSRange substringRange = [curString rangeOfString:substring];
        if (substringRange.location == 0) {
            [autocompleteGroups addObject:curString];
        }
    }
    [autocompleteTableView reloadData];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger) section {
    return autocompleteGroups.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *cell = nil;
    static NSString *AutoCompleteRowIdentifier = @"AutoCompleteRowIdentifier";
    cell = [tableView dequeueReusableCellWithIdentifier:AutoCompleteRowIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc]
                 initWithStyle:UITableViewCellStyleDefault reuseIdentifier:AutoCompleteRowIdentifier];
    }
    
    cell.textLabel.text = [autocompleteGroups objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
    GroupField.text = selectedCell.textLabel.text;
    autocompleteTableView.hidden = YES;
    
    
}
@end
