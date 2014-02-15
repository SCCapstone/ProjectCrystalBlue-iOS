//
//  Source.m
//  ProjectCrystalBlue-iOS
//
//  Created by Justin Baumgartner on 1/18/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "Source.h"
#import "DDLog.h"

#ifdef DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@implementation Source

- (id)initWithKey:(NSString *)key
    AndWithValues:(NSArray *)attributeValues
{
    return [super initWithKey:key
            AndWithAttributes:[SourceConstants attributeNames]
                    AndValues:attributeValues];
}

- (NSString *)description
{
    //NSString *descriptionString = [[NSString alloc] initWithFormat:@"Source: %@", [[self attributes] objectForKey:@"Group"]];
    NSString *descriptionString = [[NSString alloc] initWithFormat:@"Source: %@", [self key]];
    return descriptionString;
}

@end
