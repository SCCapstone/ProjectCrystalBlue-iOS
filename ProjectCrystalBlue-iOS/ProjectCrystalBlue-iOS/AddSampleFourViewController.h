//
//  AddSampleFourViewController.h
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 3/1/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "Sample.h"
#import "SimpleDBLibraryObjectStore.h"

@interface AddSampleFourViewController : UITableViewController

@property(nonatomic) Sample* sampleToAdd;
@property(nonatomic) AbstractCloudLibraryObjectStore *libraryObjectStore;
@property(nonatomic) NSString* typeSelected;

- (id)initWithSample:(Sample *)initSample
   WithLibraryObject:(AbstractCloudLibraryObjectStore *)initLibrary;
@end