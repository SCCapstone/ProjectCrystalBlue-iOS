//
//  ProcedureListViewController.h
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 2/17/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Sample.h"
#import "AbstractCloudLibraryObjectStore.h"

@interface ProcedureListViewController : UITableViewController <UINavigationControllerDelegate>

@property (nonatomic, strong) Sample *selectedSample;
@property (strong) AbstractCloudLibraryObjectStore *libraryObjectStore;

- (id)initWithSample:(Sample*)initSample WithLibrary:(AbstractCloudLibraryObjectStore *)library;

@end
