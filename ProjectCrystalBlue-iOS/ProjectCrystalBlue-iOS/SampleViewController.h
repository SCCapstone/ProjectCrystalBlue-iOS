//
//  SampleViewController.h
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 2/8/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Source.h"
#import "AbstractCloudLibraryObjectStore.h"

@interface SampleViewController : UITableViewController <UIActionSheetDelegate>

@property(nonatomic) Source* selectedSource;
@property(nonatomic) AbstractCloudLibraryObjectStore *libraryObjectStore;

-(id) initWithSource:(Source *) initSource;
@end
