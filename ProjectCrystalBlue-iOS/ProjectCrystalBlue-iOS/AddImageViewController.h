//
//  AddImageViewController.h
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 3/30/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Source.h"
#import "AbstractCloudLibraryObjectStore.h"

@interface AddImageViewController : UIViewController<UIAlertViewDelegate,
                                                     UIImagePickerControllerDelegate,
                                                     UIPopoverControllerDelegate,
                                                     UINavigationControllerDelegate>

{
    __weak IBOutlet UIImageView *imageView;
    __weak IBOutlet UITextField *descriptionField;
    UIPopoverController *imagePickerPopover;
    
}

@property(nonatomic) Source* selectedSource;
@property(nonatomic) AbstractCloudLibraryObjectStore *libraryObjectStore;

- (id)initWithSource:(Source *)initSource WithLibraryObject:(AbstractCloudLibraryObjectStore *) initLibrary;
- (IBAction)TakePicture:(id)sender;
- (IBAction)UploadPhoto:(id)sender;

@end
