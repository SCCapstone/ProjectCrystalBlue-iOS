//
//  Procedures.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 2/16/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "Procedures.h"
#import "ProcedureNameConstants.h"
#import "SampleConstants.h"
#import "PrimitiveProcedures.h"
#import "DDLog.h"

#ifdef DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_WARN;
#endif

@implementation Procedures

/**
 Procedures that append to a clone of a tag only
 **/

+ (void)makeSlabfromSample:(Sample *)sample
        withInitials:(NSString *)initials
            inStore:(AbstractLibraryObjectStore *)store
{
    DDLogDebug(@"%s", __func__);
    [PrimitiveProcedures appendToCloneOfSample:sample
                                     tagString:PROC_TAG_SLAB
                                  withInitials:initials
                                     intoStore:store
                                intoTableNamed:[SampleConstants tableName]];
}

+ (void)makeBilletfromSample:(Sample *)sample
              withInitials:(NSString *)initials
                   inStore:(AbstractLibraryObjectStore *)store
{
    DDLogDebug(@"%s", __func__);
    [PrimitiveProcedures appendToCloneOfSample:sample
                                     tagString:PROC_TAG_BILLET
                                  withInitials:initials
                                     intoStore:store
                                intoTableNamed:[SampleConstants tableName]];
}

+ (void)makeThinSectionfromSample:(Sample *)sample
              withInitials:(NSString *)initials
                   inStore:(AbstractLibraryObjectStore *)store
{
    DDLogDebug(@"%s", __func__);
    [PrimitiveProcedures appendToCloneOfSample:sample
                                     tagString:PROC_TAG_THIN_SECTION
                                  withInitials:initials
                                     intoStore:store
                                intoTableNamed:[SampleConstants tableName]];
}


/**
 Procedures that only modify the original sample
 **/


+ (void)jawCrushSample:(Sample *)sample
          withInitials:(NSString *)initials
               inStore:(AbstractLibraryObjectStore *)store
{
    DDLogDebug(@"%s", __func__);
    [PrimitiveProcedures appendToSampleInPlace:sample
                                     tagString:PROC_TAG_JAWCRUSH
                                  withInitials:initials
                                     intoStore:store
                                intoTableNamed:[SampleConstants tableName]];
}

+ (void)pulverizeSample:(Sample *)sample
           withInitials:(NSString *)initials
                inStore:(AbstractLibraryObjectStore *)store
{
    DDLogDebug(@"%s", __func__);
    [PrimitiveProcedures appendToSampleInPlace:sample
                                     tagString:PROC_TAG_PULVERIZE
                                  withInitials:initials
                                     intoStore:store
                                intoTableNamed:[SampleConstants tableName]];
}

+ (void)trimSample:(Sample *)sample
           withInitials:(NSString *)initials
                inStore:(AbstractLibraryObjectStore *)store
{
    DDLogDebug(@"%s", __func__);
    [PrimitiveProcedures appendToSampleInPlace:sample
                                     tagString:PROC_TAG_TRIM
                                  withInitials:initials
                                     intoStore:store
                                intoTableNamed:[SampleConstants tableName]];
}

/**
    Functions that are up/down. For up procedures the current sample gets the down and a new sample
    is created with the up. For down procedures the current sample gets the up and a new sample is created with the down
 **/

+ (void)gemeniUpSample:(Sample *)sample
       withInitials:(NSString *)initials
            inStore:(AbstractLibraryObjectStore *)store
{
    DDLogDebug(@"%s", __func__);
    [PrimitiveProcedures appendToCloneOfSample:sample
                                     tagString:PROC_TAG_GEMINI_UP
                                  withInitials:initials
                                     intoStore:store
                                intoTableNamed:[SampleConstants tableName]];
    
    [PrimitiveProcedures appendToSampleInPlace:sample
                                     tagString:PROC_TAG_GEMINI_DOWN
                                  withInitials:initials
                                     intoStore:store
                                intoTableNamed:[SampleConstants tableName]];
}

+ (void)geminiDownSample:(Sample *)sample
         withInitials:(NSString *)initials
              inStore:(AbstractLibraryObjectStore *)store
{
    DDLogDebug(@"%s", __func__);
    [PrimitiveProcedures appendToCloneOfSample:sample
                                     tagString:PROC_TAG_GEMINI_DOWN
                                  withInitials:initials
                                     intoStore:store
                                intoTableNamed:[SampleConstants tableName]];
    
    [PrimitiveProcedures appendToSampleInPlace:sample
                                     tagString:PROC_TAG_GEMINI_UP
                                  withInitials:initials
                                     intoStore:store
                                intoTableNamed:[SampleConstants tableName]];
}




+ (void)panUpSample:(Sample *)sample
       withInitials:(NSString *)initials
            inStore:(AbstractLibraryObjectStore *)store
{
    DDLogDebug(@"%s", __func__);
    [PrimitiveProcedures appendToCloneOfSample:sample
                                     tagString:PROC_TAG_PAN_UP
                                  withInitials:initials
                                     intoStore:store
                                intoTableNamed:[SampleConstants tableName]];
    
    [PrimitiveProcedures appendToSampleInPlace:sample
                                     tagString:PROC_TAG_PAN_DOWN
                                  withInitials:initials
                                     intoStore:store
                                intoTableNamed:[SampleConstants tableName]];
}

+ (void)panDownSample:(Sample *)sample
       withInitials:(NSString *)initials
            inStore:(AbstractLibraryObjectStore *)store
{
    DDLogDebug(@"%s", __func__);
    [PrimitiveProcedures appendToCloneOfSample:sample
                                     tagString:PROC_TAG_PAN_DOWN
                                  withInitials:initials
                                     intoStore:store
                                intoTableNamed:[SampleConstants tableName]];
    
    [PrimitiveProcedures appendToSampleInPlace:sample
                                     tagString:PROC_TAG_PAN_UP
                                  withInitials:initials
                                     intoStore:store
                                intoTableNamed:[SampleConstants tableName]];
}



+ (void)sievesTenUpSample:(Sample *)sample
       withInitials:(NSString *)initials
            inStore:(AbstractLibraryObjectStore *)store
{
    DDLogDebug(@"%s", __func__);
    [PrimitiveProcedures appendToCloneOfSample:sample
                                     tagString:PROC_TAG_SIEVE_10_UP
                                  withInitials:initials
                                     intoStore:store
                                intoTableNamed:[SampleConstants tableName]];
    
    [PrimitiveProcedures appendToSampleInPlace:sample
                                     tagString:PROC_TAG_SIEVE_10_DOWN
                                  withInitials:initials
                                     intoStore:store
                                intoTableNamed:[SampleConstants tableName]];
}

+ (void)sievesTenDownSample:(Sample *)sample
         withInitials:(NSString *)initials
              inStore:(AbstractLibraryObjectStore *)store
{
    DDLogDebug(@"%s", __func__);
    [PrimitiveProcedures appendToCloneOfSample:sample
                                     tagString:PROC_TAG_SIEVE_10_DOWN
                                  withInitials:initials
                                     intoStore:store
                                intoTableNamed:[SampleConstants tableName]];
    
    [PrimitiveProcedures appendToSampleInPlace:sample
                                     tagString:PROC_TAG_SIEVE_10_UP
                                  withInitials:initials
                                     intoStore:store
                                intoTableNamed:[SampleConstants tableName]];
}


/** specifically the heavy liquid up/down methods **/

+ (void)heavyLiquid_330_UpSample:(Sample *)sample
       withInitials:(NSString *)initials
            inStore:(AbstractLibraryObjectStore *)store
{
    DDLogDebug(@"%s", __func__);
    [PrimitiveProcedures appendToCloneOfSample:sample
                                     tagString:PROC_TAG_HEAVY_LIQUID_330_UP
                                  withInitials:initials
                                     intoStore:store
                                intoTableNamed:[SampleConstants tableName]];
    
    [PrimitiveProcedures appendToSampleInPlace:sample
                                     tagString:PROC_TAG_HEAVY_LIQUID_330_DOWN
                                  withInitials:initials
                                     intoStore:store
                                intoTableNamed:[SampleConstants tableName]];
}

+ (void)heavyLiquid_330_DownSample:(Sample *)sample
         withInitials:(NSString *)initials
              inStore:(AbstractLibraryObjectStore *)store
{
    DDLogDebug(@"%s", __func__);
    [PrimitiveProcedures appendToCloneOfSample:sample
                                     tagString:PROC_TAG_HEAVY_LIQUID_330_DOWN
                                  withInitials:initials
                                     intoStore:store
                                intoTableNamed:[SampleConstants tableName]];
    
    [PrimitiveProcedures appendToSampleInPlace:sample
                                     tagString:PROC_TAG_HEAVY_LIQUID_330_UP
                                  withInitials:initials
                                     intoStore:store
                                intoTableNamed:[SampleConstants tableName]];
}

+ (void)heavyLiquid_290_UpSample:(Sample *)sample
                    withInitials:(NSString *)initials
                         inStore:(AbstractLibraryObjectStore *)store
{
    DDLogDebug(@"%s", __func__);
    [PrimitiveProcedures appendToCloneOfSample:sample
                                     tagString:PROC_TAG_HEAVY_LIQUID_290_UP
                                  withInitials:initials
                                     intoStore:store
                                intoTableNamed:[SampleConstants tableName]];
    
    [PrimitiveProcedures appendToSampleInPlace:sample
                                     tagString:PROC_TAG_HEAVY_LIQUID_290_DOWN
                                  withInitials:initials
                                     intoStore:store
                                intoTableNamed:[SampleConstants tableName]];
}

+ (void)heavyLiquid_290_DownSample:(Sample *)sample
                      withInitials:(NSString *)initials
                           inStore:(AbstractLibraryObjectStore *)store
{
    DDLogDebug(@"%s", __func__);
    [PrimitiveProcedures appendToCloneOfSample:sample
                                     tagString:PROC_TAG_HEAVY_LIQUID_290_DOWN
                                  withInitials:initials
                                     intoStore:store
                                intoTableNamed:[SampleConstants tableName]];
    
    [PrimitiveProcedures appendToSampleInPlace:sample
                                     tagString:PROC_TAG_HEAVY_LIQUID_290_UP
                                  withInitials:initials
                                     intoStore:store
                                intoTableNamed:[SampleConstants tableName]];
}

+ (void)heavyLiquid_265_UpSample:(Sample *)sample
                    withInitials:(NSString *)initials
                         inStore:(AbstractLibraryObjectStore *)store
{
    DDLogDebug(@"%s", __func__);
    [PrimitiveProcedures appendToCloneOfSample:sample
                                     tagString:PROC_TAG_HEAVY_LIQUID_265_UP
                                  withInitials:initials
                                     intoStore:store
                                intoTableNamed:[SampleConstants tableName]];
    
    [PrimitiveProcedures appendToSampleInPlace:sample
                                     tagString:PROC_TAG_HEAVY_LIQUID_265_DOWN
                                  withInitials:initials
                                     intoStore:store
                                intoTableNamed:[SampleConstants tableName]];
}

+ (void)heavyLiquid_265_DownSample:(Sample *)sample
                      withInitials:(NSString *)initials
                           inStore:(AbstractLibraryObjectStore *)store
{
    DDLogDebug(@"%s", __func__);
    [PrimitiveProcedures appendToCloneOfSample:sample
                                     tagString:PROC_TAG_HEAVY_LIQUID_265_DOWN
                                  withInitials:initials
                                     intoStore:store
                                intoTableNamed:[SampleConstants tableName]];
    
    [PrimitiveProcedures appendToSampleInPlace:sample
                                     tagString:PROC_TAG_HEAVY_LIQUID_265_UP
                                  withInitials:initials
                                     intoStore:store
                                intoTableNamed:[SampleConstants tableName]];
}

+ (void)heavyLiquid_255_UpSample:(Sample *)sample
                    withInitials:(NSString *)initials
                         inStore:(AbstractLibraryObjectStore *)store
{
    DDLogDebug(@"%s", __func__);
    [PrimitiveProcedures appendToCloneOfSample:sample
                                     tagString:PROC_TAG_HEAVY_LIQUID_255_UP
                                  withInitials:initials
                                     intoStore:store
                                intoTableNamed:[SampleConstants tableName]];
    
    [PrimitiveProcedures appendToSampleInPlace:sample
                                     tagString:PROC_TAG_HEAVY_LIQUID_255_DOWN
                                  withInitials:initials
                                     intoStore:store
                                intoTableNamed:[SampleConstants tableName]];
}

+ (void)heavyLiquid_255_DownSample:(Sample *)sample
                      withInitials:(NSString *)initials
                           inStore:(AbstractLibraryObjectStore *)store
{
    DDLogDebug(@"%s", __func__);
    [PrimitiveProcedures appendToCloneOfSample:sample
                                     tagString:PROC_TAG_HEAVY_LIQUID_255_DOWN
                                  withInitials:initials
                                     intoStore:store
                                intoTableNamed:[SampleConstants tableName]];
    
    [PrimitiveProcedures appendToSampleInPlace:sample
                                     tagString:PROC_TAG_HEAVY_LIQUID_255_UP
                                  withInitials:initials
                                     intoStore:store
                                intoTableNamed:[SampleConstants tableName]];
}

+ (void)handMagnetUpSample:(Sample *)sample
                    withInitials:(NSString *)initials
                         inStore:(AbstractLibraryObjectStore *)store
{
    DDLogDebug(@"%s", __func__);
    [PrimitiveProcedures appendToCloneOfSample:sample
                                     tagString:PROC_TAG_HAND_MAGNET_UP
                                  withInitials:initials
                                     intoStore:store
                                intoTableNamed:[SampleConstants tableName]];
    
    [PrimitiveProcedures appendToSampleInPlace:sample
                                     tagString:PROC_TAG_HAND_MAGNET_DOWN
                                  withInitials:initials
                                     intoStore:store
                                intoTableNamed:[SampleConstants tableName]];
}

+ (void)handMagnetDownSample:(Sample *)sample
                      withInitials:(NSString *)initials
                           inStore:(AbstractLibraryObjectStore *)store
{
    DDLogDebug(@"%s", __func__);
    [PrimitiveProcedures appendToCloneOfSample:sample
                                     tagString:PROC_TAG_HAND_MAGNET_DOWN
                                  withInitials:initials
                                     intoStore:store
                                intoTableNamed:[SampleConstants tableName]];
    
    [PrimitiveProcedures appendToSampleInPlace:sample
                                     tagString:PROC_TAG_HAND_MAGNET_UP
                                  withInitials:initials
                                     intoStore:store
                                intoTableNamed:[SampleConstants tableName]];
}


/**
 Customized Tag method
 **/

+ (void)addCustomTagToSample:(Sample *)sample
                         tag:(NSString *)tag
                withInitials:(NSString *)initials
                     inStore:(AbstractLibraryObjectStore *)store
{
    DDLogDebug(@"%s", __func__);
    [PrimitiveProcedures appendToCloneOfSample:sample
                                     tagString:tag
                                  withInitials:initials
                                     intoStore:store
                                intoTableNamed:[SampleConstants tableName]];
}

@end
