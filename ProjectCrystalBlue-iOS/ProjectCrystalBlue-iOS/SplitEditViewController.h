//
//  SplitEditViewController.h
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 2/15/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Split.h"
#import "AbstractCloudLibraryObjectStore.h"

@interface SplitEditViewController : UITableViewController <UINavigationControllerDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) Split *selectedSplit;
@property (nonatomic, strong) AbstractCloudLibraryObjectStore *libraryObjectStore;

- (id)initWithSplit:(Split *)initSplit
         WithLibrary:(AbstractCloudLibraryObjectStore*)initLibrary
AndNavigateBackToRoot:(BOOL)navigateBackToRoot;

@end
