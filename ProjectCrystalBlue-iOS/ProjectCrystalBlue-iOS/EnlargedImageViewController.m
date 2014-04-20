//
//  EnlargedImageViewController.m
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 4/20/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "EnlargedImageViewController.h"
#import "SourceImageUtils.h"
#import "Source.h"
#import "AbstractCloudLibraryObjectStore.h"

@interface EnlargedImageViewController ()
{
    UIImage* image;
    NSString* description;
    NSString* option;
}
@end

@implementation EnlargedImageViewController

@synthesize selectedSource, libraryObjectStore;

- (id)initWithSource:(Source*) initSource  withLibrary:(AbstractCloudLibraryObjectStore*)initLibrary withImage:(UIImage*)initImage withDescription:(NSString*)initDescription
{
    self = [super init];
    if (self)
    {
        image = initImage;
        selectedSource = initSource;
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
    UIActionSheet *message;
    
    if([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
    {
        
        message = [[UIActionSheet alloc] initWithTitle:@"Deleting will remove image from image store:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Delete", @"Cancel", nil];

        CGFloat wid = [[UIScreen mainScreen] bounds].size.width;
        CGFloat hei = [[UIScreen mainScreen] bounds].size.height;
        
        [message showFromRect:CGRectMake(wid/2-75, hei-50, 150, 100) inView:self.view animated:YES];
    }
    else
    {
        message = [[UIActionSheet alloc] initWithTitle:@"Deleting will remove image from image store:" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Delete", nil];

        [message showInView:self.view];
    }
    
    while ((!message.hidden) && (message.superview != nil))
    {
        [[NSRunLoop currentRunLoop] limitDateForMode:NSDefaultRunLoopMode];
    }

    if([option isEqualToString:@"Delete"])
    {
        [SourceImageUtils removeImage:description forSource:selectedSource inDataStore:libraryObjectStore inImageStore:[SourceImageUtils        defaultImageStore]];
        [self.navigationController popViewControllerAnimated:YES];
    }
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


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0:
            option = @"Delete";
            break;
        case 1:
            option = @"NOTHING";
            break;
    }
}

@end
