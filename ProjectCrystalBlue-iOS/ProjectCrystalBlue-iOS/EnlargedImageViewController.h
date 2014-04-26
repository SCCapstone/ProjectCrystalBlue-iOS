//
//  EnlargedImageViewController.h
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 4/20/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Sample.h"
#import "AbstractCloudLibraryObjectStore.h"

@interface EnlargedImageViewController : UIViewController<UIAlertViewDelegate>
{
    __strong IBOutlet UIImageView *imgView;
}

@property(nonatomic) Sample* selectedSample;
@property (nonatomic, strong) AbstractCloudLibraryObjectStore *libraryObjectStore;

- (id)initWithSample:(Sample*)initSample
         withLibrary:(AbstractCloudLibraryObjectStore*)initLibrary
           withImage:(UIImage*)initImage
     withDescription:(NSString*)initDescription;

@end
