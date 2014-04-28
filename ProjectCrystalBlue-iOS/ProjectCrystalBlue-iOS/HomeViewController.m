//
//  HomeViewController.m
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 3/1/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "HomeViewController.h"
#import "SampleViewController.h"
#import "AddSampleOneViewController.h"
#import "CredentialsViewController.h"
#import "EmbedReaderViewController.h"
#import "SimpleDBLibraryObjectStore.h"
#import "PCBLogWrapper.h"

@interface HomeViewController ()
{
    AbstractCloudLibraryObjectStore *dataStore;
}
@end

@implementation HomeViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        dataStore = [[SimpleDBLibraryObjectStore alloc] initInLocalDirectory:@"ProjectCrystalBlue/Data"
                                                            WithDatabaseName:@"test_database.db"];
        UINavigationItem *n = [self navigationItem];
        [n setTitle:@"Project Crystal Blue"];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    CredentialsViewController *credentialsView = [[CredentialsViewController alloc] initWithNibName:@"CredentialsViewController"
                                                                                             bundle:nil];
    [credentialsView setDataStore:dataStore];
    [self presentViewController:credentialsView animated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)viewSamples:(id)sender
{
    SampleViewController *sampleViewController = [[SampleViewController alloc] init];
    [[self navigationController] pushViewController:sampleViewController  animated:YES];
    
}

- (IBAction)addSample:(id)sender
{
    AddSampleOneViewController *asoViewController = [[AddSampleOneViewController alloc] init];
    [[self navigationController] pushViewController:asoViewController  animated:YES];
}

- (IBAction)scanQRCode:(id)sender
{
    EmbedReaderViewController *scanViewController = [[EmbedReaderViewController alloc] init];
    [[self navigationController] pushViewController:scanViewController animated:YES];
}

@end
