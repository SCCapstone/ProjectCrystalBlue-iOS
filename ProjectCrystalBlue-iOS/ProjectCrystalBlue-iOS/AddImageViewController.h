//
//  AddImageViewController.h
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 3/30/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Sample.h"
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

@property(nonatomic) Sample* selectedSample;
@property(nonatomic) AbstractCloudLibraryObjectStore *libraryObjectStore;

- (id)initWithSample:(Sample *)initSample
   WithLibraryObject:(AbstractCloudLibraryObjectStore *)initLibrary;
- (IBAction)takePicture:(id)sender;
- (IBAction)uploadPhoto:(id)sender;

@end
