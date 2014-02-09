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
#import "SourceStore.h"
#import "DDLog.h"

#ifdef DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

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
    
    BOOL keyExists = false;
    
    for (int i = 0; i < [[[SourceStore sharedStore] allSources] count]; i++) {
        if ([[[[[SourceStore sharedStore] allSources] objectAtIndex:i] key] isEqualToString:[KeyField text]] ) {
            keyExists = true;
        }
    }
    
    if (keyExists == false) {
        
    source.key = [KeyField text];
    [[source attributes] setObject:[TypeField text] forKey:@"Type"];
    [[source attributes] setObject:[LatitudeField text] forKey:@"Latitude"];
    [[source attributes] setObject:[LongitudeField text] forKey:@"Longitude"];
    }
    
    else
    {
        [[SourceStore sharedStore] removeSource:source];
    }
    
    
    
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


- (id)initForNewSource:(BOOL)isNew
{
    self = [super initWithNibName:@"SourceEditViewController" bundle:nil];
    if (self)
    {
        if (isNew)
        {
            UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]
                                           initWithBarButtonSystemItem:UIBarButtonSystemItemDone
                                           target:self
                                           action:@selector(save:)];
            [[self navigationItem] setRightBarButtonItem:doneButton];
            
            UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]
                                             initWithBarButtonSystemItem:UIBarButtonSystemItemCancel
                                             target:self
                                             action:@selector(cancel:)];
            [[self navigationItem] setLeftBarButtonItem:cancelButton];
        }
    }
    return self;
}

- (void)save:(id)sender
{
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:_dismissBlock];
}

- (void)cancel:(id)sender
{
    [[SourceStore sharedStore] removeSource:source];
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:_dismissBlock];
}

@end
