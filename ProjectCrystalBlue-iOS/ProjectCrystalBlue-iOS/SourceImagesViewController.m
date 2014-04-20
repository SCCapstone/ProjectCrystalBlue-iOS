//
//  sourceImagesViewController.m
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 3/30/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "SourceImagesViewController.h"
#import "Source.h"
#import "AbstractCloudLibraryObjectStore.h"
#import "SourceImageUtils.h"
#import "AddImageViewController.h"
#import "EnlargedImageViewController.h"


@interface SourceImagesViewController ()
{
    UIImage* defaultImage;
    NSArray* imageArray;
    NSArray* descriptionArray;
    UIImageView* imgView;
}
@end

@implementation SourceImagesViewController
@synthesize selectedSource, libraryObjectStore;

- (id)initWithSource:(Source*)initSource withLibrary:(AbstractCloudLibraryObjectStore*)initLibrary
{
    self = [super init];
    if (self) {
        selectedSource = initSource;
        libraryObjectStore = initLibrary;
        NSString* title = @"Images for ";
        title = [title stringByAppendingString:selectedSource.key];
        
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
    AddImageViewController* imgViewController = [[AddImageViewController alloc] initWithSource: selectedSource WithLibraryObject:libraryObjectStore];
    
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


- (void)viewWillAppear:(BOOL)animated
{
    [self loadImages];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void) loadImages
{
    imageArray = [SourceImageUtils imagesForSource:selectedSource inImageStore:[SourceImageUtils defaultImageStore]];
    descriptionArray = [SourceImageUtils imageKeysForSource:selectedSource];
    
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
}

-(IBAction)tapDetected:(id)sender
{
    UITapGestureRecognizer *tempView = sender;
    UIImageView *tempImageView = (UIImageView*) tempView.view;
    
    EnlargedImageViewController* eIVC = [[EnlargedImageViewController alloc] initWithImage:tempImageView.image withTag:@"Image Title"];
    
    [[self navigationController] pushViewController:eIVC animated:YES];

    
    
}

@end
