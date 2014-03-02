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

@interface SourcesEditViewController : UIViewController
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
    __weak IBOutlet UITextField *MeterLevelField;
    __weak IBOutlet UITextField *LatitudeField;
    __weak IBOutlet UITextField *LongitudeField;
    __weak IBOutlet UITextField *AgeField;
    __weak IBOutlet UITextField *AgeBasis1Field;
    __weak IBOutlet UITextField *AgeBasis2Field;
    __weak IBOutlet UITextField *ProjectField;
    __weak IBOutlet UITextField *SubprojectField;
    
}
@property (nonatomic, strong) IBOutlet UIScrollView *scroller;
@property (nonatomic, strong) Source *source;
@property (nonatomic, strong) SimpleDBLibraryObjectStore *libraryObjectStore;

@property (nonatomic, copy) void (^dismissBlock)(void);

- (IBAction)backgroundTapped:(id)sender;


@end
