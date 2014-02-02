//
//  SourceEditViewController.m
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 1/31/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "SourceEditViewController.h"
#import "Source.h"
#import "LibraryObject.h"


@interface SourceEditViewController ()

@end

@implementation SourceEditViewController

@synthesize source;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [[self view] setBackgroundColor:[UIColor groupTableViewBackgroundColor]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [KeyField setText:[source key]];
    [TypeField setText:[[source attributes] objectForKey:@"Type"]];
    [LatitudeField setText:[[source attributes] objectForKey:@"Latitude"]];
    [LongitudeField setText:[[source attributes] objectForKey:@"Longitude"]];
   // [TypeField setText:[source attributes.];
   // [valueField setText:[NSString stringWithFormat:@"%d", [item valueInDollars]]];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // Clear first responder
    [[self view] endEditing:YES];
    // "Save" changes to item
    [[source attributes] setObject:[TypeField text] forKey:@"Type"];
    [[source attributes] setObject:[LatitudeField text] forKey:@"Latitude"];
    [[source attributes] setObject:[LongitudeField text] forKey:@"Longitude"];
    
    
    //[item setSerialNumber:[serialNumberField text]];
    //[item setValueInDollars:[[valueField text] intValue]];
}

-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)backgroundTapped:(id)sender {
    [[self view] endEditing:YES];
}
@end
