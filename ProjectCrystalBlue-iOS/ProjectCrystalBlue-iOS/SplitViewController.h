//
//  SplitViewController.h
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 2/8/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Sample.h"
#import "AbstractCloudLibraryObjectStore.h"

@interface SplitViewController : UITableViewController <UIActionSheetDelegate>

@property(nonatomic) Sample* selectedSample;
@property(nonatomic) AbstractCloudLibraryObjectStore *libraryObjectStore;

-(id) initWithSample:(Sample *)initSample;

@end
