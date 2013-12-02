//
//  ViewController.h
//  example adding a comment
//
//  Created by Ryan McGraw on 11/12/13.
//  Copyright (c) 2013 PCB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController<UITextFieldDelegate>
{
    IBOutlet UITextField *field;
}


@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *address;

-(BOOL)textFieldShouldReturn:(UITextField *)textField;
-(IBAction) clickedBackground;
@end
