//
//  AddSampleFiveViewController.h
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 3/1/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Sample.h"
#import "AbstractCloudLibraryObjectStore.h"

@interface AddSampleFiveViewController : UIViewController<UITextFieldDelegate, UITableViewDelegate, UIAlertViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *GroupField;
@property (weak, nonatomic) IBOutlet UITextField *FormationField;
@property (weak, nonatomic) IBOutlet UITextField *MemberField;

@property(nonatomic) Sample* sampleToAdd;
@property(nonatomic) AbstractCloudLibraryObjectStore *libraryObjectStore;

- (id)initWithSample:(Sample *)initSample
   WithLibraryObject:(AbstractCloudLibraryObjectStore *)initLibrary;
@end
