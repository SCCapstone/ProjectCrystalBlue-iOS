//
//  AddSampleImageViewController.h
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 3/22/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Source.h"
#import "AbstractCloudLibraryObjectStore.h"

@interface AddSampleImageViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPopoverControllerDelegate, UIAlertViewDelegate>
{
    __weak IBOutlet UIImageView *imageView;
    UIPopoverController *imagePickerPopover;

}

@property(nonatomic) Source* sourceToAdd;
@property(nonatomic) AbstractCloudLibraryObjectStore *libraryObjectStore;
@property(nonatomic) NSString *titleNav;

- (id)initWithSource:(Source *)initSource WithLibraryObject:(AbstractCloudLibraryObjectStore *) initLibrary WithTitle:(NSString*) initTitle;
- (IBAction)takePicture:(id)sender;
- (IBAction)uploadPhoto:(id)sender;
@end
