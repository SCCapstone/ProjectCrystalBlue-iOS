//
//  AddSourceViewController.h
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 2/2/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AddSourceViewController : UIViewController

{
    __weak IBOutlet UITextField *KeyField;
    __weak IBOutlet UITextField *TypeField;
    __weak IBOutlet UITextField *LatitudeField;
    __weak IBOutlet UITextField *LongitudeField;
}

@end