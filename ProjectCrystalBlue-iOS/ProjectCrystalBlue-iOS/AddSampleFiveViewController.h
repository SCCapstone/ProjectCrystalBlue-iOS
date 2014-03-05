//
//  AddSourceFiveViewController.h
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 3/1/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Source.h"
#import "AbstractCloudLibraryObjectStore.h"

@interface AddSampleFiveViewController : UIViewController<UITextFieldDelegate, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITextField *GroupField;
@property (weak, nonatomic) IBOutlet UITextField *FormationField;
@property (weak, nonatomic) IBOutlet UITextField *MemberField;


@property(nonatomic) Source* sourceToAdd;
@property(nonatomic) AbstractCloudLibraryObjectStore *libraryObjectStore;

@property(nonatomic) NSMutableArray *pastGroups;
@property(nonatomic) NSMutableArray *autocompleteGroups;

@property(nonatomic) NSMutableArray *pastFormations;
@property(nonatomic) NSMutableArray *autocompleteFormations;

-(id)initWithSource:(Source *)initSource;
@end
