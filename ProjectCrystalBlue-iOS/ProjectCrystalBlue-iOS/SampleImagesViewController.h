//
//  SampleImagesViewController.h
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 3/30/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Sample.h"
#import "AbstractCloudLibraryObjectStore.h"

@interface SampleImagesViewController : UIViewController<UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (id)initWithSample:(Sample*)initSample
         withLibrary:(AbstractCloudLibraryObjectStore*)initLibrary;

@property (nonatomic, strong) Sample *selectedSample;
@property (nonatomic, strong) AbstractCloudLibraryObjectStore *libraryObjectStore;
@end
