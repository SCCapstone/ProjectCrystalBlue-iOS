//
//  SourceEditViewController.h
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 1/31/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Source.h"


@interface SourceEditViewController : UIViewController
<UINavigationControllerDelegate,UITextFieldDelegate>

{
    __weak IBOutlet UITextField *KeyField;
    __weak IBOutlet UITextField *TypeField;
    __weak IBOutlet UITextField *LatitudeField;
    __weak IBOutlet UITextField *LongitudeField;
}
@property (nonatomic, strong) Source *source;

@property (nonatomic, copy) void (^dismissBlock)(void);
@property (nonatomic) BOOL isNewSource;

- (IBAction)backgroundTapped:(id)sender;

- (id)initForNewSource:(BOOL)isNew;

@end
