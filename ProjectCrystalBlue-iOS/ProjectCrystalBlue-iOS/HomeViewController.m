//
//  HomeViewController.m
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 3/1/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "HomeViewController.h"
#import "SourceViewController.h"
#import "SearchSampleViewController.h"
#import "AddSampleOneViewController.h"
#import "DeleteSourcesViewController.h"
#import "EmbedReaderViewController.h"

@interface HomeViewController ()

@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UINavigationItem *n = [self navigationItem];
        [n setTitle:@"Project Crystal Blue"];
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

- (IBAction)viewSources:(id)sender {
    
    SourceViewController *sourceViewController = [[SourceViewController alloc] init];
    [[self navigationController] pushViewController:sourceViewController  animated:YES];
    
}

- (IBAction)searchSample:(id)sender {
    SearchSampleViewController *searchSampleViewController = [[SearchSampleViewController alloc] init];
    [[self navigationController] pushViewController:searchSampleViewController  animated:YES];
}

- (IBAction)addSource:(id)sender {
    AddSampleOneViewController *asoViewController = [[AddSampleOneViewController alloc] init];
    [[self navigationController] pushViewController:asoViewController  animated:YES];
}

- (IBAction)scan:(id)sender {
    EmbedReaderViewController *scanViewController = [[EmbedReaderViewController alloc] init];
    [[self navigationController] pushViewController:scanViewController animated:YES];
}

@end
