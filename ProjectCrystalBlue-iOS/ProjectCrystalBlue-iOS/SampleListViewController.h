//
//  SampleListViewController.h
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 12/4/13.
//  Copyright (c) 2013 Project Crystal Blue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SQLiteWrapper.h"

@interface SampleListViewController : UITableViewController {
}

@property(nonatomic, strong) NSMutableArray *samples;
@property(nonatomic, strong) SQLiteWrapper *database;

@end
