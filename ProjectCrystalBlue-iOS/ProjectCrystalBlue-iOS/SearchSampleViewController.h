//
//  SearchSampleViewController.h
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 3/1/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchSampleViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *searchField;

- (IBAction)searchSample:(id)sender;

@end
