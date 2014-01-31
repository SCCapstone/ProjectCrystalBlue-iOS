//
//  ChildSampleStore.h
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 1/19/14.
//  Copyright (c) 2014 Logan Hood. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Sample.h"

@interface SampleStore : NSObject
{
    NSMutableArray *allSamples;
}

+ (SampleStore *) sharedStore;

- (NSMutableArray *) allSamples;

@end
