//
//  AttributeListViewController.h
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 12/5/13.
//  Copyright (c) 2013 Project Crystal Blue. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Sample;

@interface AttributeListViewController : UITableViewController

@property(nonatomic, strong) NSMutableArray *attributes;
@property(nonatomic, strong) Sample *currentSample;

@end
