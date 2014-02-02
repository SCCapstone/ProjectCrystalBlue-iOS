//
//  SourceEditViewController.h
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 1/31/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Source;

@interface SourceEditViewController : UIViewController


@property (weak, nonatomic) IBOutlet UITextField *KeyField;
@property (weak, nonatomic) IBOutlet UITextField *TypeField;
@property (weak, nonatomic) IBOutlet UITextField *LatitudeField;
@property (weak, nonatomic) IBOutlet UITextField *LongitudeField;
@property (nonatomic, strong) Source *source;

@end
