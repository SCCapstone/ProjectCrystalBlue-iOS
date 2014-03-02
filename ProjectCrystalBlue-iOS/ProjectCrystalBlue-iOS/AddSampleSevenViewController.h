//
//  AddSampleSevenViewController.h
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 3/1/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Source.h"
#import "AbstractCloudLibraryObjectStore.h"

@interface AddSampleSevenViewController : UIViewController<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *AgeField;
@property (weak, nonatomic) IBOutlet UITextField *AgeBasis1Field;
@property (weak, nonatomic) IBOutlet UITextField *AgeBasis2Field;

@property(nonatomic) Source* sourceToAdd;
@property(nonatomic) AbstractCloudLibraryObjectStore *libraryObjectStore;

-(id)initWithSource:(Source *)initSource;
@end