//
//  Sample.h
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 12/4/13.
//  Copyright (c) 2013 Project Crystal Blue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Sample : NSObject


@property(nonatomic) NSString* rockType;
@property(nonatomic) NSString* rockId;
@property(nonatomic) NSString* coordinates;
@property(nonatomic) bool isPulverized;

-(id) initWithRockType:(NSString*)rockType
             AndRockId:(NSString*)rockId
        AndCoordinates:(NSString*)coordinates
       AndIsPulverized:(bool)isPulverized;

-(id) initWithSample:(Sample*)sample;

@end