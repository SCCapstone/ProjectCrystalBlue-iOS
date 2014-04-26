//
//  AddSampleSixViewController.h
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 3/1/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Sample.h"
#import "AbstractCloudLibraryObjectStore.h"

@interface AddSampleSixViewController : UIViewController<UITextFieldDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *RegionField;
@property (weak, nonatomic) IBOutlet UITextField *LocalityField;
@property (weak, nonatomic) IBOutlet UITextField *SectionField;
@property (weak, nonatomic) IBOutlet UITextField *MeterField;


@property(nonatomic) Sample* sampleToAdd;
@property(nonatomic) AbstractCloudLibraryObjectStore *libraryObjectStore;

- (id)initWithSample:(Sample *)initSample
   WithLibraryObject:(AbstractCloudLibraryObjectStore *)initLibrary;
@end