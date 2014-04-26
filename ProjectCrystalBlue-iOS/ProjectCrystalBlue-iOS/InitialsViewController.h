//
//  IntialsViewController.h
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 3/22/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Split.h"
#import "AbstractCloudLibraryObjectStore.h"

@interface InitialsViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *initialsField;
@property(nonatomic) Split* selectedSplit;
@property(nonatomic) AbstractCloudLibraryObjectStore *libraryObjectStore;
@property(nonatomic) int selectedRow;
@property(nonatomic) NSString* titleNav;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

- (id)initWithSplit:(Split*)initSplit
        withLibrary:(AbstractCloudLibraryObjectStore*)initLibrary
            withRow:(int) initRow
          withTitle:(NSString*)initTitle;
- (IBAction)backgroundTapped:(id)sender;

@end
