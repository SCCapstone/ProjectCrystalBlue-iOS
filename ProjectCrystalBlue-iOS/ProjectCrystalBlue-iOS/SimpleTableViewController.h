//
//  SimpleTableViewController.h
//  ProjectCrystalBlue-iOS
//
//  Created by Justin Baumgartner on 4/12/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SimpleTableViewControllerDelegate <NSObject>

@required
- (void)itemSelectedAtRow:(NSInteger)row
                  WithTag:(NSUInteger)tag;

@end

@interface SimpleTableViewController : UITableViewController

@property (strong, nonatomic) NSArray *tableData;
@property NSUInteger tag;
@property (assign, nonatomic) id<SimpleTableViewControllerDelegate> delegate;

@end
