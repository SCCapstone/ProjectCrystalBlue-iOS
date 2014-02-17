//
//  SourceEditViewController.h
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 1/31/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Source.h"
#import "AbstractCloudLibraryObjectStore.h"
#import "SimpleDBLibraryObjectStore.h"

@interface SourceEditViewController : UIViewController
<UINavigationControllerDelegate,UITextFieldDelegate, UIAlertViewDelegate>

{
    __weak IBOutlet UITextField *KeyField;
    __weak IBOutlet UITextField *TypeField;
    __weak IBOutlet UITextField *LatitudeField;
    __weak IBOutlet UITextField *LongitudeField;
   
}
@property (nonatomic, strong) IBOutlet UIScrollView *scroller;
@property (nonatomic, strong) Source *source;
@property (nonatomic, strong) SimpleDBLibraryObjectStore *libraryObjectStore;

@property (nonatomic, copy) void (^dismissBlock)(void);

- (IBAction)backgroundTapped:(id)sender;

- (id)initForNewSource:(BOOL)isNew;

@end
