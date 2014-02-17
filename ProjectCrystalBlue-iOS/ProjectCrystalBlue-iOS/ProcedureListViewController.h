//
//  ProcedureListViewController.h
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 2/17/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Sample.h"

@interface ProcedureListViewController : UITableViewController <UINavigationControllerDelegate>

@property (nonatomic, strong) Sample *selectedSample;

-(id)initWithSample:(Sample *)initSample;
@end
