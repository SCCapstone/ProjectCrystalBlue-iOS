//
//  EnlargedImageViewController.h
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 4/20/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Source.h"
#import "AbstractCloudLibraryObjectStore.h"

@interface EnlargedImageViewController : UIViewController<UIAlertViewDelegate>
{
    __strong IBOutlet UIImageView *imgView;
}

@property(nonatomic) Source* selectedSource;
@property (nonatomic, strong) AbstractCloudLibraryObjectStore *libraryObjectStore;

- (id)initWithSource:(Source*) initSource withLibrary:(AbstractCloudLibraryObjectStore*)initLibrary withImage:(UIImage*)initImage withDescription:(NSString*)initDescription;

@end
