//
//  Sample.m
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 12/4/13.
//  Copyright (c) 2013 Project Crystal Blue. All rights reserved.
//

#import "Sample.h"

@implementation Sample

@synthesize name = _name;
@synthesize pulverized = _pulverized;

-(id)initWithName:(NSString *)name pulverized:(BOOL)pulverized{
    self = [super init];
    if(self){
        self.name = name;
        self.pulverized = pulverized;
    }
    return self;
}

@end

