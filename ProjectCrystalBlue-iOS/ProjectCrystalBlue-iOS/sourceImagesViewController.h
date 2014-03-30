//
//  sourceImagesViewController.h
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 3/30/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Source.h"
#import "AbstractCloudLibraryObjectStore.h"

@interface sourceImagesViewController : UIViewController<UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (id)initWithSource:(Source*)initSource withLibrary:(AbstractCloudLibraryObjectStore*)initLibrary;

@property (nonatomic, strong) Source *selectedSource;
@property (nonatomic, strong) AbstractCloudLibraryObjectStore *libraryObjectStore;
@end
