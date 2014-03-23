//
//  IntialsViewController.h
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 3/22/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Sample.h"
#import "AbstractCloudLibraryObjectStore.h"

@interface InitialsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *initialsField;
@property(nonatomic) Sample* selectedSample;
@property(nonatomic) AbstractCloudLibraryObjectStore *libraryObjectStore;
@property(nonatomic) int selectedRow;
@property(nonatomic) NSString* titleNav;

- (id)initWithSample:(Sample*)initSample withLibrary:(AbstractCloudLibraryObjectStore*)initLibrary withRow:(int) initRow withTitle:(NSString*)initTitle;

@end
