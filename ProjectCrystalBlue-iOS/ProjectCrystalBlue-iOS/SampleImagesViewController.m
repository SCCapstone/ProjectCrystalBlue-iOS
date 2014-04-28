//
//  SampleImagesViewController.m
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 3/30/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "SampleImagesViewController.h"
#import "Sample.h"
#import "AbstractCloudLibraryObjectStore.h"
#import "SampleImageUtils.h"
#import "AddImageViewController.h"
#import "EnlargedImageViewController.h"
#import "PCBLogWrapper.h"

#define TITLE_LOADING @"Loading images..."
#define TITLE_FORMAT @"Images for %@"

@interface SampleImagesViewController ()
{
    UIImage* defaultImage;
    NSArray* imageArray;
    NSArray* descriptionArray;
    UIImageView* imgView;
}
@end

@implementation SampleImagesViewController
@synthesize selectedSample, libraryObjectStore;

- (id)initWithSample:(Sample*)initSample
         withLibrary:(AbstractCloudLibraryObjectStore*)initLibrary
{
    self = [super init];
    if (self) {
        selectedSample = initSample;
        libraryObjectStore = initLibrary;
        self.title = TITLE_LOADING;
        [self.navigationItem setTitle:TITLE_LOADING];
        
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithTitle:@"Add" style:UIBarButtonItemStyleBordered target:self action:@selector(addImage:)];
        UIBarButtonItem *backbtn = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(goBack:)];
        
        [[self navigationItem] setRightBarButtonItem:bbi];
        [[self navigationItem] setLeftBarButtonItem:backbtn];
    }
    return self;
}

- (IBAction)addImage:(id)sender {
    AddImageViewController* imgViewController = [[AddImageViewController alloc] initWithSample:selectedSample
                                                                             WithLibraryObject:libraryObjectStore];
    
    [[self navigationController] pushViewController:imgViewController  animated:YES];
}

-(void) goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
   // [self loadImages];
}

- (void)viewDidAppear:(BOOL)animated
{
    for (UIView *view in self.view.subviews)
    {
        [view removeFromSuperview];
    }
    [self performSelectorInBackground:@selector(loadImages) withObject:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void) loadImages
{
    imageArray = [SampleImageUtils imagesForSample:selectedSample inImageStore:[SampleImageUtils defaultImageStore]];
    descriptionArray = [SampleImageUtils imageKeysForSample:selectedSample];
    
    CGFloat screenWidth = [[UIScreen mainScreen] bounds].size.width;
    int yInc = 0;
    NSString* imageName = @"no_image.png";
    
    defaultImage = [UIImage imageNamed:imageName];
    if(![UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        for(int i = 0; i < [imageArray count]; i++)
        {
            UIImage* newImg = [imageArray objectAtIndex:i];
            imgView = [[UIImageView alloc] initWithImage:newImg];
            imgView.tag = i;
            
            UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
            singleTap.numberOfTapsRequired = 1;
            imgView.userInteractionEnabled = YES;
            [imgView addGestureRecognizer:singleTap];
        
            [imgView setContentMode:UIViewContentModeScaleAspectFit];
        
            UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth/2-150, 175+yInc, 300, 30)];
            imgView.frame = CGRectMake(10, 10+yInc, 200, 150);
            imgView.center = CGPointMake(screenWidth/2, imgView.frame.size.height/2+10+yInc);
            
            [label setText:[descriptionArray objectAtIndex:i]];
            [label sizeToFit];
            label.center = CGPointMake(screenWidth/2, label.frame.size.height/2+175+yInc);
        
            yInc = yInc + 225;
            [_scrollView addSubview:imgView];
            [_scrollView addSubview:label];
        }
        [_scrollView setContentSize:CGSizeMake(screenWidth, (225*[imageArray count])+100)];
    }
    
   else
   {
       for(int i = 0; i < [imageArray count]; i++)
       {
           UIImage* newImg = [imageArray objectAtIndex:i];
           imgView = [[UIImageView alloc] initWithImage:newImg];
           
           UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapDetected:)];
           singleTap.numberOfTapsRequired = 1;
           imgView.userInteractionEnabled = YES;
           [imgView addGestureRecognizer:singleTap];

           
           [imgView setContentMode:UIViewContentModeScaleAspectFit];
           
           UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(screenWidth/2-150, 525+yInc, 300, 30)];
           imgView.frame = CGRectMake(10, 50+yInc, 600, 450);
           imgView.center = CGPointMake(screenWidth/2, imgView.frame.size.height/2+10+yInc);
           
           [label setText:[descriptionArray objectAtIndex:i]];
           [label sizeToFit];
           label.center = CGPointMake(screenWidth/2, label.frame.size.height/2+525+yInc);
           
           yInc = yInc + 650;
           [_scrollView addSubview:imgView];
           [_scrollView addSubview:label];
       }
       [_scrollView setContentSize:CGSizeMake(screenWidth, (650*[imageArray count])+100)];
   }
    self.title = [NSString stringWithFormat:TITLE_FORMAT, self.selectedSample.key];
    [self.navigationItem setTitle:self.title];
}

-(IBAction)tapDetected:(id)sender
{
    UITapGestureRecognizer *tempView = sender;
    UIImageView *tempImageView = (UIImageView*)tempView.view;
    int index = tempImageView.tag;
    NSString* desc = [descriptionArray objectAtIndex:index];
    
    EnlargedImageViewController* eIVC = [[EnlargedImageViewController alloc] initWithSample:selectedSample
                                                                                withLibrary:libraryObjectStore
                                                                                  withImage:tempImageView.image
                                                                            withDescription:desc];
    
    [[self navigationController] pushViewController:eIVC animated:YES];

    
    
}

@end
