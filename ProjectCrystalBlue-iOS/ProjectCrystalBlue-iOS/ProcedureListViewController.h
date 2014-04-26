//
//  ProcedureListViewController.h
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 2/17/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Split.h"
#import "AbstractCloudLibraryObjectStore.h"

@interface ProcedureListViewController : UITableViewController <UINavigationControllerDelegate>

@property (nonatomic, strong) Split *selectedSplit;
@property (strong) AbstractCloudLibraryObjectStore *libraryObjectStore;

- (id)initWithSplit:(Split*)initSplit
         WithLibrary:(AbstractCloudLibraryObjectStore *)library;

@end
