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

/* Source table name
 */
#ifdef DEBUG
static NSString *const SOURCE_TABLE_NAME = @"test_source_table";
#else
static NSString *const SOURCE_TABLE_NAME = @"prod_source_table";
#endif

@implementation SourceConstants

+ (NSArray *)attributeNames
{
    static NSArray *attributeNames = nil;
    if (!attributeNames)
    {
        attributeNames = [NSArray arrayWithObjects:
                          SRC_KEY,
                          SRC_CONTINENT,
                          SRC_TYPE,
                          SRC_LITHOLOGY,
                          SRC_DEPOSYSTEM,
                          SRC_GROUP,
                          SRC_FORMATION,
                          SRC_MEMBER,
                          SRC_REGION,
                          SRC_LOCALITY,
                          SRC_SECTION,
                          SRC_METER,
                          SRC_LATITUDE,
                          SRC_LONGITUDE,
                          SRC_AGE,
                          SRC_AGE_METHOD,
                          SRC_AGE_DATATYPE,
                          SRC_DATE_COLLECTED,
                          SRC_NOTES,
                          SRC_HYPERLINKS, nil];
    }
    
    return attributeNames;
}

+ (NSArray *)attributeDefaultValues
{
    static NSArray *attributeDefaultValues = nil;
    if (!attributeDefaultValues)
    {
        attributeDefaultValues = [NSArray arrayWithObjects:
                                  SRC_DEF_VAL_KEY,
                                  SRC_DEF_VAL_CONTINENT,
                                  SRC_DEF_VAL_TYPE,
                                  SRC_DEF_VAL_LITHOLOGY,
                                  SRC_DEF_VAL_DEPOSYSTEM,
                                  SRC_DEF_VAL_GROUP,
                                  SRC_DEF_VAL_FORMATION,
                                  SRC_DEF_VAL_MEMBER,
                                  SRC_DEF_VAL_REGION,
                                  SRC_DEF_VAL_LOCALITY,
                                  SRC_DEF_VAL_SECTION,
                                  SRC_DEF_VAL_METER,
                                  SRC_DEF_VAL_LATITUDE,
                                  SRC_DEF_VAL_LONGITUDE,
                                  SRC_DEF_VAL_AGE,
                                  SRC_DEF_VAL_AGE_METHOD,
                                  SRC_DEF_VAL_AGE_DATATYPE,
                                  SRC_DEF_VAL_DATE_COLLECTED,
                                  SRC_DEF_VAL_NOTES,
                                  SRC_DEF_VAL_HYPERLINKS, nil];
    }
    return attributeDefaultValues;
}

+ (NSArray *)humanReadableLabels
{
    static NSArray *attributeLabelValues = nil;
    if (!attributeLabelValues)
    {
        attributeLabelValues = [NSArray arrayWithObjects:
                                SRC_DISPLAY_KEY,
                                SRC_DISPLAY_CONTINENT,
                                SRC_DISPLAY_TYPE,
                                SRC_DISPLAY_LITHOLOGY,
                                SRC_DISPLAY_DEPOSYSTEM,
                                SRC_DISPLAY_GROUP,
                                SRC_DISPLAY_FORMATION,
                                SRC_DISPLAY_MEMBER,
                                SRC_DISPLAY_REGION,
                                SRC_DISPLAY_LOCALITY,
                                SRC_DISPLAY_SECTION,
                                SRC_DISPLAY_METER,
                                SRC_DISPLAY_LATITUDE,
                                SRC_DISPLAY_LONGITUDE,
                                SRC_DISPLAY_AGE,
                                SRC_DISPLAY_AGE_METHOD,
                                SRC_DISPLAY_AGE_DATATYPE,
                                SRC_DISPLAY_DATE_COLLECTED,
                                SRC_DISPLAY_NOTES,
                                SRC_DISPLAY_HYPERLINKS, nil];
    }
    return attributeLabelValues;
}

+ (NSString *)humanReadableLabelForAttribute:(NSString *)attributeName
{
    NSUInteger index = [[self.class attributeNames] indexOfObject:attributeName];
    if (index == NSNotFound) {
        DDLogWarn(@"%@: %@ attribute is unknown.", NSStringFromClass(self.class), attributeName);
        return attributeName;
    }
    
    return [[self.class humanReadableLabels] objectAtIndex:index];
}

+ (NSString *)attributeNameForHumanReadableLabel:(NSString *)label
{
    NSUInteger index = [[self.class humanReadableLabels] indexOfObject:label];
    if (index == NSNotFound) {
        DDLogWarn(@"%@: %@ attribute is unknown.", NSStringFromClass(self.class), label);
        return label;
    }
    
    return [[self.class attributeNames] objectAtIndex:index];
}

+ (NSString *)tableName
{
    return SOURCE_TABLE_NAME;
}

+ (NSString *)tableSchema
{
    static NSString *schema = nil;
    if (!schema)
    {
        NSMutableArray *attrNames = [[self attributeNames] mutableCopy];
        
        // Append column info to each attribute name
        for (int i=0; i<[attrNames count];  i++)
        {
            NSString *attr = [attrNames objectAtIndex:i];
            [attrNames replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@"%@ TEXT%@",
                                                          attr, [attr isEqualToString:SRC_KEY] ? @" PRIMARY KEY" : @""]];
        }
        schema = [attrNames componentsJoinedByString:@","];
    }
    return schema;
}

+ (NSString *)tableColumns
{
    static NSString *columns = nil;
    if (!columns)
    {
        columns = [[self attributeNames] componentsJoinedByString:@","];
    }
    return columns;
}

+ (NSString *)tableValueKeys
{
    static NSString *valueKeys = nil;
    if (!valueKeys)
    {
        NSMutableArray *attrNames = [[self attributeNames] mutableCopy];
        
        // Prepend ':' to each attribute name
        for (int i=0; i<[attrNames count];  i++)
        {
            [attrNames replaceObjectAtIndex:i withObject:[NSString stringWithFormat:@":%@", [attrNames objectAtIndex:i]]];
        }
        valueKeys = [attrNames componentsJoinedByString:@","];
    }
    return valueKeys;
}

@end
