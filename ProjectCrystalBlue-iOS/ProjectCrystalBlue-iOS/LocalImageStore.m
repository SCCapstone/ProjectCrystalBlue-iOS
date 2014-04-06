//
//  LocalImageStore.m
//  ProjectCrystalBlue-iOS
//
//  Created by Logan Hood on 2/14/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "LocalImageStore.h"
#import "ImageUtils.h"
#import "DDLog.h"

#ifdef DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@implementation LocalImageStore

-(id)initWithLocalDirectory:(NSString *)directory
{
    self = [super initWithLocalDirectory:directory];
    if (self) {
        NSArray *documentDirectories = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentDirectory = [documentDirectories objectAtIndex:0];
        localDirectory = [documentDirectory stringByAppendingFormat:@"/%@", directory];

        [[NSFileManager defaultManager] createDirectoryAtPath:localDirectory
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:nil];
    }
    return self;
}

-(UIImage *)getImageForKey:(NSString *)key
{
    if (![self imageExistsForKey:key]) {
        return nil;
    }
    
    NSString *expectedFileLocation = [localDirectory stringByAppendingFormat:@"/%@", key];
    NSData *retrievedData = [NSData dataWithContentsOfFile:expectedFileLocation];
    UIImage *image = [[UIImage alloc] initWithData:retrievedData];
    
    if (!image) {
        return nil;
    }
    
    return image;
}

-(BOOL)deleteImageWithKey:(NSString *)key
{
    if (![self imageExistsForKey:key]) {
        return NO;
    }
    
    NSString *path = [localDirectory stringByAppendingFormat:@"/%@", key];
    NSError *error = [[NSError alloc] init];
    BOOL success = [[NSFileManager defaultManager] removeItemAtPath:path
                                                              error:&error];
    if (!success) {
        DDLogError(@"%@", error);
    }
    
    return success;
}

-(BOOL)imageExistsForKey:(NSString *)key
{
    NSString *path = [localDirectory stringByAppendingFormat:@"/%@", key];
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

-(BOOL)putImage:(UIImage *)image
         forKey:(NSString *)key
{
    NSData *imageData = [ImageUtils JPEGDataFromImage:image];
    
    NSString *path = [localDirectory stringByAppendingFormat:@"/%@", key];
    BOOL success = [[NSFileManager defaultManager] createFileAtPath:path
                                                           contents:imageData
                                                         attributes:nil];
    if (success) {
        DDLogInfo(@"Wrote %@ to %@", key, path);
    }
    
    return success;
}

-(void)flushLocalImageData
{
    NSArray *files = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:localDirectory error:nil];
    
    DDLogWarn(@"Permanently deleting %lu items in directory %@!", (unsigned long)[files count], localDirectory);
    
    for (NSString* file in files) {
        NSString *path = [localDirectory stringByAppendingFormat:@"/%@", file];
        NSError *error = [[NSError alloc] init];
        BOOL success = [[NSFileManager defaultManager] removeItemAtPath:path error:&error];
        
        if (!success) {
            DDLogError(@"%@", error);
        }
    }
}

@end
