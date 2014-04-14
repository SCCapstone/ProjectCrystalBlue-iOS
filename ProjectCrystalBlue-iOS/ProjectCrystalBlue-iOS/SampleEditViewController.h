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

@interface SampleEditViewController : UITableViewController <UINavigationControllerDelegate, UIActionSheetDelegate>

@property (nonatomic, strong) Sample *selectedSample;
@property (nonatomic, strong) AbstractCloudLibraryObjectStore *libraryObjectStore;
@property (nonatomic)         NSString *option;

-(id)initWithSample:(Sample *)initSample WithOption:(NSString *) initOption;

@end
