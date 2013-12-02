// XcodeMod adafd
//
//  ViewController.m
//  example edit
//
//  Created by Ryan McGraw on 11/12/13.
//  Copyright (c) 2013 PCB. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

//comment
@end

@implementation ViewController

@synthesize name, address;

- (void)viewDidLoad
{
    [super viewDidLoad];
	field.delegate = self;
    field.returnKeyType = UIReturnKeyDone;
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

-(IBAction)clickedBackground
{
    [self.view endEditing:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(BOOL)textFieldShouldReturn:(UITextField *)textfield {
    [textfield resignFirstResponder];
    return YES;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}
@end

