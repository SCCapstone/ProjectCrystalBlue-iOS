//
//  AbstractImageStoreTests.m
//  ProjectCrystalBlue-iOS
//
//  Created by Logan Hood on 2/14/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AbstractMobileCloudImageStore.h"
#import "AbstractMobileImageStore.h"

@interface AbstractImageStoreTests : XCTestCase

@end

@implementation AbstractImageStoreTests

- (void)setUp
{
    [super setUp];
    // Put setup code here; it will be run once, before the first test case.
}

- (void)tearDown
{
    // Put teardown code here; it will be run once, after the last test case.
    [super tearDown];
}

/// The no-arg init methods should not be allowed.
- (void)testNoArgInit
{
    XCTAssertThrows([[AbstractMobileImageStore alloc] init],
                    @"You should not be allowed to use no-arg init for AbstractImageStore!");
    
    XCTAssertThrows([[AbstractMobileCloudImageStore alloc] init],
                    @"You should not be allowed to use no-arg init for AbstractCloudImageStore!");
}

/// One should not be able to call any methods of the abstract classes.
- (void)testCallMethodsOfAbstractImageStore
{
    AbstractMobileImageStore *store = [[AbstractMobileImageStore alloc] initWithLocalDirectory:@""];
    
    XCTAssertThrows([store getImageForKey:@""], @"getImageForKey should have thrown an exception.");
    XCTAssertThrows([store deleteImageWithKey:@""], @"deleteImageForKey should have thrown an exception.");
    XCTAssertThrows([store imageExistsForKey:@""], @"imageExistsForKey should have thrown an exception.");
    XCTAssertThrows([store putImage:nil forKey:@""], @"putImageForKey should have thrown an exception.");
    XCTAssertThrows([store flushLocalImageData], @"flushLocalImageData should have thrown an exception.");
}

/// One should not be able to call any methods of the abstract classes.
- (void)testCallMethodsOfAbstractCloudImageStore
{
    AbstractMobileCloudImageStore *store = [[AbstractMobileCloudImageStore alloc] initWithLocalDirectory:@""];
    
    XCTAssertThrows([store getImageForKey:@""], @"getImageForKey should have thrown an exception.");
    XCTAssertThrows([store deleteImageWithKey:@""], @"deleteImageForKey should have thrown an exception.");
    XCTAssertThrows([store imageExistsForKey:@""], @"imageExistsForKey should have thrown an exception.");
    XCTAssertThrows([store putImage:nil forKey:@""], @"putImageForKey should have thrown an exception.");
    XCTAssertThrows([store flushLocalImageData], @"flushLocalImageData should have thrown an exception.");
    
    XCTAssertThrows([store synchronizeWithCloud], @"synchronizeWithCloud should have thrown an exception.");
    XCTAssertThrows([store keyIsDirty:@""], @"keyIsDirty should have thrown an exception.");
}

@end
