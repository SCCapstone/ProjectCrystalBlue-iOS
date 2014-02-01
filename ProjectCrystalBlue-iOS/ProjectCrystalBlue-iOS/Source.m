//
//  Source.m
//  ProjectCrystalBlue-iOS
//
//  Created by Justin Baumgartner on 1/18/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "Source.h"
#import "SourceConstants.h"

@implementation Source

- (NSString *)description
{
    NSString *descriptionString = [[NSString alloc] initWithFormat:@"Source: %@", [[self attributes] objectForKey:@"Continent"]];
    return descriptionString;
}

@end
