//
//  ChildSampleStore.h
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 1/19/14.
//  Copyright (c) 2014 Logan Hood. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Sample;

@interface SampleStore : NSObject
{
    NSMutableArray *allSamples;
}

+ (SampleStore *) sharedStore;

- (NSMutableArray *) allSamples;
- (Sample *)createSampleWithKey:(NSString*)inKey;
- (void)removeSample:(Sample *)p;
- (void)moveItemAtIndex:(int)from
                toIndex:(int)to;
@end
