//
//  AddSampleThreeViewController.h
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 3/1/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Source.h"
#import "SimpleDBLibraryObjectStore.h"

@interface AddSampleThreeViewController : UITableViewController

@property(nonatomic) Source* sourceToAdd;
@property(nonatomic) AbstractCloudLibraryObjectStore *libraryObjectStore;
@property(nonatomic) NSString* typeSelected;
@property(nonatomic) NSUInteger numRows;

- (id)initWithSource:(Source *)initSource WithLibraryObject:(AbstractCloudLibraryObjectStore *) initLibrary;@end
