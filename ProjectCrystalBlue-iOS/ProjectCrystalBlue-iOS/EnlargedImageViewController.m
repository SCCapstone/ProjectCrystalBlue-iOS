//
//  EnlargedImageViewController.m
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 4/20/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "EnlargedImageViewController.h"
#import "SampleImageUtils.h"
#import "Sample.h"
#import "AbstractCloudLibraryObjectStore.h"
#import "PCBLogWrapper.h"

@interface EnlargedImageViewController ()
{
    UIImage* image;
    NSString* description;
    NSString* option;
}
@end

@implementation EnlargedImageViewController

@synthesize selectedSample, libraryObjectStore;

- (id)initWithSample:(Sample*)initSample
         withLibrary:(AbstractCloudLibraryObjectStore*)initLibrary
           withImage:(UIImage*)initImage
     withDescription:(NSString*)initDescription
{
    self = [super init];
    if (self)
    {
        image = initImage;
        selectedSample = initSample;
        libraryObjectStore = initLibrary;
        description = initDescription;
        
        UINavigationItem *n = [self navigationItem];
        [n setTitle:description];
        
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithTitle:@"Delete" style:UIBarButtonItemStyleBordered target:self action:@selector(deleteImage:)];
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

-(void) deleteImage:(id)sender
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Deleting will remove from image store as well" delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"Delete", nil];
        
    [alert show];
}

- (void)viewDidLoad
{
    CGFloat heightNav = self.navigationController.navigationBar.frame.size.height+20;
    [super viewDidLoad];
    imgView =[[UIImageView alloc] init];
    [imgView setImage:image];
    imgView.frame = CGRectMake(0, heightNav, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height-heightNav);
    [imgView setContentMode:UIViewContentModeScaleAspectFit];
    [self.view addSubview:imgView];
}

- (void)willAnimateRotationToInterfaceOrientation:
(UIInterfaceOrientation)toInterfaceOrientation
                                         duration:(NSTimeInterval)duration
{
    CGFloat heightNav = self.navigationController.navigationBar.frame.size.height+20;
    
    if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
        toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        imgView.frame = CGRectMake(0, heightNav, [[UIScreen mainScreen] bounds].size.height, [[UIScreen mainScreen] bounds].size.width-heightNav);
    }
    else
    {
        imgView.frame = CGRectMake(0, heightNav, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height-heightNav);

    }
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
            break;
        case 1:
            [SampleImageUtils removeImage:description
                                forSample:selectedSample
                              inDataStore:libraryObjectStore
                             inImageStore:[SampleImageUtils defaultImageStore]];
            [self.navigationController popViewControllerAnimated:YES];
            break;
    }
}

@end
