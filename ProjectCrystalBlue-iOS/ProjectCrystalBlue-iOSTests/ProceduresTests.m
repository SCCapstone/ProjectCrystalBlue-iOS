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

- (void)testAddFreshSample
{
    NSString *originalKey = @"Rock.001";
    Sample *s = [[Sample alloc] initWithKey:originalKey
                          AndWithAttributes:[SampleConstants attributeNames]
                                  AndValues:[SampleConstants attributeDefaultValues]];

    
    [Procedures addFreshSample:s inStore:testStore];
    [Procedures addFreshSample:s inStore:testStore];

    LibraryObject *sample1 = [testStore getLibraryObjectForKey:@"Rock.002"
                                                     FromTable:[SampleConstants tableName]];
    LibraryObject *sample2 = [testStore getLibraryObjectForKey:@"Rock.003"
                                                     FromTable:[SampleConstants tableName]];
    
    
    XCTAssertEqualObjects(s.key,         @"Rock.001");
    XCTAssertEqualObjects(sample1.key,   @"Rock.002");
    XCTAssertEqualObjects(sample2.key,   @"Rock.003");
}

- (void)testMoveSample
{
    NSString *originalKey = @"Rock.001";
    Sample *s = [[Sample alloc] initWithKey:originalKey
                          AndWithAttributes:[SampleConstants attributeNames]
                                  AndValues:[SampleConstants attributeDefaultValues]];
    
    NSString *originalLocation = [[s attributes] objectForKey:SMP_CURRENT_LOCATION];
    
    [Procedures moveSample:s toLocation:@"NewLocation" inStore:testStore];

    
    XCTAssertNotEqualObjects([[s attributes] objectForKey:SMP_CURRENT_LOCATION],    originalLocation);
    XCTAssertEqualObjects([[s attributes] objectForKey:SMP_CURRENT_LOCATION],    @"NewLocation");
}

- (void)testMakeSlab
{
    NSString *originalKey = @"Rock.001";
    NSString *initials = @"AAA";
    Sample *s = [[Sample alloc] initWithKey:originalKey
                          AndWithAttributes:[SampleConstants attributeNames]
                                  AndValues:[SampleConstants attributeDefaultValues]];
    
    ProcedureRecord *proc1 = [[ProcedureRecord alloc] initWithTag:@"TAG01" andInitials:initials];
    ProcedureRecord *proc2 = [[ProcedureRecord alloc] initWithTag:@"TAG02" andInitials:initials];
    
    NSString *originalRecords = [NSString stringWithFormat:@"%@%@%@", proc1, TAG_DELIMITER, proc2];
    
    NSArray *originalRecordArray = [ProcedureRecordParser procedureRecordArrayFromList:originalRecords];
    
    [s.attributes setValue:originalRecords forKey:SMP_TAGS];
    [testStore putLibraryObject:s IntoTable:[SampleConstants tableName]];
    
    [Procedures makeSlabfromSample:s
                  withInitials:initials
                       inStore:testStore];
    
    NSString *newKey = @"Rock.002";
    
    LibraryObject *retrievedOriginalSample = [testStore getLibraryObjectForKey:originalKey
                                                                FromTable:[SampleConstants tableName]];
    LibraryObject *retrievedNewSample = [testStore getLibraryObjectForKey:newKey
                                                             FromTable:[SampleConstants tableName]];
    
    NSString *newOriginalRecords = [[retrievedOriginalSample attributes] objectForKey:SMP_TAGS];
    NSString *newRecords = [[retrievedNewSample attributes] objectForKey:SMP_TAGS];
    
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
    Sample *s = [[Sample alloc] initWithKey:originalKey
                          AndWithAttributes:[SampleConstants attributeNames]
                                  AndValues:[SampleConstants attributeDefaultValues]];
    
    ProcedureRecord *proc1 = [[ProcedureRecord alloc] initWithTag:@"TAG01" andInitials:initials];
    ProcedureRecord *proc2 = [[ProcedureRecord alloc] initWithTag:@"TAG02" andInitials:initials];
    
    NSString *originalRecords = [NSString stringWithFormat:@"%@%@%@", proc1, TAG_DELIMITER, proc2];
    
    NSArray *originalRecordArray = [ProcedureRecordParser procedureRecordArrayFromList:originalRecords];
    
    [s.attributes setValue:originalRecords forKey:SMP_TAGS];
    [testStore putLibraryObject:s IntoTable:[SampleConstants tableName]];
    
    [Procedures makeBilletfromSample:s
                      withInitials:initials
                           inStore:testStore];
    
    NSString *newKey = @"Rock.002";
    
    LibraryObject *retrievedOriginalSample = [testStore getLibraryObjectForKey:originalKey
                                                                     FromTable:[SampleConstants tableName]];
    LibraryObject *retrievedNewSample = [testStore getLibraryObjectForKey:newKey
                                                                FromTable:[SampleConstants tableName]];
    
    NSString *newOriginalRecords = [[retrievedOriginalSample attributes] objectForKey:SMP_TAGS];
    NSString *newRecords = [[retrievedNewSample attributes] objectForKey:SMP_TAGS];
    
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
    Sample *s = [[Sample alloc] initWithKey:originalKey
                          AndWithAttributes:[SampleConstants attributeNames]
                                  AndValues:[SampleConstants attributeDefaultValues]];
    
    ProcedureRecord *proc1 = [[ProcedureRecord alloc] initWithTag:@"TAG01" andInitials:initials];
    ProcedureRecord *proc2 = [[ProcedureRecord alloc] initWithTag:@"TAG02" andInitials:initials];
    
    NSString *originalRecords = [NSString stringWithFormat:@"%@%@%@", proc1, TAG_DELIMITER, proc2];
    
    NSArray *originalRecordArray = [ProcedureRecordParser procedureRecordArrayFromList:originalRecords];
    
    [s.attributes setValue:originalRecords forKey:SMP_TAGS];
    [testStore putLibraryObject:s IntoTable:[SampleConstants tableName]];
    
    [Procedures makeThinSectionfromSample:s
                      withInitials:initials
                           inStore:testStore];
    
    NSString *newKey = @"Rock.002";
    
    LibraryObject *retrievedOriginalSample = [testStore getLibraryObjectForKey:originalKey
                                                                     FromTable:[SampleConstants tableName]];
    LibraryObject *retrievedNewSample = [testStore getLibraryObjectForKey:newKey
                                                                FromTable:[SampleConstants tableName]];
    
    NSString *newOriginalRecords = [[retrievedOriginalSample attributes] objectForKey:SMP_TAGS];
    NSString *newRecords = [[retrievedNewSample attributes] objectForKey:SMP_TAGS];
    
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
    Sample *s = [[Sample alloc] initWithKey:originalKey
                          AndWithAttributes:[SampleConstants attributeNames]
                                  AndValues:[SampleConstants attributeDefaultValues]];
    
    ProcedureRecord *proc1 = [[ProcedureRecord alloc] initWithTag:@"TAG01" andInitials:initials];
    ProcedureRecord *proc2 = [[ProcedureRecord alloc] initWithTag:@"TAG02" andInitials:initials];
    
    NSString *originalRecords = [NSString stringWithFormat:@"%@%@%@", proc1, TAG_DELIMITER, proc2];
    
    NSArray *originalRecordArray = [ProcedureRecordParser procedureRecordArrayFromList:originalRecords];
    
    [s.attributes setValue:originalRecords forKey:SMP_TAGS];
    [testStore putLibraryObject:s IntoTable:[SampleConstants tableName]];
    
    [Procedures pulverizeSample:s
                  withInitials:initials
                       inStore:testStore];
    
    LibraryObject *retrievedSample = [testStore getLibraryObjectForKey:originalKey
                                                             FromTable:[SampleConstants tableName]];
    
    NSString *newRecords = [[retrievedSample attributes] objectForKey:SMP_TAGS];
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
    Sample *s = [[Sample alloc] initWithKey:originalKey
                          AndWithAttributes:[SampleConstants attributeNames]
                                  AndValues:[SampleConstants attributeDefaultValues]];
    
    ProcedureRecord *proc1 = [[ProcedureRecord alloc] initWithTag:@"TAG01" andInitials:initials];
    ProcedureRecord *proc2 = [[ProcedureRecord alloc] initWithTag:@"TAG02" andInitials:initials];
    
    NSString *originalRecords = [NSString stringWithFormat:@"%@%@%@", proc1, TAG_DELIMITER, proc2];
    
    NSArray *originalRecordArray = [ProcedureRecordParser procedureRecordArrayFromList:originalRecords];
    
    [s.attributes setValue:originalRecords forKey:SMP_TAGS];
    [testStore putLibraryObject:s IntoTable:[SampleConstants tableName]];
    
    [Procedures trimSample:s
                   withInitials:initials
                        inStore:testStore];
    
    LibraryObject *retrievedSample = [testStore getLibraryObjectForKey:originalKey
                                                             FromTable:[SampleConstants tableName]];
    
    NSString *newRecords = [[retrievedSample attributes] objectForKey:SMP_TAGS];
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
    Sample *s = [[Sample alloc] initWithKey:originalKey
                          AndWithAttributes:[SampleConstants attributeNames]
                                  AndValues:[SampleConstants attributeDefaultValues]];
    
    ProcedureRecord *proc1 = [[ProcedureRecord alloc] initWithTag:@"TAG01" andInitials:initials];
    ProcedureRecord *proc2 = [[ProcedureRecord alloc] initWithTag:@"TAG02" andInitials:initials];
    
    NSString *originalRecords = [NSString stringWithFormat:@"%@%@%@", proc1, TAG_DELIMITER, proc2];
    
    NSArray *originalRecordArray = [ProcedureRecordParser procedureRecordArrayFromList:originalRecords];
    
    [s.attributes setValue:originalRecords forKey:SMP_TAGS];
    [testStore putLibraryObject:s IntoTable:[SampleConstants tableName]];
    
    [Procedures geminiSample:s
                             withInitials:initials
                                  inStore:testStore];
    
    NSString *newKey = @"Rock.002";
    
    LibraryObject *retrievedOriginalSample = [testStore getLibraryObjectForKey:originalKey
                                                                     FromTable:[SampleConstants tableName]];
    LibraryObject *retrievedNewSample = [testStore getLibraryObjectForKey:newKey
                                                                FromTable:[SampleConstants tableName]];
    
    NSString *newOriginalRecords = [[retrievedOriginalSample attributes] objectForKey:SMP_TAGS];
    NSString *newRecords = [[retrievedNewSample attributes] objectForKey:SMP_TAGS];
    
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
    Sample *s = [[Sample alloc] initWithKey:originalKey
                          AndWithAttributes:[SampleConstants attributeNames]
                                  AndValues:[SampleConstants attributeDefaultValues]];
    
    ProcedureRecord *proc1 = [[ProcedureRecord alloc] initWithTag:@"TAG01" andInitials:initials];
    ProcedureRecord *proc2 = [[ProcedureRecord alloc] initWithTag:@"TAG02" andInitials:initials];
    
    NSString *originalRecords = [NSString stringWithFormat:@"%@%@%@", proc1, TAG_DELIMITER, proc2];
    
    NSArray *originalRecordArray = [ProcedureRecordParser procedureRecordArrayFromList:originalRecords];
    
    [s.attributes setValue:originalRecords forKey:SMP_TAGS];
    [testStore putLibraryObject:s IntoTable:[SampleConstants tableName]];
    
    [Procedures panSample:s
                withInitials:initials
                     inStore:testStore];
    
    NSString *newKey = @"Rock.002";
    
    LibraryObject *retrievedOriginalSample = [testStore getLibraryObjectForKey:originalKey
                                                                     FromTable:[SampleConstants tableName]];
    LibraryObject *retrievedNewSample = [testStore getLibraryObjectForKey:newKey
                                                                FromTable:[SampleConstants tableName]];
    
    NSString *newOriginalRecords = [[retrievedOriginalSample attributes] objectForKey:SMP_TAGS];
    NSString *newRecords = [[retrievedNewSample attributes] objectForKey:SMP_TAGS];
    
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
    Sample *s = [[Sample alloc] initWithKey:originalKey
                          AndWithAttributes:[SampleConstants attributeNames]
                                  AndValues:[SampleConstants attributeDefaultValues]];
    
    ProcedureRecord *proc1 = [[ProcedureRecord alloc] initWithTag:@"TAG01" andInitials:initials];
    ProcedureRecord *proc2 = [[ProcedureRecord alloc] initWithTag:@"TAG02" andInitials:initials];
    
    NSString *originalRecords = [NSString stringWithFormat:@"%@%@%@", proc1, TAG_DELIMITER, proc2];
    
    NSArray *originalRecordArray = [ProcedureRecordParser procedureRecordArrayFromList:originalRecords];
    
    [s.attributes setValue:originalRecords forKey:SMP_TAGS];
    [testStore putLibraryObject:s IntoTable:[SampleConstants tableName]];
    
    [Procedures sievesTenSample:s
                withInitials:initials
                     inStore:testStore];
    
    NSString *newKey = @"Rock.002";
    
    LibraryObject *retrievedOriginalSample = [testStore getLibraryObjectForKey:originalKey
                                                                     FromTable:[SampleConstants tableName]];
    LibraryObject *retrievedNewSample = [testStore getLibraryObjectForKey:newKey
                                                                FromTable:[SampleConstants tableName]];
    
    NSString *newOriginalRecords = [[retrievedOriginalSample attributes] objectForKey:SMP_TAGS];
    NSString *newRecords = [[retrievedNewSample attributes] objectForKey:SMP_TAGS];
    
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
    Sample *s = [[Sample alloc] initWithKey:originalKey
                          AndWithAttributes:[SampleConstants attributeNames]
                                  AndValues:[SampleConstants attributeDefaultValues]];
    
    ProcedureRecord *proc1 = [[ProcedureRecord alloc] initWithTag:@"TAG01" andInitials:initials];
    ProcedureRecord *proc2 = [[ProcedureRecord alloc] initWithTag:@"TAG02" andInitials:initials];
    
    NSString *originalRecords = [NSString stringWithFormat:@"%@%@%@", proc1, TAG_DELIMITER, proc2];
    
    NSArray *originalRecordArray = [ProcedureRecordParser procedureRecordArrayFromList:originalRecords];
    
    [s.attributes setValue:originalRecords forKey:SMP_TAGS];
    [testStore putLibraryObject:s IntoTable:[SampleConstants tableName]];
    
    [Procedures heavyLiquid_330_Sample:s
                          withInitials:initials
                               inStore:testStore];
    
    NSString *newKey = @"Rock.002";
    
    LibraryObject *retrievedOriginalSample = [testStore getLibraryObjectForKey:originalKey
                                                                     FromTable:[SampleConstants tableName]];
    LibraryObject *retrievedNewSample = [testStore getLibraryObjectForKey:newKey
                                                                FromTable:[SampleConstants tableName]];
    
    NSString *newOriginalRecords = [[retrievedOriginalSample attributes] objectForKey:SMP_TAGS];
    NSString *newRecords = [[retrievedNewSample attributes] objectForKey:SMP_TAGS];
    
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
    Sample *s = [[Sample alloc] initWithKey:originalKey
                          AndWithAttributes:[SampleConstants attributeNames]
                                  AndValues:[SampleConstants attributeDefaultValues]];
    
    ProcedureRecord *proc1 = [[ProcedureRecord alloc] initWithTag:@"TAG01" andInitials:initials];
    ProcedureRecord *proc2 = [[ProcedureRecord alloc] initWithTag:@"TAG02" andInitials:initials];
    
    NSString *originalRecords = [NSString stringWithFormat:@"%@%@%@", proc1, TAG_DELIMITER, proc2];
    
    NSArray *originalRecordArray = [ProcedureRecordParser procedureRecordArrayFromList:originalRecords];
    
    [s.attributes setValue:originalRecords forKey:SMP_TAGS];
    [testStore putLibraryObject:s IntoTable:[SampleConstants tableName]];
    
    [Procedures heavyLiquid_290_Sample:s
                          withInitials:initials
                               inStore:testStore];
    
    NSString *newKey = @"Rock.002";
    
    LibraryObject *retrievedOriginalSample = [testStore getLibraryObjectForKey:originalKey
                                                                     FromTable:[SampleConstants tableName]];
    LibraryObject *retrievedNewSample = [testStore getLibraryObjectForKey:newKey
                                                                FromTable:[SampleConstants tableName]];
    
    NSString *newOriginalRecords = [[retrievedOriginalSample attributes] objectForKey:SMP_TAGS];
    NSString *newRecords = [[retrievedNewSample attributes] objectForKey:SMP_TAGS];
    
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
    Sample *s = [[Sample alloc] initWithKey:originalKey
                          AndWithAttributes:[SampleConstants attributeNames]
                                  AndValues:[SampleConstants attributeDefaultValues]];
    
    ProcedureRecord *proc1 = [[ProcedureRecord alloc] initWithTag:@"TAG01" andInitials:initials];
    ProcedureRecord *proc2 = [[ProcedureRecord alloc] initWithTag:@"TAG02" andInitials:initials];
    
    NSString *originalRecords = [NSString stringWithFormat:@"%@%@%@", proc1, TAG_DELIMITER, proc2];
    
    NSArray *originalRecordArray = [ProcedureRecordParser procedureRecordArrayFromList:originalRecords];
    
    [s.attributes setValue:originalRecords forKey:SMP_TAGS];
    [testStore putLibraryObject:s IntoTable:[SampleConstants tableName]];
    
    [Procedures heavyLiquid_265_Sample:s
                          withInitials:initials
                               inStore:testStore];
    
    NSString *newKey = @"Rock.002";
    
    LibraryObject *retrievedOriginalSample = [testStore getLibraryObjectForKey:originalKey
                                                                     FromTable:[SampleConstants tableName]];
    LibraryObject *retrievedNewSample = [testStore getLibraryObjectForKey:newKey
                                                                FromTable:[SampleConstants tableName]];
    
    NSString *newOriginalRecords = [[retrievedOriginalSample attributes] objectForKey:SMP_TAGS];
    NSString *newRecords = [[retrievedNewSample attributes] objectForKey:SMP_TAGS];
    
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
    Sample *s = [[Sample alloc] initWithKey:originalKey
                          AndWithAttributes:[SampleConstants attributeNames]
                                  AndValues:[SampleConstants attributeDefaultValues]];
    
    ProcedureRecord *proc1 = [[ProcedureRecord alloc] initWithTag:@"TAG01" andInitials:initials];
    ProcedureRecord *proc2 = [[ProcedureRecord alloc] initWithTag:@"TAG02" andInitials:initials];
    
    NSString *originalRecords = [NSString stringWithFormat:@"%@%@%@", proc1, TAG_DELIMITER, proc2];
    
    NSArray *originalRecordArray = [ProcedureRecordParser procedureRecordArrayFromList:originalRecords];
    
    [s.attributes setValue:originalRecords forKey:SMP_TAGS];
    [testStore putLibraryObject:s IntoTable:[SampleConstants tableName]];
    
    [Procedures heavyLiquid_255_Sample:s
                          withInitials:initials
                               inStore:testStore];
    
    NSString *newKey = @"Rock.002";
    
    LibraryObject *retrievedOriginalSample = [testStore getLibraryObjectForKey:originalKey
                                                                     FromTable:[SampleConstants tableName]];
    LibraryObject *retrievedNewSample = [testStore getLibraryObjectForKey:newKey
                                                                FromTable:[SampleConstants tableName]];
    
    NSString *newOriginalRecords = [[retrievedOriginalSample attributes] objectForKey:SMP_TAGS];
    NSString *newRecords = [[retrievedNewSample attributes] objectForKey:SMP_TAGS];
    
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
    Sample *s = [[Sample alloc] initWithKey:originalKey
                          AndWithAttributes:[SampleConstants attributeNames]
                                  AndValues:[SampleConstants attributeDefaultValues]];
    
    ProcedureRecord *proc1 = [[ProcedureRecord alloc] initWithTag:@"TAG01" andInitials:initials];
    ProcedureRecord *proc2 = [[ProcedureRecord alloc] initWithTag:@"TAG02" andInitials:initials];
    
    NSString *originalRecords = [NSString stringWithFormat:@"%@%@%@", proc1, TAG_DELIMITER, proc2];
    
    NSArray *originalRecordArray = [ProcedureRecordParser procedureRecordArrayFromList:originalRecords];
    
    [s.attributes setValue:originalRecords forKey:SMP_TAGS];
    [testStore putLibraryObject:s IntoTable:[SampleConstants tableName]];
    
    [Procedures handMagnetSample:s
                          withInitials:initials
                               inStore:testStore];
    
    NSString *newKey = @"Rock.002";
    
    LibraryObject *retrievedOriginalSample = [testStore getLibraryObjectForKey:originalKey
                                                                     FromTable:[SampleConstants tableName]];
    LibraryObject *retrievedNewSample = [testStore getLibraryObjectForKey:newKey
                                                                FromTable:[SampleConstants tableName]];
    
    NSString *newOriginalRecords = [[retrievedOriginalSample attributes] objectForKey:SMP_TAGS];
    NSString *newRecords = [[retrievedNewSample attributes] objectForKey:SMP_TAGS];
    
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
    Sample *s = [[Sample alloc] initWithKey:originalKey
                          AndWithAttributes:[SampleConstants attributeNames]
                                  AndValues:[SampleConstants attributeDefaultValues]];
    
    ProcedureRecord *proc1 = [[ProcedureRecord alloc] initWithTag:@"TAG01" andInitials:initials];
    ProcedureRecord *proc2 = [[ProcedureRecord alloc] initWithTag:@"TAG02" andInitials:initials];
    
    NSString *originalRecords = [NSString stringWithFormat:@"%@%@%@", proc1, TAG_DELIMITER, proc2];
    
    NSArray *originalRecordArray = [ProcedureRecordParser procedureRecordArrayFromList:originalRecords];
    
    [s.attributes setValue:originalRecords forKey:SMP_TAGS];
    [testStore putLibraryObject:s IntoTable:[SampleConstants tableName]];
    
    [Procedures magnet02AmpsSample:s
                          withInitials:initials
                               inStore:testStore];
    
    NSString *newKey = @"Rock.002";
    
    LibraryObject *retrievedOriginalSample = [testStore getLibraryObjectForKey:originalKey
                                                                     FromTable:[SampleConstants tableName]];
    LibraryObject *retrievedNewSample = [testStore getLibraryObjectForKey:newKey
                                                                FromTable:[SampleConstants tableName]];
    
    NSString *newOriginalRecords = [[retrievedOriginalSample attributes] objectForKey:SMP_TAGS];
    NSString *newRecords = [[retrievedNewSample attributes] objectForKey:SMP_TAGS];
    
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
    Sample *s = [[Sample alloc] initWithKey:originalKey
                          AndWithAttributes:[SampleConstants attributeNames]
                                  AndValues:[SampleConstants attributeDefaultValues]];
    
    ProcedureRecord *proc1 = [[ProcedureRecord alloc] initWithTag:@"TAG01" andInitials:initials];
    ProcedureRecord *proc2 = [[ProcedureRecord alloc] initWithTag:@"TAG02" andInitials:initials];
    
    NSString *originalRecords = [NSString stringWithFormat:@"%@%@%@", proc1, TAG_DELIMITER, proc2];
    
    NSArray *originalRecordArray = [ProcedureRecordParser procedureRecordArrayFromList:originalRecords];
    
    [s.attributes setValue:originalRecords forKey:SMP_TAGS];
    [testStore putLibraryObject:s IntoTable:[SampleConstants tableName]];
    
    [Procedures magnet04AmpsSample:s
                      withInitials:initials
                           inStore:testStore];
    
    NSString *newKey = @"Rock.002";
    
    LibraryObject *retrievedOriginalSample = [testStore getLibraryObjectForKey:originalKey
                                                                     FromTable:[SampleConstants tableName]];
    LibraryObject *retrievedNewSample = [testStore getLibraryObjectForKey:newKey
                                                                FromTable:[SampleConstants tableName]];
    
    NSString *newOriginalRecords = [[retrievedOriginalSample attributes] objectForKey:SMP_TAGS];
    NSString *newRecords = [[retrievedNewSample attributes] objectForKey:SMP_TAGS];
    
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
    Sample *s = [[Sample alloc] initWithKey:originalKey
                          AndWithAttributes:[SampleConstants attributeNames]
                                  AndValues:[SampleConstants attributeDefaultValues]];
    
    ProcedureRecord *proc1 = [[ProcedureRecord alloc] initWithTag:@"TAG01" andInitials:initials];
    ProcedureRecord *proc2 = [[ProcedureRecord alloc] initWithTag:@"TAG02" andInitials:initials];
    
    NSString *originalRecords = [NSString stringWithFormat:@"%@%@%@", proc1, TAG_DELIMITER, proc2];
    
    NSArray *originalRecordArray = [ProcedureRecordParser procedureRecordArrayFromList:originalRecords];
    
    [s.attributes setValue:originalRecords forKey:SMP_TAGS];
    [testStore putLibraryObject:s IntoTable:[SampleConstants tableName]];
    
    [Procedures magnet06AmpsSample:s
                      withInitials:initials
                           inStore:testStore];
    
    NSString *newKey = @"Rock.002";
    
    LibraryObject *retrievedOriginalSample = [testStore getLibraryObjectForKey:originalKey
                                                                     FromTable:[SampleConstants tableName]];
    LibraryObject *retrievedNewSample = [testStore getLibraryObjectForKey:newKey
                                                                FromTable:[SampleConstants tableName]];
    
    NSString *newOriginalRecords = [[retrievedOriginalSample attributes] objectForKey:SMP_TAGS];
    NSString *newRecords = [[retrievedNewSample attributes] objectForKey:SMP_TAGS];
    
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
    Sample *s = [[Sample alloc] initWithKey:originalKey
                          AndWithAttributes:[SampleConstants attributeNames]
                                  AndValues:[SampleConstants attributeDefaultValues]];
    
    ProcedureRecord *proc1 = [[ProcedureRecord alloc] initWithTag:@"TAG01" andInitials:initials];
    ProcedureRecord *proc2 = [[ProcedureRecord alloc] initWithTag:@"TAG02" andInitials:initials];
    
    NSString *originalRecords = [NSString stringWithFormat:@"%@%@%@", proc1, TAG_DELIMITER, proc2];
    
    NSArray *originalRecordArray = [ProcedureRecordParser procedureRecordArrayFromList:originalRecords];
    
    [s.attributes setValue:originalRecords forKey:SMP_TAGS];
    [testStore putLibraryObject:s IntoTable:[SampleConstants tableName]];
    
    [Procedures magnet08AmpsSample:s
                      withInitials:initials
                           inStore:testStore];
    
    NSString *newKey = @"Rock.002";
    
    LibraryObject *retrievedOriginalSample = [testStore getLibraryObjectForKey:originalKey
                                                                     FromTable:[SampleConstants tableName]];
    LibraryObject *retrievedNewSample = [testStore getLibraryObjectForKey:newKey
                                                                FromTable:[SampleConstants tableName]];
    
    NSString *newOriginalRecords = [[retrievedOriginalSample attributes] objectForKey:SMP_TAGS];
    NSString *newRecords = [[retrievedNewSample attributes] objectForKey:SMP_TAGS];
    
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
    Sample *s = [[Sample alloc] initWithKey:originalKey
                          AndWithAttributes:[SampleConstants attributeNames]
                                  AndValues:[SampleConstants attributeDefaultValues]];
    
    ProcedureRecord *proc1 = [[ProcedureRecord alloc] initWithTag:@"TAG01" andInitials:initials];
    ProcedureRecord *proc2 = [[ProcedureRecord alloc] initWithTag:@"TAG02" andInitials:initials];
    
    NSString *originalRecords = [NSString stringWithFormat:@"%@%@%@", proc1, TAG_DELIMITER, proc2];
    
    NSArray *originalRecordArray = [ProcedureRecordParser procedureRecordArrayFromList:originalRecords];
    
    [s.attributes setValue:originalRecords forKey:SMP_TAGS];
    [testStore putLibraryObject:s IntoTable:[SampleConstants tableName]];
    
    [Procedures magnet10AmpsSample:s
                      withInitials:initials
                           inStore:testStore];
    
    NSString *newKey = @"Rock.002";
    
    LibraryObject *retrievedOriginalSample = [testStore getLibraryObjectForKey:originalKey
                                                                     FromTable:[SampleConstants tableName]];
    LibraryObject *retrievedNewSample = [testStore getLibraryObjectForKey:newKey
                                                                FromTable:[SampleConstants tableName]];
    
    NSString *newOriginalRecords = [[retrievedOriginalSample attributes] objectForKey:SMP_TAGS];
    NSString *newRecords = [[retrievedNewSample attributes] objectForKey:SMP_TAGS];
    
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
    Sample *s = [[Sample alloc] initWithKey:originalKey
                          AndWithAttributes:[SampleConstants attributeNames]
                                  AndValues:[SampleConstants attributeDefaultValues]];
    
    ProcedureRecord *proc1 = [[ProcedureRecord alloc] initWithTag:@"TAG01" andInitials:initials];
    ProcedureRecord *proc2 = [[ProcedureRecord alloc] initWithTag:@"TAG02" andInitials:initials];
    
    NSString *originalRecords = [NSString stringWithFormat:@"%@%@%@", proc1, TAG_DELIMITER, proc2];
    
    NSArray *originalRecordArray = [ProcedureRecordParser procedureRecordArrayFromList:originalRecords];
    
    [s.attributes setValue:originalRecords forKey:SMP_TAGS];
    [testStore putLibraryObject:s IntoTable:[SampleConstants tableName]];
    
    [Procedures magnet12AmpsSample:s
                      withInitials:initials
                           inStore:testStore];
    
    NSString *newKey = @"Rock.002";
    
    LibraryObject *retrievedOriginalSample = [testStore getLibraryObjectForKey:originalKey
                                                                     FromTable:[SampleConstants tableName]];
    LibraryObject *retrievedNewSample = [testStore getLibraryObjectForKey:newKey
                                                                FromTable:[SampleConstants tableName]];
    
    NSString *newOriginalRecords = [[retrievedOriginalSample attributes] objectForKey:SMP_TAGS];
    NSString *newRecords = [[retrievedNewSample attributes] objectForKey:SMP_TAGS];
    
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
    Sample *s = [[Sample alloc] initWithKey:originalKey
                          AndWithAttributes:[SampleConstants attributeNames]
                                  AndValues:[SampleConstants attributeDefaultValues]];
    
    ProcedureRecord *proc1 = [[ProcedureRecord alloc] initWithTag:@"TAG01" andInitials:initials];
    ProcedureRecord *proc2 = [[ProcedureRecord alloc] initWithTag:@"TAG02" andInitials:initials];
    
    NSString *originalRecords = [NSString stringWithFormat:@"%@%@%@", proc1, TAG_DELIMITER, proc2];
    
    NSArray *originalRecordArray = [ProcedureRecordParser procedureRecordArrayFromList:originalRecords];
    
    [s.attributes setValue:originalRecords forKey:SMP_TAGS];
    [testStore putLibraryObject:s IntoTable:[SampleConstants tableName]];
    
    [Procedures magnet14AmpsSample:s
                      withInitials:initials
                           inStore:testStore];
    
    NSString *newKey = @"Rock.002";
    
    LibraryObject *retrievedOriginalSample = [testStore getLibraryObjectForKey:originalKey
                                                                     FromTable:[SampleConstants tableName]];
    LibraryObject *retrievedNewSample = [testStore getLibraryObjectForKey:newKey
                                                                FromTable:[SampleConstants tableName]];
    
    NSString *newOriginalRecords = [[retrievedOriginalSample attributes] objectForKey:SMP_TAGS];
    NSString *newRecords = [[retrievedNewSample attributes] objectForKey:SMP_TAGS];
    
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
