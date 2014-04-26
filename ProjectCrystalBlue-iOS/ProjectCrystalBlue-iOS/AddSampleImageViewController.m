//
//  AddSampleImageViewController.m
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 3/22/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "AddSampleImageViewController.h"
#import "Split.h"
#import "DDLog.h"
#import "SampleImageUtils.h"

#ifdef DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@interface AddSampleImageViewController ()
{
    UIImage *image;
}

@end

@implementation AddSampleImageViewController

@synthesize libraryObjectStore, sampleToAdd, titleNav, imageArray, descriptionArray;

- (id)initWithSample:(Sample *)initSample
   WithLibraryObject:(AbstractCloudLibraryObjectStore *)initLibrary
           WithTitle:(NSString *)initTitle
          WithImages:(NSMutableArray *)initImages
    WithDescriptions:(NSMutableArray *)initDescriptions
{
    self = [super init];
    if (self) {
        sampleToAdd = initSample;
        libraryObjectStore = initLibrary;
        titleNav = initTitle;
        imageArray = initImages;
        descriptionArray = initDescriptions;
        
        UINavigationItem *n = [self navigationItem];
        [n setTitle:titleNav];
        UIBarButtonItem *bbi;
        if ([titleNav isEqualToString:@"Close View Outcrop"]) {
            bbi = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(addSample:)];
        }
        else {
            bbi = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:self action:@selector(addSample:)];
        }
        
        UIBarButtonItem *backbtn = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(goBack:)];
        
        [[self navigationItem] setRightBarButtonItem:bbi];
        [[self navigationItem] setLeftBarButtonItem:backbtn];
    }
    return self;
    
}

- (IBAction)addSample:(id)sender
{
    if ([titleNav isEqualToString:@"Far View Outcrop"])
    {
        if(image)
        {
            [imageArray addObject:image];
            [descriptionArray addObject:@"Far View Outcrop"];
        }
        
        AddSampleImageViewController *asiViewController = [[AddSampleImageViewController alloc] initWithSample:sampleToAdd
                                                                                             WithLibraryObject:libraryObjectStore
                                                                                                     WithTitle:@"Medium View Outcrop"
                                                                                                    WithImages:imageArray
                                                                                              WithDescriptions:descriptionArray];
         [[self navigationController] pushViewController:asiViewController  animated:YES];
    }
    else if ([titleNav isEqualToString:@"Medium View Outcrop"])
    {
        if(image)
        {
            [imageArray addObject:image];
            [descriptionArray addObject:@"Medium View Outcrop"];
        }
        
        AddSampleImageViewController *asiViewController = [[AddSampleImageViewController alloc] initWithSample:sampleToAdd
                                                                                             WithLibraryObject:libraryObjectStore
                                                                                                     WithTitle:@"Close View Outcrop"
                                                                                                    WithImages:imageArray
                                                                                              WithDescriptions:descriptionArray];
        [[self navigationController] pushViewController:asiViewController  animated:YES];
    }
    
    else
    {
        if(image)
        {
            [imageArray addObject:image];
            [descriptionArray addObject:@"Close View Outcrop"];
        }
        
        
         DDLogInfo(@"Adding new sample %@", sampleToAdd.key);
         [libraryObjectStore putLibraryObject:sampleToAdd IntoTable:[SampleConstants tableName]];
         
         NSString *newSplitKey = [NSString stringWithFormat:@"%@%@", [sampleToAdd key], @".001"];
         Split *newSplit = [[Split alloc] initWithKey:newSplitKey
         AndWithValues:[SplitConstants attributeDefaultValues]];
         [[newSplit attributes] setObject:[sampleToAdd key] forKey:SPL_SAMPLE_KEY];
         [libraryObjectStore putLibraryObject:newSplit IntoTable:[SplitConstants tableName]];
            
            for(int i = 0; i < [imageArray count]; i++)
            {
                [SampleImageUtils addImage:[imageArray objectAtIndex:i] forSample:sampleToAdd inDataStore:libraryObjectStore withImageTag:[descriptionArray objectAtIndex:i] intoImageStore:[SampleImageUtils defaultImageStore]];
            }
     
        [[self navigationController] popToRootViewControllerAnimated:YES];
    }
}

-(void) goBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (IBAction)takePicture:(id)sender
{
    if ([imagePickerPopover isPopoverVisible])
    {
        [imagePickerPopover dismissPopoverAnimated:YES];
        imagePickerPopover = nil;
        return;
    }
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
        [imagePicker setDelegate:self];
        
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        {
            imagePickerPopover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
            
            [imagePickerPopover setDelegate:self];

            UIButton *photoButton = (UIButton *)sender;
            [imagePickerPopover presentPopoverFromRect:photoButton.bounds
                                                inView:self.view
                              permittedArrowDirections:UIPopoverArrowDirectionAny
                                              animated:YES];
        }
        else
            [self presentViewController:imagePicker animated:YES completion:nil];
    }
    else
    {
        NSString *message = @"Device doesn't have a camera.";
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:message
                              message:nil
                              delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (IBAction)uploadPhoto:(id)sender
{
     UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    
    [imagePicker setDelegate:self];
    
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    image = [info objectForKey:UIImagePickerControllerOriginalImage];
    [imageView setImage:image];
    [picker dismissViewControllerAnimated:YES completion:NULL];
}

@end
