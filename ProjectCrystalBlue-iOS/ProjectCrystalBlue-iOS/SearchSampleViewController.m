//
//  SearchSampleViewController.m
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 3/1/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "SearchSampleViewController.h"
#import "SimpleDBLibraryObjectStore.h"
#import "SampleEditViewController.h"
#import "Sample.h"
#import "SampleConstants.h"

@interface SearchSampleViewController ()

{
    SimpleDBLibraryObjectStore *libraryObjectStore;
    NSString *searchKey;
    Sample *searchSample;
    
}
@end

@implementation SearchSampleViewController
@synthesize searchField;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        libraryObjectStore = [[SimpleDBLibraryObjectStore alloc] initInLocalDirectory:@"ProjectCrystalBlue/Data"WithDatabaseName:@"test_database.db"];
        
        UINavigationItem *n = [self navigationItem];
        [n setTitle:@"Search Sample"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)searchSample:(id)sender {
    searchKey = [searchField text];
    searchSample = (Sample*)[libraryObjectStore getLibraryObjectForKey:searchKey FromTable:[SampleConstants tableName]];
    
    if (!searchSample) {
        NSString* message = @"Sample Doesn't Exist!";
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:message
                              message:nil
                              delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil, nil];
        [alert show];

    }
    else{
        SampleEditViewController *sampleEditViewController = [[SampleEditViewController alloc] initWithSample:searchSample WithOption:@"SEARCH"];
        [sampleEditViewController setLibraryObjectStore:libraryObjectStore];
        [[self navigationController] pushViewController:sampleEditViewController  animated:YES];
    }
    
    
    
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)backgroundTapped:(id)sender {
    [[self view] endEditing:YES];
}

@end
