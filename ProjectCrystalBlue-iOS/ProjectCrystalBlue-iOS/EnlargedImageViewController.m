//
//  EnlargedImageViewController.m
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 4/20/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "EnlargedImageViewController.h"

@interface EnlargedImageViewController ()
{
    NSString* tag;
    UIImage* image;
}
@end

@implementation EnlargedImageViewController

- (id)initWithImage:(UIImage*)initImage withTag:(NSString*)initTag
{
    self = [super init];
    if (self) {
        image = initImage;
        tag = initTag;
        
        UINavigationItem *n = [self navigationItem];
        [n setTitle:tag];
        
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
    
}

- (void)viewDidLoad
{
    CGFloat heightNav = self.navigationController.navigationBar.frame.size.height+20;
    [super viewDidLoad];
    imgView =[[UIImageView alloc] init];
    [imgView setImage:image];
    imgView.frame = CGRectMake(0, heightNav, [[UIScreen mainScreen] bounds].size.width, [[UIScreen mainScreen] bounds].size.height-heightNav);
    [self.view addSubview:imgView];
}

-(void) viewDidAppear:(BOOL)animated
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
