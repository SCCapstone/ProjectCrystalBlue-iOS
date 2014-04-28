//
//  AddImageViewController.m
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 3/30/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "AddImageViewController.h"
#import "Sample.h"
#import "AbstractCloudLibraryObjectStore.h"
#import "SampleImageUtils.h"
#import "ImagesFieldValidator.h"
#import "PCBLogWrapper.h"

@interface AddImageViewController ()
{
    UIImage *image;
    UIImage *img;
}
@end

@implementation AddImageViewController
@synthesize selectedSample, libraryObjectStore;

- (id)initWithSample:(Sample *)initSample
   WithLibraryObject:(AbstractCloudLibraryObjectStore *)initLibrary
{
    self = [super init];
    if (self) {
        selectedSample = initSample;
        libraryObjectStore = initLibrary;
        
        UINavigationItem *n = [self navigationItem];
        [n setTitle:@"Add New Photo"];
        
        UIBarButtonItem *bbi = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(addImage:)];
        
        UIBarButtonItem *backbtn = [[UIBarButtonItem alloc] initWithTitle:@"Back" style:UIBarButtonItemStyleBordered target:self action:@selector(goBack:)];
        
        [[self navigationItem] setRightBarButtonItem:bbi];
        [[self navigationItem] setLeftBarButtonItem:backbtn];
        
    }
    return self;
}

- (IBAction)addImage:(id)sender {
    if (![self validateTextFieldValues]) {
        return;
    }
    if(!image)
    {
        NSString *message = @"Image Not Selected.";
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:message
                              message:nil
                              delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil, nil];
        [alert show];
    }
    else
    {
        [SampleImageUtils addImage:image forSample:selectedSample inDataStore:libraryObjectStore withImageTag:[descriptionField text] intoImageStore:[SampleImageUtils defaultImageStore]];
        [self.navigationController popViewControllerAnimated:YES];
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

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)backgroundTapped:(id)sender {
    [[self view] endEditing:YES];
}


- (IBAction)takePicture:(id)sender {
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

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self animateTextField: textField up: YES];
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self animateTextField: textField up: NO];
}

- (void) animateTextField: (UITextField*) textField up: (BOOL) up
{
    const int movementDistance = 100; // tweak as needed
    const float movementDuration = 0.3f; // tweak as needed
    
    int movement = (up ? -movementDistance : movementDistance);
    
    [UIView beginAnimations: @"anim" context: nil];
    [UIView setAnimationBeginsFromCurrentState: YES];
    [UIView setAnimationDuration: movementDuration];
    self.view.frame = CGRectOffset(self.view.frame, 0, movement);
    [UIView commitAnimations];
}

- (BOOL)validateTextFieldValues
{
    BOOL validationPassed = YES;
    
    ValidationResponse *imagesOK = [ImagesFieldValidator validateImageTag:[descriptionField text]];
    if (!imagesOK.isValid && validationPassed == YES) {
        validationPassed = NO;
        
        NSString *message = [imagesOK alertWithFieldName:@"Descripition" fieldValue:[descriptionField text]];
        
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle:message
                              message:nil
                              delegate:self
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil, nil];
        [alert show];
    }
    return validationPassed;
}
@end
