//
//  Source.m
//  ProjectCrystalBlue-iOS
//
//  Created by Justin Baumgartner on 1/18/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "Source.h"
#import "SourceConstants.h"
#import "DDLog.h"

#ifdef DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@implementation Source

- (NSString *)description
{
    //NSString *descriptionString = [[NSString alloc] initWithFormat:@"Source: %@", [[self attributes] objectForKey:@"Group"]];
    NSString *descriptionString = [[NSString alloc] initWithFormat:@"Source: %@", [self key]];
    return descriptionString;
}

@end
