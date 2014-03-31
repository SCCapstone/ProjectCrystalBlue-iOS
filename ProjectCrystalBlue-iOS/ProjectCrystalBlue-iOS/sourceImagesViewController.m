//
//  sourceImagesViewController.m
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 3/30/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "sourceImagesViewController.h"
#import "Source.h"
#import "AbstractCloudLibraryObjectStore.h"
#import "SourceImageUtils.h"
#import "AddImageViewController.h"


@interface sourceImagesViewController ()
{
    UIImage* defaultImage;
    NSArray* imageArray;
    NSArray* descriptionArray;
}
@end

@implementation sourceImagesViewController
@synthesize selectedSource, libraryObjectStore;

- (id)initWithSource:(Source*)initSource withLibrary:(AbstractCloudLibraryObjectStore*)initLibrary
{
    selectedSource = initSource;
    libraryObjectStore = initLibrary;
    NSString* title = @"Images for ";
    title = [title stringByAppendingString:selectedSource.key];
    if (self) {
        UINavigationItem *n = [self navigationItem];
        [n setTitle:title];
        
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStyleBordered target:self action:@selector(addImage:)];
        UIBarButtonItem *backbtn = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(goBack:)];
        
        [[self navigationItem] setRightBarButtonItem:bbi];
        [[self navigationItem] setLeftBarButtonItem:backbtn];
    }
    return self;
}

- (IBAction)addImage:(id)sender {
    AddImageViewController* imgViewController = [[AddImageViewController alloc] initWithSource:selectedSource WithLibraryObject:libraryObjectStore];
    
    [[self navigationController] pushViewController:imgViewController  animated:YES];
}

-(void) goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self loadImages];
}

- (void)viewDidAppear:(BOOL)animated
{
    [self loadImages];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) loadImages
{
    imageArray = [SourceImageUtils imagesForSource:selectedSource inImageStore:[SourceImageUtils defaultImageStore]];
    descriptionArray = [SourceImageUtils imageKeysForSource:selectedSource];
    
    int yInc = 0;
    NSString* imageName = @"no_image.png";
    
    defaultImage = [UIImage imageNamed:imageName];
    for(int i = 0; i < [imageArray count]; i++)
    {
        //UIImageView* imgView = [[UIImageView alloc] initWithImage:defaultImage];
        UIImageView* imgView = [[UIImageView alloc] initWithImage:[imageArray objectAtIndex:i]];
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(14, 175+yInc, 300, 30)];
        imgView.frame = CGRectMake(10, 10+yInc, 200, 150);
        [label setText:[descriptionArray objectAtIndex:i]];
        
        yInc = yInc + 225;
        [_scrollView addSubview:imgView];
        [_scrollView addSubview:label];
    }
    
    [_scrollView setContentSize:CGSizeMake(320, (225*[imageArray count])+100)];
}
@end
