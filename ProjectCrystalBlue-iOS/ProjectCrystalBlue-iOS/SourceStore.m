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
    Source *p = [[Source alloc] initWithKey:@"key"
                         AndWithAttributes:[SourceConstants attributeNames]
                       AndWithDefaultValues:[SourceConstants attributeDefaultValues]];
    [allSources addObject:p];
    return p;
}


- (void)removeSource:(Source *)p {
    [allSources removeObjectIdenticalTo:p];
}

- (void)moveItemAtIndex:(int)from
                toIndex:(int)to
{
    if (from == to) {
        return;
    }
    Source *p = [allSources objectAtIndex:from];
    [allSources removeObjectAtIndex:from];
    [allSources insertObject:p atIndex:to]; }


@end
