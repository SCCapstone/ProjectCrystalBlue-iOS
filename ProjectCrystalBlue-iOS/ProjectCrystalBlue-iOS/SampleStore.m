//
//  ChildSampleStore.m
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 1/19/14.
//  Copyright (c) 2014 Logan Hood. All rights reserved.
//

#import "SampleStore.h"
#import "SampleConstants.h"
#import "DDLog.h"
#import "Sample.h"

#ifdef DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@implementation SampleStore
@synthesize clickedSource;

- (id)init
{
    self = [super init];
    if (self)
    {
        allSamples = [[NSMutableArray alloc] init];
    }
    return self;
}

+ (id)allocWithZone:(NSZone *)zone
{
    return [self sharedStore];
}

+ (SampleStore *)sharedStore
{
    static SampleStore *sharedStore = nil;
    if (!sharedStore)
        sharedStore = [[super allocWithZone:nil] init];
    
    return sharedStore;
}

- (NSArray *)allSamples
{
    return allSamples;
}

- (Sample *)createSampleWithKey:(NSString *)inKey  {
    Sample *p = [[Sample alloc] initWithKey:inKey
                          AndWithAttributes:[SampleConstants attributeNames]
                       AndWithDefaultValues:[SampleConstants attributeDefaultValues]];
    [allSamples addObject:p];
    return p;
}


- (void)removeSample:(Sample *)p {
    [allSamples removeObjectIdenticalTo:p];
}

- (void)moveItemAtIndex:(int)from
                toIndex:(int)to
{
    if (from == to) {
        return;
    }
    Sample *p = [allSamples objectAtIndex:from];
    [allSamples removeObjectAtIndex:from];
    [allSamples insertObject:p atIndex:to]; }



@end
