//
//  OriginalSampleStore.h
//  ProjectCrystalBlueOSX
//
//  Created by Justin Baumgartner on 1/19/14.
//  Copyright (c) 2014 Logan Hood. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Source;

@interface SourceStore : NSObject
{
    NSMutableArray *allSources;
}

+ (SourceStore *)sharedStore;

- (NSMutableArray *)allSources;
- (Source *)createSourceWithKey:(NSString*)inKey;
- (void)removeSource:(Source *)p;
- (void)moveItemAtIndex:(int)from
                toIndex:(int)to;

@end
