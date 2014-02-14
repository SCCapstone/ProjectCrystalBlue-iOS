//
//  AbstractMobileImageStore.m
//  ProjectCrystalBlue-iOS
//
//  Created by Logan Hood on 2/14/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "AbstractMobileImageStore.h"

@implementation AbstractMobileImageStore

-(id)init
{
    [NSException raise:@"Don't use default init method." format:@"Use the initWithLocalDirectory method."];
    return nil;
}

-(id)initWithLocalDirectory:(NSString *)directory
{
    return [super init];
}

-(UIImage *)getImageForKey:(NSString *)key
{
    [NSException raise:@"Invoked abstract method." format:@"You must use a subclass implementation of %@.", NSStringFromClass(self.class)];
    return nil;
}

-(BOOL)deleteImageWithKey:(NSString *)key
{
    [NSException raise:@"Invoked abstract method." format:@"You must use a subclass implementation of %@.", NSStringFromClass(self.class)];
    return NO;
}

-(BOOL)imageExistsForKey:(NSString *)key
{
    [NSException raise:@"Invoked abstract method." format:@"You must use a subclass implementation of %@.", NSStringFromClass(self.class)];
    return NO;
}

-(BOOL)putImage:(UIImage *)image
         forKey:(NSString *)key
{
    [NSException raise:@"Invoked abstract method." format:@"You must use a subclass implementation of %@.", NSStringFromClass(self.class)];
    return NO;
}

-(void)flushLocalImageData
{
    [NSException raise:@"Invoked abstract method." format:@"You must use a subclass implementation of %@.", NSStringFromClass(self.class)];
}

+(UIImage *)defaultImage
{
    [NSException raise:@"Invoked abstract method." format:@"You must use a subclass implementation of %@.", NSStringFromClass(self.class)];
    return nil;
}

@end
