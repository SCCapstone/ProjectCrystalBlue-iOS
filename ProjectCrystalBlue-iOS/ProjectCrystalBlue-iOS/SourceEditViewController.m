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
#import "DDLog.h"
#import "Sample.h"
#import "AbstractCloudLibraryObjectStore.h"
#import "SimpleDBLibraryObjectStore.h"
#import "SourceConstants.h"

#ifdef DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@interface SourceEditViewController ()

@end

@implementation SourceEditViewController

@synthesize source, scroller, libraryObjectStore;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {

    }
    return self;
}

- (void)viewDidLoad {
    [self.scroller setScrollEnabled:YES];
    [scroller setContentSize:CGSizeMake(320, 950)];
    
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
    [TypeField setText:[[source attributes] objectForKey:SRC_TYPE]];
    [LatitudeField setText:[[source attributes] objectForKey:SRC_LATITUDE]];
    [LongitudeField setText:[[source attributes] objectForKey:SRC_LONGITUDE]];
    // [TypeField setText:[source attributes.];
    // [valueField setText:[NSString stringWithFormat:@"%d", [item valueInDollars]]];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    // Clear first responder
    [[self view] endEditing:YES];
    // "Save" changes to item
    
    BOOL keyExists = [libraryObjectStore libraryObjectExistsForKey:[KeyField text] FromTable:[SourceConstants tableName]];

    
    if (!source && !keyExists) {
        
        Source *newSource = [[Source alloc] initWithKey:[KeyField text]
                                       AndWithValues:[SourceConstants attributeDefaultValues]];
        [[newSource attributes] setObject:[TypeField text] forKey:SRC_TYPE];
        [[newSource attributes] setObject:[LatitudeField text] forKey:SRC_LATITUDE];
        [[newSource attributes] setObject:[LongitudeField text] forKey:SRC_LONGITUDE];
        
        [libraryObjectStore putLibraryObject:newSource IntoTable:[SourceConstants tableName]];
        
        NSString *newSampleKey = [NSString stringWithFormat:@"%@%@", [newSource key], @".001"];
        Sample *newSample = [[Sample alloc] initWithKey:newSampleKey
                                          AndWithValues:[SampleConstants attributeDefaultValues]];
        [[newSample attributes] setObject:[KeyField text] forKey:@"sourceKey"];
        [libraryObjectStore putLibraryObject:newSample IntoTable:[SampleConstants tableName]];
    }
    else if (source)
    {
        [[source attributes] setObject:[TypeField text] forKey:@"type"];
        [[source attributes] setObject:[LatitudeField text] forKey:@"latitude"];
        [[source attributes] setObject:[LongitudeField text] forKey:@"longitude"];
        
        [libraryObjectStore updateLibraryObject:source IntoTable:[SourceConstants tableName]];
    }
    
    else if(keyExists)
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"This key exists or was edited. Changes discarded" delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil];
        
        [alert show];
        
        [alert resignFirstResponder];
    }
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
    //[[SourceStore sharedStore] removeSource:source];
    [[self presentingViewController] dismissViewControllerAnimated:YES completion:_dismissBlock];
}


@end
