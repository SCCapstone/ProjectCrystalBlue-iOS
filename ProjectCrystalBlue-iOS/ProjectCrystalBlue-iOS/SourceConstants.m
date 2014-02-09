//
//  SourceConstants.m
//  ProjectCrystalBlue-iOS
//
//  Created by Justin Baumgartner on 1/18/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "SourceConstants.h"
#import "DDLog.h"

#ifdef DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

/* Attribute names
 */
NSString *const CONTINENT = @"Continent";
NSString *const TYPE = @"Type";
NSString *const LITHOLOGY = @"Lithology";
NSString *const DEPOSYSTEM = @"Deposystem";
NSString *const GROUP = @"Group";
NSString *const FORMATION = @"Formation";
NSString *const MEMBER = @"Member";
NSString *const REGION = @"Region";
NSString *const LOCALITY = @"Locality";
NSString *const SECTION = @"Section";
NSString *const METER_LEVEL = @"Meter_Level";
NSString *const LATITUDE = @"Latitude";
NSString *const LONGITUDE = @"Longitude";
NSString *const AGE = @"Age";
NSString *const AGE_BASIS1 = @"Age_Basis1";
NSString *const AGE_BASIS2 = @"Age_Basis2";
NSString *const DATE_COLLECTED = @"Date_Collected";
NSString *const PROJECT = @"Project";
NSString *const SUBPROJECT = @"Subproject";

/* Attribute default values
 */
NSString *const DEF_VAL_CONTINENT = @"";
NSString *const DEF_VAL_TYPE = @"";
NSString *const DEF_VAL_LITHOLOGY = @"";
NSString *const DEF_VAL_DEPOSYSTEM = @"";
NSString *const DEF_VAL_GROUP = @"";
NSString *const DEF_VAL_FORMATION = @"";
NSString *const DEF_VAL_MEMBER = @"";
NSString *const DEF_VAL_REGION = @"";
NSString *const DEF_VAL_LOCALITY = @"";
NSString *const DEF_VAL_SECTION = @"";
NSString *const DEF_VAL_METER_LEVEL = @"";
NSString *const DEF_VAL_LATITUDE = @"";
NSString *const DEF_VAL_LONGITUDE = @"";
NSString *const DEF_VAL_AGE = @"";
NSString *const DEF_VAL_AGE_BASIS1 = @"";
NSString *const DEF_VAL_AGE_BASIS2 = @"";
NSString *const DEF_VAL_DATE_COLLECTED = @"";
NSString *const DEF_VAL_PROJECT = @"";
NSString *const DEF_VAL_SUBPROJECT = @"";

@implementation SourceConstants

+ (NSArray *)attributeNames
{
    static NSArray *attributeNames = nil;
    if (!attributeNames)
    {
        
        attributeNames = [NSArray arrayWithObjects:CONTINENT, TYPE, LITHOLOGY, DEPOSYSTEM, GROUP, FORMATION, MEMBER, REGION, LOCALITY, SECTION, METER_LEVEL, LATITUDE, LONGITUDE, AGE, AGE_BASIS1, AGE_BASIS2, DATE_COLLECTED, PROJECT, SUBPROJECT, nil];
    }
    
    return attributeNames;
}

+ (NSArray *)attributeDefaultValues
{
    static NSArray *attributeDefaultValues = nil;
    if (!attributeDefaultValues)
    {
        attributeDefaultValues = [NSArray arrayWithObjects:
                          DEF_VAL_CONTINENT, DEF_VAL_TYPE, DEF_VAL_LITHOLOGY, DEF_VAL_DEPOSYSTEM, DEF_VAL_GROUP, DEF_VAL_FORMATION, DEF_VAL_MEMBER, DEF_VAL_REGION, DEF_VAL_LOCALITY, DEF_VAL_SECTION, DEF_VAL_METER_LEVEL, DEF_VAL_LATITUDE, DEF_VAL_LONGITUDE, DEF_VAL_AGE, DEF_VAL_AGE_BASIS1, DEF_VAL_AGE_BASIS2, DEF_VAL_DATE_COLLECTED, DEF_VAL_PROJECT, DEF_VAL_SUBPROJECT, nil];
    }
    return attributeDefaultValues;
}

@end
