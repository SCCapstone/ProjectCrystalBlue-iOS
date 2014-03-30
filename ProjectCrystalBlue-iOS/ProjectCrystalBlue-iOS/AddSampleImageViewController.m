//
//  AddSampleImageViewController.m
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 3/22/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "AddSampleImageViewController.h"
#import "Sample.h"
#import "DDLog.h"
#import "SourceImageUtils.h"

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

@synthesize libraryObjectStore, sourceToAdd, titleNav;

- (id)initWithSource:(Source *)initSource WithLibraryObject:(AbstractCloudLibraryObjectStore *) initLibrary WithTitle:(NSString*) initTitle{
    if (self) {
        sourceToAdd = initSource;
        libraryObjectStore = initLibrary;
        titleNav = initTitle;
        
        UINavigationItem *n = [self navigationItem];
        [n setTitle:titleNav];
        
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStyleBordered target:self action:@selector(addSource:)];
        if ([titleNav isEqualToString:@"Short View Outcrop"]) {
            bbi.title = @"Done";
        }
        
        UIBarButtonItem *backbtn = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(goBack:)];
        
        [[self navigationItem] setRightBarButtonItem:bbi];
        [[self navigationItem] setLeftBarButtonItem:backbtn];
        
    }
    return self;
    
}

- (IBAction)addSource:(id)sender {
    
    
    //[info objectForKey:UIImagePickerControllerOriginalImage];
    
    if ([titleNav isEqualToString:@"Far View Outcrop"]) {
        if(image)
        {
         [SourceImageUtils addImage:image forSource:sourceToAdd inDataStore:libraryObjectStore withImageTag:(NSString *)@"Far View Outcrop" intoImageStore:[SourceImageUtils defaultImageStore]];
        }
        
        AddSampleImageViewController *asiViewController = [[AddSampleImageViewController alloc] initWithSource:sourceToAdd WithLibraryObject:libraryObjectStore WithTitle:@"Medium View Outcrop"];
        
         [[self navigationController] pushViewController:asiViewController  animated:YES];
    }
    
    else if ([titleNav isEqualToString:@"Medium View Outcrop"]) {
        if(image)
        {
         [SourceImageUtils addImage:image forSource:sourceToAdd inDataStore:libraryObjectStore withImageTag:(NSString *)@"Medium View Outcrop" intoImageStore:[SourceImageUtils defaultImageStore]];
        }
        
        AddSampleImageViewController *asiViewController = [[AddSampleImageViewController alloc] initWithSource:sourceToAdd WithLibraryObject:libraryObjectStore WithTitle:@"Close View Outcrop"];
        [[self navigationController] pushViewController:asiViewController  animated:YES];
    }
    
    else
    {
        if(image)
        {
         [SourceImageUtils addImage:image forSource:sourceToAdd inDataStore:libraryObjectStore withImageTag:(NSString *)@"Close View Outcrop" intoImageStore:[SourceImageUtils defaultImageStore]];
        }
        
     DDLogInfo(@"Adding new source %@", sourceToAdd.key);
     [libraryObjectStore putLibraryObject:sourceToAdd IntoTable:[SourceConstants tableName]];
     
     NSString *newSampleKey = [NSString stringWithFormat:@"%@%@", [sourceToAdd key], @".001"];
     Sample *newSample = [[Sample alloc] initWithKey:newSampleKey
     AndWithValues:[SampleConstants attributeDefaultValues]];
     [[newSample attributes] setObject:[sourceToAdd key] forKey:SMP_SOURCE_KEY];
     [libraryObjectStore putLibraryObject:newSample IntoTable:[SampleConstants tableName]];
 
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
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        // Do popover if iPad
        if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
        {
            imagePickerPopover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
            
            [imagePickerPopover setDelegate:self];
            [imagePickerPopover presentPopoverFromBarButtonItem:sender
                                       permittedArrowDirections:UIPopoverArrowDirectionAny
                                                       animated:YES];
        }
        // iPhone/iPod touch - modal display
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
    
    // Do popover if iPad
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        imagePickerPopover = [[UIPopoverController alloc] initWithContentViewController:imagePicker];
        
        [imagePickerPopover setDelegate:self];
        [imagePickerPopover presentPopoverFromBarButtonItem:sender
                                   permittedArrowDirections:UIPopoverArrowDirectionAny
                                                   animated:YES];
    }
    // iPhone/iPod touch - modal display
    else
        [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    image = info[UIImagePickerControllerEditedImage];
    imageView.image = image;
    
    [picker dismissViewControllerAnimated:YES completion:NULL];
    
}
@end
