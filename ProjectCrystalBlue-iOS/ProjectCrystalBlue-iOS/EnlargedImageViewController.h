//
//  EnlargedImageViewController.h
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 4/20/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EnlargedImageViewController : UIViewController
{
    __strong IBOutlet UIImageView *imgView;
}

- (id)initWithImage:(UIImage*)initImage withTag:(NSString*)initTag;

@end
