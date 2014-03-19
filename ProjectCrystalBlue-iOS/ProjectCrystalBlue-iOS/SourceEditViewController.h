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
    __weak IBOutlet UITextField *TypeField;
    __weak IBOutlet UITextField *LithologyField;
    __weak IBOutlet UITextField *DeposystemField;
    __weak IBOutlet UITextField *GroupField;
    __weak IBOutlet UITextField *FormationField;
    __weak IBOutlet UITextField *MemberField;
    __weak IBOutlet UITextField *RegionField;
    __weak IBOutlet UITextField *LocalityField;
    __weak IBOutlet UITextField *SectionField;
    __weak IBOutlet UITextField *MeterField;
    __weak IBOutlet UITextField *LatitudeField;
    __weak IBOutlet UITextField *LongitudeField;
    __weak IBOutlet UITextField *AgeField;
    __weak IBOutlet UITextField *AgeMethodField;
    __weak IBOutlet UITextField *AgeDataTypeField;
    __weak IBOutlet UITextField *DateField;
}
@property (nonatomic, strong) IBOutlet UIScrollView *scroller;
@property (nonatomic, strong) Source *selectedSource;
@property (nonatomic, strong) AbstractCloudLibraryObjectStore *libraryObjectStore;


@property (nonatomic, copy) void (^dismissBlock)(void);

- (IBAction)backgroundTapped:(id)sender;
- (id)initWithSource:(Source*)initSample;

@end
