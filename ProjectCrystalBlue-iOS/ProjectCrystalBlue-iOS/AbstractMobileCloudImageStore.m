//
//  AbstractMobileCloudImageStore.m
//  ProjectCrystalBlue-iOS
//
//  Created by Logan Hood on 2/14/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "AbstractMobileCloudImageStore.h"

@implementation AbstractMobileCloudImageStore

-(id)initWithLocalDirectory:(NSString *)directory
{
    return [super initWithLocalDirectory:directory];
}

-(BOOL)synchronizeWithCloud
{
    [NSException raise:@"Invoked abstract method." format:@"You must use a subclass implementation of %@.", NSStringFromClass(self.class)];
    return NO;
}

-(BOOL)keyIsDirty:(NSString *)key
{
    [NSException raise:@"Invoked abstract method." format:@"You must use a subclass implementation of %@.",
        NSStringFromClass(self.class)];
    return NO;
}

@end
