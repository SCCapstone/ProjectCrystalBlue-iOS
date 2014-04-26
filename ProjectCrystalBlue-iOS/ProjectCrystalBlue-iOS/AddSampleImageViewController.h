//
//  AddSampleImageViewController.h
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 3/22/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Sample.h"
#import "AbstractCloudLibraryObjectStore.h"

@interface AddSampleImageViewController : UIViewController <UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIPopoverControllerDelegate, UIAlertViewDelegate>
{
    __weak IBOutlet UIImageView *imageView;
    UIPopoverController *imagePickerPopover;
}

@property(nonatomic) Sample* sampleToAdd;
@property(nonatomic) AbstractCloudLibraryObjectStore *libraryObjectStore;
@property(nonatomic) NSString *titleNav;
@property(nonatomic) NSMutableArray *imageArray;
@property(nonatomic) NSMutableArray *descriptionArray;

- (id)initWithSample:(Sample *)initSample
   WithLibraryObject:(AbstractCloudLibraryObjectStore *)initLibrary
           WithTitle:(NSString*)initTitle
          WithImages:(NSMutableArray *)initImages
    WithDescriptions:(NSMutableArray *)initDescriptions;

- (IBAction)takePicture:(id)sender;
- (IBAction)uploadPhoto:(id)sender;
@end
