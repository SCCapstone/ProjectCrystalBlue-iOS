//
//  ImageUtils.m
//  ProjectCrystalBlue-iOS
//
//  Created by Logan Hood on 2/14/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "ImageUtils.h"
#import "PCBLogWrapper.h"

@implementation ImageUtils

float const DEFAULT_JPEG_COMPRESSION = 0.90f;

/// Return a JPEG representation of the UIImage, using a default JPEG compression factor of 0.90
+(NSData *)JPEGDataFromImage:(UIImage *)image
{
    return [self.class JPEGDataFromImage:image
                         withCompression:DEFAULT_JPEG_COMPRESSION];
}

/// Return a JPEG representation of the UIImage, with a specified JPEG compression factor.
+(NSData *)JPEGDataFromImage:(UIImage *)image
             withCompression:(float)compressionFactor
{
    return UIImageJPEGRepresentation(image, compressionFactor);
}

@end
