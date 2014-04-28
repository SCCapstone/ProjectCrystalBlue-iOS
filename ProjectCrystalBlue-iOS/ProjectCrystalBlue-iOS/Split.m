//
//  Split.m
//  ProjectCrystalBlue-iOS
//
//  Created by Justin Baumgartner on 1/18/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "Split.h"
#import "ValidationResponse.h"
#import "SplitFieldValidator.h"
#import "ProcedureRecordParser.h"
#import "PCBLogWrapper.h"

@implementation Split
{
    NSArray *tags;
}

- (id)initWithKey:(NSString *)key
    AndWithValues:(NSArray *)attributeValues
{
    return [super initWithKey:key
            AndWithAttributes:[SplitConstants attributeNames]
                    AndValues:attributeValues];
}

- (NSString *)sampleKey
{
    return [[self attributes] objectForKey:SPL_SAMPLE_KEY];
}

- (NSString *)description
{
    NSString *descriptionString = [[NSString alloc] initWithFormat:@"%@    ", [self key]];
    NSString *procedureRecords = [[self attributes] objectForKey:SPL_TAGS];
    NSArray *procedureTags = [ProcedureRecordParser tagArrayFromRecordList:procedureRecords];
    
    if ([procedureTags count] == 0)
    {
        descriptionString = [descriptionString stringByAppendingString:@"(None)"];

    }
    for(int i = [procedureTags count] - 1; i >= 0; i--)
    {
        if(i == [procedureTags count]-1)
        {
            descriptionString = [descriptionString stringByAppendingString:@"("];
        }
        descriptionString = [descriptionString stringByAppendingString:[procedureTags objectAtIndex:i]];
        if(i != 0)
        {
            descriptionString = [descriptionString stringByAppendingString:@", "];
        }
        else
        {
            descriptionString = [descriptionString stringByAppendingString:@")"];
        }
    }
    return descriptionString;
}

/// This method is called automatically via data binding. Should not manually call this method.
- (BOOL)validateValue:(inout __autoreleasing id *)ioValue forKeyPath:(NSString *)inKeyPath error:(out NSError *__autoreleasing *)outError
{
    NSString *newValue = (NSString *)*ioValue;
    ValidationResponse *response;
    NSString *attr = [inKeyPath isEqualToString:@"key"] ? @"key" : [inKeyPath substringFromIndex:11];
    
    // Validate depending on attribute
    if ([attr isEqualToString:SPL_CURRENT_LOCATION])
        response = [SplitFieldValidator validateCurrentLocation:newValue];
    else
        return YES;
    
    if (response.isValid)
        return YES;
    
    NSString *errorString = NSLocalizedString([response.errors componentsJoinedByString:@"\n"], @"Validation: Invalid value");
    NSDictionary *userInfoDict = @{ NSLocalizedDescriptionKey: errorString };
    *outError = [[NSError alloc] initWithDomain:@"Error domain" code:0 userInfo:userInfoDict];
    return NO;
}

@end
