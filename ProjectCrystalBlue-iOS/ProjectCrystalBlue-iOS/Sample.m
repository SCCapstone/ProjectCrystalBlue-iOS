//
//  Sample.m
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 12/4/13.
//  Copyright (c) 2013 Project Crystal Blue. All rights reserved.
//

#import "Sample.h"

@implementation Sample

@synthesize rockType = _rockType;
@synthesize rockId = _rockId;
@synthesize coordinates = _coordinates;
@synthesize isPulverized = _isPulverized;

-(id) initWithRockType:(NSString*)rockType
             AndRockId:(NSInteger)rockId
        AndCoordinates:(NSString*)coordinates
       AndIsPulverized:(bool)isPulverized
{
    self = [super init];
    if (self) {
        _rockType = rockType;
        _rockId = rockId;
        _coordinates = coordinates;
        _isPulverized = isPulverized;
    }
    return self;
}

-(id) initWithSample:(Sample*)sample {
    self = [self initWithRockType:sample.rockType
                        AndRockId:sample.rockId
                   AndCoordinates:sample.coordinates
                  AndIsPulverized:sample.isPulverized];
    return self;
}


@end

