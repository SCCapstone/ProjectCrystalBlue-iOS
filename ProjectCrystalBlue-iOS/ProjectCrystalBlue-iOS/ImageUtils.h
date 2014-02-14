//
//  ImageUtils.h
//  ProjectCrystalBlue-iOS
//
//  Created by Logan Hood on 2/14/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  Some helper methods for handling images.
 */
@interface ImageUtils : NSObject

/// Return a JPEG representation of the UIImage, using a default JPEG compression factor of 0.90
+(NSData *)JPEGDataFromImage:(UIImage *)image;

/// Return a JPEG representation of the UIImage, with a specified JPEG compression factor.
+(NSData *)JPEGDataFromImage:(UIImage *)image
             withCompression:(float)compressionFactor;

@end
