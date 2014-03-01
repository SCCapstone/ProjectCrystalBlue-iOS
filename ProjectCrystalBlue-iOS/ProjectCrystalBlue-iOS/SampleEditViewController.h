//
//  SampleEditViewController.h
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 2/15/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Sample.h"
#import "AbstractCloudLibraryObjectStore.h"
#import "SimpleDBLibraryObjectStore.h"

@interface SampleEditViewController : UITableViewController <UINavigationControllerDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) Sample *selectedSample;
@property (nonatomic, strong) SimpleDBLibraryObjectStore *libraryObjectStore;


-(id)initWithSample:(Sample *)initSample;

@end
