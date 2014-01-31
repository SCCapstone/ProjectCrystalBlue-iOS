//
//  OriginalSampleStore.m
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 1/19/14.
//  Copyright (c) 2014 Logan Hood. All rights reserved.
//

#import "SourceStore.h"
#import "Source.h"
#import "SourceConstants.h"

@implementation SourceStore

- (id)init
{
    self = [super init];
    if (self)
    {
        allSources = [[NSMutableArray alloc] init];
    }
    return self;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedStore];
}

+ (SourceStore *)sharedStore
{
    static SourceStore *sharedStore = nil;
    if (!sharedStore)
        sharedStore = [[super allocWithZone:nil] init];
    
    return sharedStore;
}

- (NSArray *)allSources
{
    return allSources;
}

- (Source *)createSource {
    Source *p = [[Source alloc] init];
    [allSources addObject:p];
    return p;
}

@end
