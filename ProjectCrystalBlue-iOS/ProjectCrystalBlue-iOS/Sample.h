//
//  Sample.h
//  ProjectCrystalBlue-iOS
//
//  Created by Ryan McGraw on 12/4/13.
//  Copyright (c) 2013 Project Crystal Blue. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Sample : NSObject

@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) BOOL pulverized;

- (id)initWithName:(NSString *)name pulverized:(BOOL)pulverized;

@end
