//
//  ProceduresTests.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 2/16/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Procedures.h"
#import "ProcedureNameConstants.h"
#import "ProcedureRecordParser.h"
#import "ProcedureRecord.h"
#import "AbstractLibraryObjectStore.h"
#import "LocalLibraryObjectStore.h"

#define TEST_DIR @"pcb-procedures-tests"
#define DATABASE_NAME @"procedures-test-db"

@interface ProceduresTests : XCTestCase

@end

@implementation ProceduresTests

AbstractLibraryObjectStore *testStore;

- (void)setUp
{
    [super setUp];
    
    // Set up a test table
    testStore = [[LocalLibraryObjectStore alloc]
                 initInLocalDirectory:TEST_DIR
                 WithDatabaseName:DATABASE_NAME];
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
    
    // Remove test store
    NSError *error = nil;
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
    NSString *databasePath = [[documentsDirectory stringByAppendingPathComponent:TEST_DIR]
                              stringByAppendingPathComponent:DATABASE_NAME];
    [[NSFileManager defaultManager] removeItemAtPath:databasePath error:&error];
    XCTAssertNil(error, @"Error removing database file!");
}

- (void)testAddFreshSplit
{
    NSString *originalKey = @"Rock.001";
    Split *s = [[Split alloc] initWithKey:originalKey
                          AndWithAttributes:[SplitConstants attributeNames]
                                  AndValues:[SplitConstants attributeDefaultValues]];

    
    [Procedures addFreshSplit:s inStore:testStore];
    [Procedures addFreshSplit:s inStore:testStore];

    LibraryObject *split1 = [testStore getLibraryObjectForKey:@"Rock.002"
                                                     FromTable:[SplitConstants tableName]];
    LibraryObject *split2 = [testStore getLibraryObjectForKey:@"Rock.003"
                                                     FromTable:[SplitConstants tableName]];
    
    
    XCTAssertEqualObjects(s.key,         @"Rock.001");
    XCTAssertEqualObjects(split1.key,   @"Rock.002");
    XCTAssertEqualObjects(split2.key,   @"Rock.003");
}

- (void)testMoveSplit
{
    NSString *originalKey = @"Rock.001";
    Split *s = [[Split alloc] initWithKey:originalKey
                          AndWithAttributes:[SplitConstants attributeNames]
                                  AndValues:[SplitConstants attributeDefaultValues]];
    
    NSString *originalLocation = [[s attributes] objectForKey:SPL_CURRENT_LOCATION];
    
    [Procedures moveSplit:s toLocation:@"NewLocation" inStore:testStore];

    
    XCTAssertNotEqualObjects([[s attributes] objectForKey:SPL_CURRENT_LOCATION],    originalLocation);
    XCTAssertEqualObjects([[s attributes] objectForKey:SPL_CURRENT_LOCATION],    @"NewLocation");
}

- (void)testMakeSlab
{
    NSString *originalKey = @"Rock.001";
    NSString *initials = @"AAA";
    Split *s = [[Split alloc] initWithKey:originalKey
                          AndWithAttributes:[SplitConstants attributeNames]
                                  AndValues:[SplitConstants attributeDefaultValues]];
    
    ProcedureRecord *proc1 = [[ProcedureRecord alloc] initWithTag:@"TAG01" andInitials:initials];
    ProcedureRecord *proc2 = [[ProcedureRecord alloc] initWithTag:@"TAG02" andInitials:initials];
    
    NSString *originalRecords = [NSString stringWithFormat:@"%@%@%@", proc1, TAG_DELIMITER, proc2];
    
    NSArray *originalRecordArray = [ProcedureRecordParser procedureRecordArrayFromList:originalRecords];
    
    [s.attributes setValue:originalRecords forKey:SPL_TAGS];
    [testStore putLibraryObject:s IntoTable:[SplitConstants tableName]];
    
    [Procedures makeSlabfromSplit:s
                  withInitials:initials
                       inStore:testStore];
    
    NSString *newKey = @"Rock.002";
    
    LibraryObject *retrievedOriginalSplit = [testStore getLibraryObjectForKey:originalKey
                                                                FromTable:[SplitConstants tableName]];
    LibraryObject *retrievedNewSplit = [testStore getLibraryObjectForKey:newKey
                                                             FromTable:[SplitConstants tableName]];
    
    NSString *newOriginalRecords = [[retrievedOriginalSplit attributes] objectForKey:SPL_TAGS];
    NSString *newRecords = [[retrievedNewSplit attributes] objectForKey:SPL_TAGS];
    
    NSArray *postOriginalRecordArray = [ProcedureRecordParser procedureRecordArrayFromList:newOriginalRecords];
    NSArray *postNewRecordArray = [ProcedureRecordParser procedureRecordArrayFromList:newRecords];
    
    
    ProcedureRecord *expectedRecord = [[ProcedureRecord alloc] initWithTag:PROC_TAG_SLAB andInitials:initials];
    
    XCTAssertEqualObjects([originalRecordArray objectAtIndex:0],    [postOriginalRecordArray objectAtIndex:0]);
    XCTAssertEqualObjects([originalRecordArray objectAtIndex:1],    [postOriginalRecordArray objectAtIndex:1]);
    XCTAssertEqualObjects([originalRecordArray objectAtIndex:0],    [postNewRecordArray objectAtIndex:0]);
    XCTAssertEqualObjects([originalRecordArray objectAtIndex:1],    [postNewRecordArray objectAtIndex:1]);
    XCTAssertEqualObjects(expectedRecord,                           [postNewRecordArray objectAtIndex:2]);
}

- (void)testMakeBillet
{
    NSString *originalKey = @"Rock.001";
    NSString *initials = @"AAA";
    Split *s = [[Split alloc] initWithKey:originalKey
                          AndWithAttributes:[SplitConstants attributeNames]
                                  AndValues:[SplitConstants attributeDefaultValues]];
    
    ProcedureRecord *proc1 = [[ProcedureRecord alloc] initWithTag:@"TAG01" andInitials:initials];
    ProcedureRecord *proc2 = [[ProcedureRecord alloc] initWithTag:@"TAG02" andInitials:initials];
    
    NSString *originalRecords = [NSString stringWithFormat:@"%@%@%@", proc1, TAG_DELIMITER, proc2];
    
    NSArray *originalRecordArray = [ProcedureRecordParser procedureRecordArrayFromList:originalRecords];
    
    [s.attributes setValue:originalRecords forKey:SPL_TAGS];
    [testStore putLibraryObject:s IntoTable:[SplitConstants tableName]];
    
    [Procedures makeBilletfromSplit:s
                      withInitials:initials
                           inStore:testStore];
    
    NSString *newKey = @"Rock.002";
    
    LibraryObject *retrievedOriginalSplit = [testStore getLibraryObjectForKey:originalKey
                                                                     FromTable:[SplitConstants tableName]];
    LibraryObject *retrievedNewSplit = [testStore getLibraryObjectForKey:newKey
                                                                FromTable:[SplitConstants tableName]];
    
    NSString *newOriginalRecords = [[retrievedOriginalSplit attributes] objectForKey:SPL_TAGS];
    NSString *newRecords = [[retrievedNewSplit attributes] objectForKey:SPL_TAGS];
    
    NSArray *postOriginalRecordArray = [ProcedureRecordParser procedureRecordArrayFromList:newOriginalRecords];
    NSArray *postNewRecordArray = [ProcedureRecordParser procedureRecordArrayFromList:newRecords];
    
    
    ProcedureRecord *expectedRecord = [[ProcedureRecord alloc] initWithTag:PROC_TAG_BILLET andInitials:initials];
    
    XCTAssertEqualObjects([originalRecordArray objectAtIndex:0],    [postOriginalRecordArray objectAtIndex:0]);
    XCTAssertEqualObjects([originalRecordArray objectAtIndex:1],    [postOriginalRecordArray objectAtIndex:1]);
    XCTAssertEqualObjects([originalRecordArray objectAtIndex:0],    [postNewRecordArray objectAtIndex:0]);
    XCTAssertEqualObjects([originalRecordArray objectAtIndex:1],    [postNewRecordArray objectAtIndex:1]);
    XCTAssertEqualObjects(expectedRecord,                           [postNewRecordArray objectAtIndex:2]);
}

- (void)testThinSection
{
    NSString *originalKey = @"Rock.001";
    NSString *initials = @"AAA";
    Split *s = [[Split alloc] initWithKey:originalKey
                          AndWithAttributes:[SplitConstants attributeNames]
                                  AndValues:[SplitConstants attributeDefaultValues]];
    
    ProcedureRecord *proc1 = [[ProcedureRecord alloc] initWithTag:@"TAG01" andInitials:initials];
    ProcedureRecord *proc2 = [[ProcedureRecord alloc] initWithTag:@"TAG02" andInitials:initials];
    
    NSString *originalRecords = [NSString stringWithFormat:@"%@%@%@", proc1, TAG_DELIMITER, proc2];
    
    NSArray *originalRecordArray = [ProcedureRecordParser procedureRecordArrayFromList:originalRecords];
    
    [s.attributes setValue:originalRecords forKey:SPL_TAGS];
    [testStore putLibraryObject:s IntoTable:[SplitConstants tableName]];
    
    [Procedures makeThinSectionfromSplit:s
                      withInitials:initials
                           inStore:testStore];
    
    NSString *newKey = @"Rock.002";
    
    LibraryObject *retrievedOriginalSplit = [testStore getLibraryObjectForKey:originalKey
                                                                     FromTable:[SplitConstants tableName]];
    LibraryObject *retrievedNewSplit = [testStore getLibraryObjectForKey:newKey
                                                                FromTable:[SplitConstants tableName]];
    
    NSString *newOriginalRecords = [[retrievedOriginalSplit attributes] objectForKey:SPL_TAGS];
    NSString *newRecords = [[retrievedNewSplit attributes] objectForKey:SPL_TAGS];
    
    NSArray *postOriginalRecordArray = [ProcedureRecordParser procedureRecordArrayFromList:newOriginalRecords];
    NSArray *postNewRecordArray = [ProcedureRecordParser procedureRecordArrayFromList:newRecords];
    
    
    ProcedureRecord *expectedRecord = [[ProcedureRecord alloc] initWithTag:PROC_TAG_THIN_SECTION andInitials:initials];
    
    XCTAssertEqualObjects([originalRecordArray objectAtIndex:0],    [postOriginalRecordArray objectAtIndex:0]);
    XCTAssertEqualObjects([originalRecordArray objectAtIndex:1],    [postOriginalRecordArray objectAtIndex:1]);
    XCTAssertEqualObjects([originalRecordArray objectAtIndex:0],    [postNewRecordArray objectAtIndex:0]);
    XCTAssertEqualObjects([originalRecordArray objectAtIndex:1],    [postNewRecordArray objectAtIndex:1]);
    XCTAssertEqualObjects(expectedRecord,                           [postNewRecordArray objectAtIndex:2]);
}

- (void)testPulverize
{
    NSString *originalKey = @"Rock.001";
    NSString *initials = @"AAA";
    Split *s = [[Split alloc] initWithKey:originalKey
                          AndWithAttributes:[SplitConstants attributeNames]
                                  AndValues:[SplitConstants attributeDefaultValues]];
    
    ProcedureRecord *proc1 = [[ProcedureRecord alloc] initWithTag:@"TAG01" andInitials:initials];
    ProcedureRecord *proc2 = [[ProcedureRecord alloc] initWithTag:@"TAG02" andInitials:initials];
    
    NSString *originalRecords = [NSString stringWithFormat:@"%@%@%@", proc1, TAG_DELIMITER, proc2];
    
    NSArray *originalRecordArray = [ProcedureRecordParser procedureRecordArrayFromList:originalRecords];
    
    [s.attributes setValue:originalRecords forKey:SPL_TAGS];
    [testStore putLibraryObject:s IntoTable:[SplitConstants tableName]];
    
    [Procedures pulverizeSplit:s
                  withInitials:initials
                       inStore:testStore];
    
    LibraryObject *retrievedSplit = [testStore getLibraryObjectForKey:originalKey
                                                             FromTable:[SplitConstants tableName]];
    
    NSString *newRecords = [[retrievedSplit attributes] objectForKey:SPL_TAGS];
    NSArray *newRecordArray = [ProcedureRecordParser procedureRecordArrayFromList:newRecords];
    
    ProcedureRecord *expectedPulverizeRecord = [[ProcedureRecord alloc] initWithTag:PROC_TAG_PULVERIZE andInitials:initials];
    
    XCTAssertEqualObjects([originalRecordArray objectAtIndex:0],    [newRecordArray objectAtIndex:0]);
    XCTAssertEqualObjects([originalRecordArray objectAtIndex:1],    [newRecordArray objectAtIndex:1]);
    XCTAssertEqualObjects(expectedPulverizeRecord,                   [newRecordArray objectAtIndex:2]);
  
}

- (void)testTrim
{
    NSString *originalKey = @"Rock.001";
    NSString *initials = @"AAA";
    Split *s = [[Split alloc] initWithKey:originalKey
                          AndWithAttributes:[SplitConstants attributeNames]
                                  AndValues:[SplitConstants attributeDefaultValues]];
    
    ProcedureRecord *proc1 = [[ProcedureRecord alloc] initWithTag:@"TAG01" andInitials:initials];
    ProcedureRecord *proc2 = [[ProcedureRecord alloc] initWithTag:@"TAG02" andInitials:initials];
    
    NSString *originalRecords = [NSString stringWithFormat:@"%@%@%@", proc1, TAG_DELIMITER, proc2];
    
    NSArray *originalRecordArray = [ProcedureRecordParser procedureRecordArrayFromList:originalRecords];
    
    [s.attributes setValue:originalRecords forKey:SPL_TAGS];
    [testStore putLibraryObject:s IntoTable:[SplitConstants tableName]];
    
    [Procedures trimSplit:s
                   withInitials:initials
                        inStore:testStore];
    
    LibraryObject *retrievedSplit = [testStore getLibraryObjectForKey:originalKey
                                                             FromTable:[SplitConstants tableName]];
    
    NSString *newRecords = [[retrievedSplit attributes] objectForKey:SPL_TAGS];
    NSArray *newRecordArray = [ProcedureRecordParser procedureRecordArrayFromList:newRecords];
    
    ProcedureRecord *expectedRecord = [[ProcedureRecord alloc] initWithTag:PROC_TAG_TRIM andInitials:initials];
    
    XCTAssertEqualObjects([originalRecordArray objectAtIndex:0],    [newRecordArray objectAtIndex:0]);
    XCTAssertEqualObjects([originalRecordArray objectAtIndex:1],    [newRecordArray objectAtIndex:1]);
    XCTAssertEqualObjects(expectedRecord,                           [newRecordArray objectAtIndex:2]);
    
}

- (void)testGemini
{
    NSString *originalKey = @"Rock.001";
    NSString *initials = @"AAA";
    Split *s = [[Split alloc] initWithKey:originalKey
                          AndWithAttributes:[SplitConstants attributeNames]
                                  AndValues:[SplitConstants attributeDefaultValues]];
    
    ProcedureRecord *proc1 = [[ProcedureRecord alloc] initWithTag:@"TAG01" andInitials:initials];
    ProcedureRecord *proc2 = [[ProcedureRecord alloc] initWithTag:@"TAG02" andInitials:initials];
    
    NSString *originalRecords = [NSString stringWithFormat:@"%@%@%@", proc1, TAG_DELIMITER, proc2];
    
    NSArray *originalRecordArray = [ProcedureRecordParser procedureRecordArrayFromList:originalRecords];
    
    [s.attributes setValue:originalRecords forKey:SPL_TAGS];
    [testStore putLibraryObject:s IntoTable:[SplitConstants tableName]];
    
    [Procedures geminiSplit:s
                             withInitials:initials
                                  inStore:testStore];
    
    NSString *newKey = @"Rock.002";
    
    LibraryObject *retrievedOriginalSplit = [testStore getLibraryObjectForKey:originalKey
                                                                     FromTable:[SplitConstants tableName]];
    LibraryObject *retrievedNewSplit = [testStore getLibraryObjectForKey:newKey
                                                                FromTable:[SplitConstants tableName]];
    
    NSString *newOriginalRecords = [[retrievedOriginalSplit attributes] objectForKey:SPL_TAGS];
    NSString *newRecords = [[retrievedNewSplit attributes] objectForKey:SPL_TAGS];
    
    NSArray *postOriginalRecordArray = [ProcedureRecordParser procedureRecordArrayFromList:newOriginalRecords];
    NSArray *postNewRecordArray = [ProcedureRecordParser procedureRecordArrayFromList:newRecords];
    
    
    ProcedureRecord *expectedOriginalRecord = [[ProcedureRecord alloc] initWithTag:PROC_TAG_GEMINI_UP andInitials:initials];
    ProcedureRecord *expectedNewRecord = [[ProcedureRecord alloc] initWithTag:PROC_TAG_GEMINI_DOWN andInitials:initials];
    
    XCTAssertEqualObjects([originalRecordArray objectAtIndex:0],    [postOriginalRecordArray objectAtIndex:0]);
    XCTAssertEqualObjects([originalRecordArray objectAtIndex:1],    [postOriginalRecordArray objectAtIndex:1]);
    XCTAssertEqualObjects(expectedOriginalRecord,                   [postOriginalRecordArray objectAtIndex:2]);
    XCTAssertEqualObjects([originalRecordArray objectAtIndex:0],    [postNewRecordArray objectAtIndex:0]);
    XCTAssertEqualObjects([originalRecordArray objectAtIndex:1],    [postNewRecordArray objectAtIndex:1]);
    XCTAssertEqualObjects(expectedNewRecord,                        [postNewRecordArray objectAtIndex:2]);
}

- (void)testPan
{
    NSString *originalKey = @"Rock.001";
    NSString *initials = @"AAA";
    Split *s = [[Split alloc] initWithKey:originalKey
                          AndWithAttributes:[SplitConstants attributeNames]
                                  AndValues:[SplitConstants attributeDefaultValues]];
    
    ProcedureRecord *proc1 = [[ProcedureRecord alloc] initWithTag:@"TAG01" andInitials:initials];
    ProcedureRecord *proc2 = [[ProcedureRecord alloc] initWithTag:@"TAG02" andInitials:initials];
    
    NSString *originalRecords = [NSString stringWithFormat:@"%@%@%@", proc1, TAG_DELIMITER, proc2];
    
    NSArray *originalRecordArray = [ProcedureRecordParser procedureRecordArrayFromList:originalRecords];
    
    [s.attributes setValue:originalRecords forKey:SPL_TAGS];
    [testStore putLibraryObject:s IntoTable:[SplitConstants tableName]];
    
    [Procedures panSplit:s
                withInitials:initials
                     inStore:testStore];
    
    NSString *newKey = @"Rock.002";
    
    LibraryObject *retrievedOriginalSplit = [testStore getLibraryObjectForKey:originalKey
                                                                     FromTable:[SplitConstants tableName]];
    LibraryObject *retrievedNewSplit = [testStore getLibraryObjectForKey:newKey
                                                                FromTable:[SplitConstants tableName]];
    
    NSString *newOriginalRecords = [[retrievedOriginalSplit attributes] objectForKey:SPL_TAGS];
    NSString *newRecords = [[retrievedNewSplit attributes] objectForKey:SPL_TAGS];
    
    NSArray *postOriginalRecordArray = [ProcedureRecordParser procedureRecordArrayFromList:newOriginalRecords];
    NSArray *postNewRecordArray = [ProcedureRecordParser procedureRecordArrayFromList:newRecords];
    
    
    ProcedureRecord *expectedOriginalRecord = [[ProcedureRecord alloc] initWithTag:PROC_TAG_PAN_UP andInitials:initials];
    ProcedureRecord *expectedNewRecord = [[ProcedureRecord alloc] initWithTag:PROC_TAG_PAN_DOWN andInitials:initials];
    
    XCTAssertEqualObjects([originalRecordArray objectAtIndex:0],    [postOriginalRecordArray objectAtIndex:0]);
    XCTAssertEqualObjects([originalRecordArray objectAtIndex:1],    [postOriginalRecordArray objectAtIndex:1]);
    XCTAssertEqualObjects(expectedOriginalRecord,                   [postOriginalRecordArray objectAtIndex:2]);
    XCTAssertEqualObjects([originalRecordArray objectAtIndex:0],    [postNewRecordArray objectAtIndex:0]);
    XCTAssertEqualObjects([originalRecordArray objectAtIndex:1],    [postNewRecordArray objectAtIndex:1]);
    XCTAssertEqualObjects(expectedNewRecord,                        [postNewRecordArray objectAtIndex:2]);
}

- (void)testSievesTen
{
    NSString *originalKey = @"Rock.001";
    NSString *initials = @"AAA";
    Split *s = [[Split alloc] initWithKey:originalKey
                          AndWithAttributes:[SplitConstants attributeNames]
                                  AndValues:[SplitConstants attributeDefaultValues]];
    
    ProcedureRecord *proc1 = [[ProcedureRecord alloc] initWithTag:@"TAG01" andInitials:initials];
    ProcedureRecord *proc2 = [[ProcedureRecord alloc] initWithTag:@"TAG02" andInitials:initials];
    
    NSString *originalRecords = [NSString stringWithFormat:@"%@%@%@", proc1, TAG_DELIMITER, proc2];
    
    NSArray *originalRecordArray = [ProcedureRecordParser procedureRecordArrayFromList:originalRecords];
    
    [s.attributes setValue:originalRecords forKey:SPL_TAGS];
    [testStore putLibraryObject:s IntoTable:[SplitConstants tableName]];
    
    [Procedures sievesTenSplit:s
                withInitials:initials
                     inStore:testStore];
    
    NSString *newKey = @"Rock.002";
    
    LibraryObject *retrievedOriginalSplit = [testStore getLibraryObjectForKey:originalKey
                                                                     FromTable:[SplitConstants tableName]];
    LibraryObject *retrievedNewSplit = [testStore getLibraryObjectForKey:newKey
                                                                FromTable:[SplitConstants tableName]];
    
    NSString *newOriginalRecords = [[retrievedOriginalSplit attributes] objectForKey:SPL_TAGS];
    NSString *newRecords = [[retrievedNewSplit attributes] objectForKey:SPL_TAGS];
    
    NSArray *postOriginalRecordArray = [ProcedureRecordParser procedureRecordArrayFromList:newOriginalRecords];
    NSArray *postNewRecordArray = [ProcedureRecordParser procedureRecordArrayFromList:newRecords];
    
    
    ProcedureRecord *expectedOriginalRecord = [[ProcedureRecord alloc] initWithTag:PROC_TAG_SIEVE_10_UP andInitials:initials];
    ProcedureRecord *expectedNewRecord = [[ProcedureRecord alloc] initWithTag:PROC_TAG_SIEVE_10_DOWN andInitials:initials];
    
    XCTAssertEqualObjects([originalRecordArray objectAtIndex:0],    [postOriginalRecordArray objectAtIndex:0]);
    XCTAssertEqualObjects([originalRecordArray objectAtIndex:1],    [postOriginalRecordArray objectAtIndex:1]);
    XCTAssertEqualObjects(expectedOriginalRecord,                   [postOriginalRecordArray objectAtIndex:2]);
    XCTAssertEqualObjects([originalRecordArray objectAtIndex:0],    [postNewRecordArray objectAtIndex:0]);
    XCTAssertEqualObjects([originalRecordArray objectAtIndex:1],    [postNewRecordArray objectAtIndex:1]);
    XCTAssertEqualObjects(expectedNewRecord,                        [postNewRecordArray objectAtIndex:2]);
}


- (void)testHL330
{
    NSString *originalKey = @"Rock.001";
    NSString *initials = @"AAA";
    Split *s = [[Split alloc] initWithKey:originalKey
                          AndWithAttributes:[SplitConstants attributeNames]
                                  AndValues:[SplitConstants attributeDefaultValues]];
    
    ProcedureRecord *proc1 = [[ProcedureRecord alloc] initWithTag:@"TAG01" andInitials:initials];
    ProcedureRecord *proc2 = [[ProcedureRecord alloc] initWithTag:@"TAG02" andInitials:initials];
    
    NSString *originalRecords = [NSString stringWithFormat:@"%@%@%@", proc1, TAG_DELIMITER, proc2];
    
    NSArray *originalRecordArray = [ProcedureRecordParser procedureRecordArrayFromList:originalRecords];
    
    [s.attributes setValue:originalRecords forKey:SPL_TAGS];
    [testStore putLibraryObject:s IntoTable:[SplitConstants tableName]];
    
    [Procedures heavyLiquid_330_Split:s
                          withInitials:initials
                               inStore:testStore];
    
    NSString *newKey = @"Rock.002";
    
    LibraryObject *retrievedOriginalSplit = [testStore getLibraryObjectForKey:originalKey
                                                                     FromTable:[SplitConstants tableName]];
    LibraryObject *retrievedNewSplit = [testStore getLibraryObjectForKey:newKey
                                                                FromTable:[SplitConstants tableName]];
    
    NSString *newOriginalRecords = [[retrievedOriginalSplit attributes] objectForKey:SPL_TAGS];
    NSString *newRecords = [[retrievedNewSplit attributes] objectForKey:SPL_TAGS];
    
    NSArray *postOriginalRecordArray = [ProcedureRecordParser procedureRecordArrayFromList:newOriginalRecords];
    NSArray *postNewRecordArray = [ProcedureRecordParser procedureRecordArrayFromList:newRecords];
    
    
    ProcedureRecord *expectedOriginalRecord = [[ProcedureRecord alloc] initWithTag:PROC_TAG_HEAVY_LIQUID_330_UP andInitials:initials];
    ProcedureRecord *expectedNewRecord = [[ProcedureRecord alloc] initWithTag:PROC_TAG_HEAVY_LIQUID_330_DOWN andInitials:initials];
    
    XCTAssertEqualObjects([originalRecordArray objectAtIndex:0],    [postOriginalRecordArray objectAtIndex:0]);
    XCTAssertEqualObjects([originalRecordArray objectAtIndex:1],    [postOriginalRecordArray objectAtIndex:1]);
    XCTAssertEqualObjects(expectedOriginalRecord,                   [postOriginalRecordArray objectAtIndex:2]);
    XCTAssertEqualObjects([originalRecordArray objectAtIndex:0],    [postNewRecordArray objectAtIndex:0]);
    XCTAssertEqualObjects([originalRecordArray objectAtIndex:1],    [postNewRecordArray objectAtIndex:1]);
    XCTAssertEqualObjects(expectedNewRecord,                        [postNewRecordArray objectAtIndex:2]);
}

- (void)testHL290
{
    NSString *originalKey = @"Rock.001";
    NSString *initials = @"AAA";
    Split *s = [[Split alloc] initWithKey:originalKey
                          AndWithAttributes:[SplitConstants attributeNames]
                                  AndValues:[SplitConstants attributeDefaultValues]];
    
    ProcedureRecord *proc1 = [[ProcedureRecord alloc] initWithTag:@"TAG01" andInitials:initials];
    ProcedureRecord *proc2 = [[ProcedureRecord alloc] initWithTag:@"TAG02" andInitials:initials];
    
    NSString *originalRecords = [NSString stringWithFormat:@"%@%@%@", proc1, TAG_DELIMITER, proc2];
    
    NSArray *originalRecordArray = [ProcedureRecordParser procedureRecordArrayFromList:originalRecords];
    
    [s.attributes setValue:originalRecords forKey:SPL_TAGS];
    [testStore putLibraryObject:s IntoTable:[SplitConstants tableName]];
    
    [Procedures heavyLiquid_290_Split:s
                          withInitials:initials
                               inStore:testStore];
    
    NSString *newKey = @"Rock.002";
    
    LibraryObject *retrievedOriginalSplit = [testStore getLibraryObjectForKey:originalKey
                                                                     FromTable:[SplitConstants tableName]];
    LibraryObject *retrievedNewSplit = [testStore getLibraryObjectForKey:newKey
                                                                FromTable:[SplitConstants tableName]];
    
    NSString *newOriginalRecords = [[retrievedOriginalSplit attributes] objectForKey:SPL_TAGS];
    NSString *newRecords = [[retrievedNewSplit attributes] objectForKey:SPL_TAGS];
    
    NSArray *postOriginalRecordArray = [ProcedureRecordParser procedureRecordArrayFromList:newOriginalRecords];
    NSArray *postNewRecordArray = [ProcedureRecordParser procedureRecordArrayFromList:newRecords];
    
    
    ProcedureRecord *expectedOriginalRecord = [[ProcedureRecord alloc] initWithTag:PROC_TAG_HEAVY_LIQUID_290_UP andInitials:initials];
    ProcedureRecord *expectedNewRecord = [[ProcedureRecord alloc] initWithTag:PROC_TAG_HEAVY_LIQUID_290_DOWN andInitials:initials];
    
    XCTAssertEqualObjects([originalRecordArray objectAtIndex:0],    [postOriginalRecordArray objectAtIndex:0]);
    XCTAssertEqualObjects([originalRecordArray objectAtIndex:1],    [postOriginalRecordArray objectAtIndex:1]);
    XCTAssertEqualObjects(expectedOriginalRecord,                   [postOriginalRecordArray objectAtIndex:2]);
    XCTAssertEqualObjects([originalRecordArray objectAtIndex:0],    [postNewRecordArray objectAtIndex:0]);
    XCTAssertEqualObjects([originalRecordArray objectAtIndex:1],    [postNewRecordArray objectAtIndex:1]);
    XCTAssertEqualObjects(expectedNewRecord,                        [postNewRecordArray objectAtIndex:2]);
}

- (void)testHL265
{
    NSString *originalKey = @"Rock.001";
    NSString *initials = @"AAA";
    Split *s = [[Split alloc] initWithKey:originalKey
                          AndWithAttributes:[SplitConstants attributeNames]
                                  AndValues:[SplitConstants attributeDefaultValues]];
    
    ProcedureRecord *proc1 = [[ProcedureRecord alloc] initWithTag:@"TAG01" andInitials:initials];
    ProcedureRecord *proc2 = [[ProcedureRecord alloc] initWithTag:@"TAG02" andInitials:initials];
    
    NSString *originalRecords = [NSString stringWithFormat:@"%@%@%@", proc1, TAG_DELIMITER, proc2];
    
    NSArray *originalRecordArray = [ProcedureRecordParser procedureRecordArrayFromList:originalRecords];
    
    [s.attributes setValue:originalRecords forKey:SPL_TAGS];
    [testStore putLibraryObject:s IntoTable:[SplitConstants tableName]];
    
    [Procedures heavyLiquid_265_Split:s
                          withInitials:initials
                               inStore:testStore];
    
    NSString *newKey = @"Rock.002";
    
    LibraryObject *retrievedOriginalSplit = [testStore getLibraryObjectForKey:originalKey
                                                                     FromTable:[SplitConstants tableName]];
    LibraryObject *retrievedNewSplit = [testStore getLibraryObjectForKey:newKey
                                                                FromTable:[SplitConstants tableName]];
    
    NSString *newOriginalRecords = [[retrievedOriginalSplit attributes] objectForKey:SPL_TAGS];
    NSString *newRecords = [[retrievedNewSplit attributes] objectForKey:SPL_TAGS];
    
    NSArray *postOriginalRecordArray = [ProcedureRecordParser procedureRecordArrayFromList:newOriginalRecords];
    NSArray *postNewRecordArray = [ProcedureRecordParser procedureRecordArrayFromList:newRecords];
    
    
    ProcedureRecord *expectedOriginalRecord = [[ProcedureRecord alloc] initWithTag:PROC_TAG_HEAVY_LIQUID_265_UP andInitials:initials];
    ProcedureRecord *expectedNewRecord = [[ProcedureRecord alloc] initWithTag:PROC_TAG_HEAVY_LIQUID_265_DOWN andInitials:initials];
    
    XCTAssertEqualObjects([originalRecordArray objectAtIndex:0],    [postOriginalRecordArray objectAtIndex:0]);
    XCTAssertEqualObjects([originalRecordArray objectAtIndex:1],    [postOriginalRecordArray objectAtIndex:1]);
    XCTAssertEqualObjects(expectedOriginalRecord,                   [postOriginalRecordArray objectAtIndex:2]);
    XCTAssertEqualObjects([originalRecordArray objectAtIndex:0],    [postNewRecordArray objectAtIndex:0]);
    XCTAssertEqualObjects([originalRecordArray objectAtIndex:1],    [postNewRecordArray objectAtIndex:1]);
    XCTAssertEqualObjects(expectedNewRecord,                        [postNewRecordArray objectAtIndex:2]);
}

- (void)testHL255
{
    NSString *originalKey = @"Rock.001";
    NSString *initials = @"AAA";
    Split *s = [[Split alloc] initWithKey:originalKey
                          AndWithAttributes:[SplitConstants attributeNames]
                                  AndValues:[SplitConstants attributeDefaultValues]];
    
    ProcedureRecord *proc1 = [[ProcedureRecord alloc] initWithTag:@"TAG01" andInitials:initials];
    ProcedureRecord *proc2 = [[ProcedureRecord alloc] initWithTag:@"TAG02" andInitials:initials];
    
    NSString *originalRecords = [NSString stringWithFormat:@"%@%@%@", proc1, TAG_DELIMITER, proc2];
    
    NSArray *originalRecordArray = [ProcedureRecordParser procedureRecordArrayFromList:originalRecords];
    
    [s.attributes setValue:originalRecords forKey:SPL_TAGS];
    [testStore putLibraryObject:s IntoTable:[SplitConstants tableName]];
    
    [Procedures heavyLiquid_255_Split:s
                          withInitials:initials
                               inStore:testStore];
    
    NSString *newKey = @"Rock.002";
    
    LibraryObject *retrievedOriginalSplit = [testStore getLibraryObjectForKey:originalKey
                                                                     FromTable:[SplitConstants tableName]];
    LibraryObject *retrievedNewSplit = [testStore getLibraryObjectForKey:newKey
                                                                FromTable:[SplitConstants tableName]];
    
    NSString *newOriginalRecords = [[retrievedOriginalSplit attributes] objectForKey:SPL_TAGS];
    NSString *newRecords = [[retrievedNewSplit attributes] objectForKey:SPL_TAGS];
    
    NSArray *postOriginalRecordArray = [ProcedureRecordParser procedureRecordArrayFromList:newOriginalRecords];
    NSArray *postNewRecordArray = [ProcedureRecordParser procedureRecordArrayFromList:newRecords];
    
    
    ProcedureRecord *expectedOriginalRecord = [[ProcedureRecord alloc] initWithTag:PROC_TAG_HEAVY_LIQUID_255_UP andInitials:initials];
    ProcedureRecord *expectedNewRecord = [[ProcedureRecord alloc] initWithTag:PROC_TAG_HEAVY_LIQUID_255_DOWN andInitials:initials];
    
    XCTAssertEqualObjects([originalRecordArray objectAtIndex:0],    [postOriginalRecordArray objectAtIndex:0]);
    XCTAssertEqualObjects([originalRecordArray objectAtIndex:1],    [postOriginalRecordArray objectAtIndex:1]);
    XCTAssertEqualObjects(expectedOriginalRecord,                   [postOriginalRecordArray objectAtIndex:2]);
    XCTAssertEqualObjects([originalRecordArray objectAtIndex:0],    [postNewRecordArray objectAtIndex:0]);
    XCTAssertEqualObjects([originalRecordArray objectAtIndex:1],    [postNewRecordArray objectAtIndex:1]);
    XCTAssertEqualObjects(expectedNewRecord,                        [postNewRecordArray objectAtIndex:2]);
}

- (void)testHandMagnet
{
    NSString *originalKey = @"Rock.001";
    NSString *initials = @"AAA";
    Split *s = [[Split alloc] initWithKey:originalKey
                          AndWithAttributes:[SplitConstants attributeNames]
                                  AndValues:[SplitConstants attributeDefaultValues]];
    
    ProcedureRecord *proc1 = [[ProcedureRecord alloc] initWithTag:@"TAG01" andInitials:initials];
    ProcedureRecord *proc2 = [[ProcedureRecord alloc] initWithTag:@"TAG02" andInitials:initials];
    
    NSString *originalRecords = [NSString stringWithFormat:@"%@%@%@", proc1, TAG_DELIMITER, proc2];
    
    NSArray *originalRecordArray = [ProcedureRecordParser procedureRecordArrayFromList:originalRecords];
    
    [s.attributes setValue:originalRecords forKey:SPL_TAGS];
    [testStore putLibraryObject:s IntoTable:[SplitConstants tableName]];
    
    [Procedures handMagnetSplit:s
                          withInitials:initials
                               inStore:testStore];
    
    NSString *newKey = @"Rock.002";
    
    LibraryObject *retrievedOriginalSplit = [testStore getLibraryObjectForKey:originalKey
                                                                     FromTable:[SplitConstants tableName]];
    LibraryObject *retrievedNewSplit = [testStore getLibraryObjectForKey:newKey
                                                                FromTable:[SplitConstants tableName]];
    
    NSString *newOriginalRecords = [[retrievedOriginalSplit attributes] objectForKey:SPL_TAGS];
    NSString *newRecords = [[retrievedNewSplit attributes] objectForKey:SPL_TAGS];
    
    NSArray *postOriginalRecordArray = [ProcedureRecordParser procedureRecordArrayFromList:newOriginalRecords];
    NSArray *postNewRecordArray = [ProcedureRecordParser procedureRecordArrayFromList:newRecords];
    
    
    ProcedureRecord *expectedOriginalRecord = [[ProcedureRecord alloc] initWithTag:PROC_TAG_HAND_MAGNET_UP andInitials:initials];
    ProcedureRecord *expectedNewRecord = [[ProcedureRecord alloc] initWithTag:PROC_TAG_HAND_MAGNET_DOWN andInitials:initials];
    
    XCTAssertEqualObjects([originalRecordArray objectAtIndex:0],    [postOriginalRecordArray objectAtIndex:0]);
    XCTAssertEqualObjects([originalRecordArray objectAtIndex:1],    [postOriginalRecordArray objectAtIndex:1]);
    XCTAssertEqualObjects(expectedOriginalRecord,                   [postOriginalRecordArray objectAtIndex:2]);
    XCTAssertEqualObjects([originalRecordArray objectAtIndex:0],    [postNewRecordArray objectAtIndex:0]);
    XCTAssertEqualObjects([originalRecordArray objectAtIndex:1],    [postNewRecordArray objectAtIndex:1]);
    XCTAssertEqualObjects(expectedNewRecord,                        [postNewRecordArray objectAtIndex:2]);
}

- (void)testAmp02
{
    NSString *originalKey = @"Rock.001";
    NSString *initials = @"AAA";
    Split *s = [[Split alloc] initWithKey:originalKey
                          AndWithAttributes:[SplitConstants attributeNames]
                                  AndValues:[SplitConstants attributeDefaultValues]];
    
    ProcedureRecord *proc1 = [[ProcedureRecord alloc] initWithTag:@"TAG01" andInitials:initials];
    ProcedureRecord *proc2 = [[ProcedureRecord alloc] initWithTag:@"TAG02" andInitials:initials];
    
    NSString *originalRecords = [NSString stringWithFormat:@"%@%@%@", proc1, TAG_DELIMITER, proc2];
    
    NSArray *originalRecordArray = [ProcedureRecordParser procedureRecordArrayFromList:originalRecords];
    
    [s.attributes setValue:originalRecords forKey:SPL_TAGS];
    [testStore putLibraryObject:s IntoTable:[SplitConstants tableName]];
    
    [Procedures magnet02AmpsSplit:s
                          withInitials:initials
                               inStore:testStore];
    
    NSString *newKey = @"Rock.002";
    
    LibraryObject *retrievedOriginalSplit = [testStore getLibraryObjectForKey:originalKey
                                                                     FromTable:[SplitConstants tableName]];
    LibraryObject *retrievedNewSplit = [testStore getLibraryObjectForKey:newKey
                                                                FromTable:[SplitConstants tableName]];
    
    NSString *newOriginalRecords = [[retrievedOriginalSplit attributes] objectForKey:SPL_TAGS];
    NSString *newRecords = [[retrievedNewSplit attributes] objectForKey:SPL_TAGS];
    
    NSArray *postOriginalRecordArray = [ProcedureRecordParser procedureRecordArrayFromList:newOriginalRecords];
    NSArray *postNewRecordArray = [ProcedureRecordParser procedureRecordArrayFromList:newRecords];
    
    
    ProcedureRecord *expectedOriginalRecord = [[ProcedureRecord alloc] initWithTag:PROC_TAG_MAGNET_02_AMPS_UP andInitials:initials];
    ProcedureRecord *expectedNewRecord = [[ProcedureRecord alloc] initWithTag:PROC_TAG_MAGNET_02_AMPS_DOWN andInitials:initials];
    
    XCTAssertEqualObjects([originalRecordArray objectAtIndex:0],    [postOriginalRecordArray objectAtIndex:0]);
    XCTAssertEqualObjects([originalRecordArray objectAtIndex:1],    [postOriginalRecordArray objectAtIndex:1]);
    XCTAssertEqualObjects(expectedOriginalRecord,                   [postOriginalRecordArray objectAtIndex:2]);
    XCTAssertEqualObjects([originalRecordArray objectAtIndex:0],    [postNewRecordArray objectAtIndex:0]);
    XCTAssertEqualObjects([originalRecordArray objectAtIndex:1],    [postNewRecordArray objectAtIndex:1]);
    XCTAssertEqualObjects(expectedNewRecord,                        [postNewRecordArray objectAtIndex:2]);
}

- (void)testAmp04
{
    NSString *originalKey = @"Rock.001";
    NSString *initials = @"AAA";
    Split *s = [[Split alloc] initWithKey:originalKey
                          AndWithAttributes:[SplitConstants attributeNames]
                                  AndValues:[SplitConstants attributeDefaultValues]];
    
    ProcedureRecord *proc1 = [[ProcedureRecord alloc] initWithTag:@"TAG01" andInitials:initials];
    ProcedureRecord *proc2 = [[ProcedureRecord alloc] initWithTag:@"TAG02" andInitials:initials];
    
    NSString *originalRecords = [NSString stringWithFormat:@"%@%@%@", proc1, TAG_DELIMITER, proc2];
    
    NSArray *originalRecordArray = [ProcedureRecordParser procedureRecordArrayFromList:originalRecords];
    
    [s.attributes setValue:originalRecords forKey:SPL_TAGS];
    [testStore putLibraryObject:s IntoTable:[SplitConstants tableName]];
    
    [Procedures magnet04AmpsSplit:s
                      withInitials:initials
                           inStore:testStore];
    
    NSString *newKey = @"Rock.002";
    
    LibraryObject *retrievedOriginalSplit = [testStore getLibraryObjectForKey:originalKey
                                                                     FromTable:[SplitConstants tableName]];
    LibraryObject *retrievedNewSplit = [testStore getLibraryObjectForKey:newKey
                                                                FromTable:[SplitConstants tableName]];
    
    NSString *newOriginalRecords = [[retrievedOriginalSplit attributes] objectForKey:SPL_TAGS];
    NSString *newRecords = [[retrievedNewSplit attributes] objectForKey:SPL_TAGS];
    
    NSArray *postOriginalRecordArray = [ProcedureRecordParser procedureRecordArrayFromList:newOriginalRecords];
    NSArray *postNewRecordArray = [ProcedureRecordParser procedureRecordArrayFromList:newRecords];
    
    
    ProcedureRecord *expectedOriginalRecord = [[ProcedureRecord alloc] initWithTag:PROC_TAG_MAGNET_04_AMPS_UP andInitials:initials];
    ProcedureRecord *expectedNewRecord = [[ProcedureRecord alloc] initWithTag:PROC_TAG_MAGNET_04_AMPS_DOWN andInitials:initials];
    
    XCTAssertEqualObjects([originalRecordArray objectAtIndex:0],    [postOriginalRecordArray objectAtIndex:0]);
    XCTAssertEqualObjects([originalRecordArray objectAtIndex:1],    [postOriginalRecordArray objectAtIndex:1]);
    XCTAssertEqualObjects(expectedOriginalRecord,                   [postOriginalRecordArray objectAtIndex:2]);
    XCTAssertEqualObjects([originalRecordArray objectAtIndex:0],    [postNewRecordArray objectAtIndex:0]);
    XCTAssertEqualObjects([originalRecordArray objectAtIndex:1],    [postNewRecordArray objectAtIndex:1]);
    XCTAssertEqualObjects(expectedNewRecord,                        [postNewRecordArray objectAtIndex:2]);
}

- (void)testAmp06
{
    NSString *originalKey = @"Rock.001";
    NSString *initials = @"AAA";
    Split *s = [[Split alloc] initWithKey:originalKey
                          AndWithAttributes:[SplitConstants attributeNames]
                                  AndValues:[SplitConstants attributeDefaultValues]];
    
    ProcedureRecord *proc1 = [[ProcedureRecord alloc] initWithTag:@"TAG01" andInitials:initials];
    ProcedureRecord *proc2 = [[ProcedureRecord alloc] initWithTag:@"TAG02" andInitials:initials];
    
    NSString *originalRecords = [NSString stringWithFormat:@"%@%@%@", proc1, TAG_DELIMITER, proc2];
    
    NSArray *originalRecordArray = [ProcedureRecordParser procedureRecordArrayFromList:originalRecords];
    
    [s.attributes setValue:originalRecords forKey:SPL_TAGS];
    [testStore putLibraryObject:s IntoTable:[SplitConstants tableName]];
    
    [Procedures magnet06AmpsSplit:s
                      withInitials:initials
                           inStore:testStore];
    
    NSString *newKey = @"Rock.002";
    
    LibraryObject *retrievedOriginalSplit = [testStore getLibraryObjectForKey:originalKey
                                                                     FromTable:[SplitConstants tableName]];
    LibraryObject *retrievedNewSplit = [testStore getLibraryObjectForKey:newKey
                                                                FromTable:[SplitConstants tableName]];
    
    NSString *newOriginalRecords = [[retrievedOriginalSplit attributes] objectForKey:SPL_TAGS];
    NSString *newRecords = [[retrievedNewSplit attributes] objectForKey:SPL_TAGS];
    
    NSArray *postOriginalRecordArray = [ProcedureRecordParser procedureRecordArrayFromList:newOriginalRecords];
    NSArray *postNewRecordArray = [ProcedureRecordParser procedureRecordArrayFromList:newRecords];
    
    
    ProcedureRecord *expectedOriginalRecord = [[ProcedureRecord alloc] initWithTag:PROC_TAG_MAGNET_06_AMPS_UP andInitials:initials];
    ProcedureRecord *expectedNewRecord = [[ProcedureRecord alloc] initWithTag:PROC_TAG_MAGNET_06_AMPS_DOWN andInitials:initials];
    
    XCTAssertEqualObjects([originalRecordArray objectAtIndex:0],    [postOriginalRecordArray objectAtIndex:0]);
    XCTAssertEqualObjects([originalRecordArray objectAtIndex:1],    [postOriginalRecordArray objectAtIndex:1]);
    XCTAssertEqualObjects(expectedOriginalRecord,                   [postOriginalRecordArray objectAtIndex:2]);
    XCTAssertEqualObjects([originalRecordArray objectAtIndex:0],    [postNewRecordArray objectAtIndex:0]);
    XCTAssertEqualObjects([originalRecordArray objectAtIndex:1],    [postNewRecordArray objectAtIndex:1]);
    XCTAssertEqualObjects(expectedNewRecord,                        [postNewRecordArray objectAtIndex:2]);
}

- (void)testAmp08
{
    NSString *originalKey = @"Rock.001";
    NSString *initials = @"AAA";
    Split *s = [[Split alloc] initWithKey:originalKey
                          AndWithAttributes:[SplitConstants attributeNames]
                                  AndValues:[SplitConstants attributeDefaultValues]];
    
    ProcedureRecord *proc1 = [[ProcedureRecord alloc] initWithTag:@"TAG01" andInitials:initials];
    ProcedureRecord *proc2 = [[ProcedureRecord alloc] initWithTag:@"TAG02" andInitials:initials];
    
    NSString *originalRecords = [NSString stringWithFormat:@"%@%@%@", proc1, TAG_DELIMITER, proc2];
    
    NSArray *originalRecordArray = [ProcedureRecordParser procedureRecordArrayFromList:originalRecords];
    
    [s.attributes setValue:originalRecords forKey:SPL_TAGS];
    [testStore putLibraryObject:s IntoTable:[SplitConstants tableName]];
    
    [Procedures magnet08AmpsSplit:s
                      withInitials:initials
                           inStore:testStore];
    
    NSString *newKey = @"Rock.002";
    
    LibraryObject *retrievedOriginalSplit = [testStore getLibraryObjectForKey:originalKey
                                                                     FromTable:[SplitConstants tableName]];
    LibraryObject *retrievedNewSplit = [testStore getLibraryObjectForKey:newKey
                                                                FromTable:[SplitConstants tableName]];
    
    NSString *newOriginalRecords = [[retrievedOriginalSplit attributes] objectForKey:SPL_TAGS];
    NSString *newRecords = [[retrievedNewSplit attributes] objectForKey:SPL_TAGS];
    
    NSArray *postOriginalRecordArray = [ProcedureRecordParser procedureRecordArrayFromList:newOriginalRecords];
    NSArray *postNewRecordArray = [ProcedureRecordParser procedureRecordArrayFromList:newRecords];
    
    
    ProcedureRecord *expectedOriginalRecord = [[ProcedureRecord alloc] initWithTag:PROC_TAG_MAGNET_08_AMPS_UP andInitials:initials];
    ProcedureRecord *expectedNewRecord = [[ProcedureRecord alloc] initWithTag:PROC_TAG_MAGNET_08_AMPS_DOWN andInitials:initials];
    
    XCTAssertEqualObjects([originalRecordArray objectAtIndex:0],    [postOriginalRecordArray objectAtIndex:0]);
    XCTAssertEqualObjects([originalRecordArray objectAtIndex:1],    [postOriginalRecordArray objectAtIndex:1]);
    XCTAssertEqualObjects(expectedOriginalRecord,                   [postOriginalRecordArray objectAtIndex:2]);
    XCTAssertEqualObjects([originalRecordArray objectAtIndex:0],    [postNewRecordArray objectAtIndex:0]);
    XCTAssertEqualObjects([originalRecordArray objectAtIndex:1],    [postNewRecordArray objectAtIndex:1]);
    XCTAssertEqualObjects(expectedNewRecord,                        [postNewRecordArray objectAtIndex:2]);
}

- (void)testAmp10
{
    NSString *originalKey = @"Rock.001";
    NSString *initials = @"AAA";
    Split *s = [[Split alloc] initWithKey:originalKey
                          AndWithAttributes:[SplitConstants attributeNames]
                                  AndValues:[SplitConstants attributeDefaultValues]];
    
    ProcedureRecord *proc1 = [[ProcedureRecord alloc] initWithTag:@"TAG01" andInitials:initials];
    ProcedureRecord *proc2 = [[ProcedureRecord alloc] initWithTag:@"TAG02" andInitials:initials];
    
    NSString *originalRecords = [NSString stringWithFormat:@"%@%@%@", proc1, TAG_DELIMITER, proc2];
    
    NSArray *originalRecordArray = [ProcedureRecordParser procedureRecordArrayFromList:originalRecords];
    
    [s.attributes setValue:originalRecords forKey:SPL_TAGS];
    [testStore putLibraryObject:s IntoTable:[SplitConstants tableName]];
    
    [Procedures magnet10AmpsSplit:s
                      withInitials:initials
                           inStore:testStore];
    
    NSString *newKey = @"Rock.002";
    
    LibraryObject *retrievedOriginalSplit = [testStore getLibraryObjectForKey:originalKey
                                                                     FromTable:[SplitConstants tableName]];
    LibraryObject *retrievedNewSplit = [testStore getLibraryObjectForKey:newKey
                                                                FromTable:[SplitConstants tableName]];
    
    NSString *newOriginalRecords = [[retrievedOriginalSplit attributes] objectForKey:SPL_TAGS];
    NSString *newRecords = [[retrievedNewSplit attributes] objectForKey:SPL_TAGS];
    
    NSArray *postOriginalRecordArray = [ProcedureRecordParser procedureRecordArrayFromList:newOriginalRecords];
    NSArray *postNewRecordArray = [ProcedureRecordParser procedureRecordArrayFromList:newRecords];
    
    
    ProcedureRecord *expectedOriginalRecord = [[ProcedureRecord alloc] initWithTag:PROC_TAG_MAGNET_10_AMPS_UP andInitials:initials];
    ProcedureRecord *expectedNewRecord = [[ProcedureRecord alloc] initWithTag:PROC_TAG_MAGNET_10_AMPS_DOWN andInitials:initials];
    
    XCTAssertEqualObjects([originalRecordArray objectAtIndex:0],    [postOriginalRecordArray objectAtIndex:0]);
    XCTAssertEqualObjects([originalRecordArray objectAtIndex:1],    [postOriginalRecordArray objectAtIndex:1]);
    XCTAssertEqualObjects(expectedOriginalRecord,                   [postOriginalRecordArray objectAtIndex:2]);
    XCTAssertEqualObjects([originalRecordArray objectAtIndex:0],    [postNewRecordArray objectAtIndex:0]);
    XCTAssertEqualObjects([originalRecordArray objectAtIndex:1],    [postNewRecordArray objectAtIndex:1]);
    XCTAssertEqualObjects(expectedNewRecord,                        [postNewRecordArray objectAtIndex:2]);
}

- (void)testAmp12
{
    NSString *originalKey = @"Rock.001";
    NSString *initials = @"AAA";
    Split *s = [[Split alloc] initWithKey:originalKey
                          AndWithAttributes:[SplitConstants attributeNames]
                                  AndValues:[SplitConstants attributeDefaultValues]];
    
    ProcedureRecord *proc1 = [[ProcedureRecord alloc] initWithTag:@"TAG01" andInitials:initials];
    ProcedureRecord *proc2 = [[ProcedureRecord alloc] initWithTag:@"TAG02" andInitials:initials];
    
    NSString *originalRecords = [NSString stringWithFormat:@"%@%@%@", proc1, TAG_DELIMITER, proc2];
    
    NSArray *originalRecordArray = [ProcedureRecordParser procedureRecordArrayFromList:originalRecords];
    
    [s.attributes setValue:originalRecords forKey:SPL_TAGS];
    [testStore putLibraryObject:s IntoTable:[SplitConstants tableName]];
    
    [Procedures magnet12AmpsSplit:s
                      withInitials:initials
                           inStore:testStore];
    
    NSString *newKey = @"Rock.002";
    
    LibraryObject *retrievedOriginalSplit = [testStore getLibraryObjectForKey:originalKey
                                                                     FromTable:[SplitConstants tableName]];
    LibraryObject *retrievedNewSplit = [testStore getLibraryObjectForKey:newKey
                                                                FromTable:[SplitConstants tableName]];
    
    NSString *newOriginalRecords = [[retrievedOriginalSplit attributes] objectForKey:SPL_TAGS];
    NSString *newRecords = [[retrievedNewSplit attributes] objectForKey:SPL_TAGS];
    
    NSArray *postOriginalRecordArray = [ProcedureRecordParser procedureRecordArrayFromList:newOriginalRecords];
    NSArray *postNewRecordArray = [ProcedureRecordParser procedureRecordArrayFromList:newRecords];
    
    
    ProcedureRecord *expectedOriginalRecord = [[ProcedureRecord alloc] initWithTag:PROC_TAG_MAGNET_12_AMPS_UP andInitials:initials];
    ProcedureRecord *expectedNewRecord = [[ProcedureRecord alloc] initWithTag:PROC_TAG_MAGNET_12_AMPS_DOWN andInitials:initials];
    
    XCTAssertEqualObjects([originalRecordArray objectAtIndex:0],    [postOriginalRecordArray objectAtIndex:0]);
    XCTAssertEqualObjects([originalRecordArray objectAtIndex:1],    [postOriginalRecordArray objectAtIndex:1]);
    XCTAssertEqualObjects(expectedOriginalRecord,                   [postOriginalRecordArray objectAtIndex:2]);
    XCTAssertEqualObjects([originalRecordArray objectAtIndex:0],    [postNewRecordArray objectAtIndex:0]);
    XCTAssertEqualObjects([originalRecordArray objectAtIndex:1],    [postNewRecordArray objectAtIndex:1]);
    XCTAssertEqualObjects(expectedNewRecord,                        [postNewRecordArray objectAtIndex:2]);
}

- (void)testAmp14
{
    NSString *originalKey = @"Rock.001";
    NSString *initials = @"AAA";
    Split *s = [[Split alloc] initWithKey:originalKey
                          AndWithAttributes:[SplitConstants attributeNames]
                                  AndValues:[SplitConstants attributeDefaultValues]];
    
    ProcedureRecord *proc1 = [[ProcedureRecord alloc] initWithTag:@"TAG01" andInitials:initials];
    ProcedureRecord *proc2 = [[ProcedureRecord alloc] initWithTag:@"TAG02" andInitials:initials];
    
    NSString *originalRecords = [NSString stringWithFormat:@"%@%@%@", proc1, TAG_DELIMITER, proc2];
    
    NSArray *originalRecordArray = [ProcedureRecordParser procedureRecordArrayFromList:originalRecords];
    
    [s.attributes setValue:originalRecords forKey:SPL_TAGS];
    [testStore putLibraryObject:s IntoTable:[SplitConstants tableName]];
    
    [Procedures magnet14AmpsSplit:s
                      withInitials:initials
                           inStore:testStore];
    
    NSString *newKey = @"Rock.002";
    
    LibraryObject *retrievedOriginalSplit = [testStore getLibraryObjectForKey:originalKey
                                                                     FromTable:[SplitConstants tableName]];
    LibraryObject *retrievedNewSplit = [testStore getLibraryObjectForKey:newKey
                                                                FromTable:[SplitConstants tableName]];
    
    NSString *newOriginalRecords = [[retrievedOriginalSplit attributes] objectForKey:SPL_TAGS];
    NSString *newRecords = [[retrievedNewSplit attributes] objectForKey:SPL_TAGS];
    
    NSArray *postOriginalRecordArray = [ProcedureRecordParser procedureRecordArrayFromList:newOriginalRecords];
    NSArray *postNewRecordArray = [ProcedureRecordParser procedureRecordArrayFromList:newRecords];
    
    
    ProcedureRecord *expectedOriginalRecord = [[ProcedureRecord alloc] initWithTag:PROC_TAG_MAGNET_14_AMPS_UP andInitials:initials];
    ProcedureRecord *expectedNewRecord = [[ProcedureRecord alloc] initWithTag:PROC_TAG_MAGNET_14_AMPS_DOWN andInitials:initials];
    
    XCTAssertEqualObjects([originalRecordArray objectAtIndex:0],    [postOriginalRecordArray objectAtIndex:0]);
    XCTAssertEqualObjects([originalRecordArray objectAtIndex:1],    [postOriginalRecordArray objectAtIndex:1]);
    XCTAssertEqualObjects(expectedOriginalRecord,                   [postOriginalRecordArray objectAtIndex:2]);
    XCTAssertEqualObjects([originalRecordArray objectAtIndex:0],    [postNewRecordArray objectAtIndex:0]);
    XCTAssertEqualObjects([originalRecordArray objectAtIndex:1],    [postNewRecordArray objectAtIndex:1]);
    XCTAssertEqualObjects(expectedNewRecord,                        [postNewRecordArray objectAtIndex:2]);
}
@end
