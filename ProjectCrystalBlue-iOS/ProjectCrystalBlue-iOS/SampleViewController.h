//
//  SampleViewController.h
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 2/8/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SampleViewController : UITableViewController <UIActionSheetDelegate>

@property(nonatomic) NSString* option;
@property(nonatomic) NSMutableArray* sampleSet;

@end
