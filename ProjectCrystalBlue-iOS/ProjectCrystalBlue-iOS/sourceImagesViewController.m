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


@interface sourceImagesViewController ()
{
    UIImage* defaultImage;
    NSArray* imageArray;
}
@end

@implementation sourceImagesViewController
@synthesize selectedSource, libraryObjectStore;

- (id)initWithSource:(Source*)initSource withLibrary:(AbstractCloudLibraryObjectStore*)initLibrary
{
    selectedSource = initSource;
    libraryObjectStore = initLibrary;
    if (self) {
        UINavigationItem *n = [self navigationItem];
        [n setTitle:[selectedSource key]];
        
        UIBarButtonItem *backbtn = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(goBack:)];
        
        [[self navigationItem] setLeftBarButtonItem:backbtn];
    }
    return self;
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) loadImages
{
    imageArray = [SourceImageUtils imagesForSource:selectedSource inImageStore:[SourceImageUtils defaultImageStore]];
    int xInc = 0;
    int yInc = 0;
    NSString* imageName = @"no_image.png";
    
    defaultImage = [UIImage imageNamed:imageName];
    for(int i = 0; i < [imageArray count]; i++)
    {
        //UIImageView* imgView = [[UIImageView alloc] initWithImage:defaultImage];
        UIImageView* imgView = [[UIImageView alloc] initWithImage:[imageArray objectAtIndex:i]];
        //[[UIImageView alloc] initWithFrame:CGRectMake(14+xInc, 100+yInc, 137, 44)];
        imgView.frame = CGRectMake(10+xInc, 10+yInc, 137, 100);
        
        xInc = i % 4 ? xInc + 160 : 0;
        yInc = i % 4 ? yInc : yInc + 150;
        [_scrollView addSubview:imgView];
        [_scrollView setContentSize:CGSizeMake(640, 450)];
    }
}
@end
