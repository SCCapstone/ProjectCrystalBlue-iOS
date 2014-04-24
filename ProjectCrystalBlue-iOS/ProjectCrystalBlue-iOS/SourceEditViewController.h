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
#import "SimpleTableViewController.h"
#import "CoreLocation/CoreLocation.h"

@interface SourceEditViewController : UIViewController
<UINavigationControllerDelegate,UITextFieldDelegate, UIAlertViewDelegate,CLLocationManagerDelegate, SimpleTableViewControllerDelegate>
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
    __weak IBOutlet UITextField *CollectedField;
   
    __weak IBOutlet UILabel *TypeLabel;
    __weak IBOutlet UILabel *LithologyLabel;
    __weak IBOutlet UILabel *DeposystemLabel;
    __weak IBOutlet UILabel *GroupLabel;
    __weak IBOutlet UILabel *FormationLabel;
    __weak IBOutlet UILabel *MemberLabel;
    __weak IBOutlet UILabel *RegionLabel;
    __weak IBOutlet UILabel *LocalityLabel;
    __weak IBOutlet UILabel *SectionLabel;
    __weak IBOutlet UILabel *MeterLabel;
    __weak IBOutlet UILabel *LatitudeLabel;
    __weak IBOutlet UILabel *LongitudeLabel;
    __weak IBOutlet UILabel *AgeLabel;
    __weak IBOutlet UILabel *AgeMethodLabel;
    __weak IBOutlet UILabel *AgeDataTypeLabel;
    __weak IBOutlet UILabel *CollectedLabel;
    __weak IBOutlet UILabel *DateLabel;
   
    __weak IBOutlet UIDatePicker *DatePicker;
}
@property (nonatomic, strong) IBOutlet UIScrollView *scroller;
@property (nonatomic, strong) Source *selectedSource;
@property (nonatomic, strong) AbstractCloudLibraryObjectStore *libraryObjectStore;
@property (nonatomic, copy) void (^dismissBlock)(void);

- (id)initWithSource:(Source*)initSource
         WithLibrary:(AbstractCloudLibraryObjectStore*)initLibrary
AndNavigateBackToRoot:(BOOL)navigateBackToRoot;

- (IBAction)backgroundTapped:(id)sender;
- (IBAction)picturedTapped:(id)sender;
- (IBAction)showRockTypeOptions:(id)sender;
- (IBAction)showLithologyOptions:(id)sender;
- (IBAction)showDeposytemOptions:(id)sender;
- (IBAction)showAgeMethodOptions:(id)sender;
- (IBAction)getLocation:(id)sender;
- (IBAction)dateChanged:(id)sender;
- (IBAction)viewMap:(id)sender;

@end
