//
//  LocalImageStoreTests.m
//  ProjectCrystalBlue-iOS
//
//  Created by Logan Hood on 2/14/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "LocalImageStore.h"

#define IMAGE_DIRECTORY @"project-crystal-blue-test-temp"

@interface LocalImageStoreTests : XCTestCase

@end

@implementation LocalImageStoreTests

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

/// Verify that trying to retrieve a nonexistent image returns a nil object
- (void)testNonexistentImageReturnsNil
{
    AbstractMobileImageStore *imageStore = [[LocalImageStore alloc] initWithLocalDirectory:IMAGE_DIRECTORY];
    NSString *nonExistentImageKey = @"NO-ONE-USE-THIS-AS-AN-IMAGE-KEY-PLEASE";
    
    UIImage *retrievedImage = [imageStore getImageForKey:nonExistentImageKey];
    XCTAssertNil(retrievedImage, @"Image data should have been nil!");
}

- (void)testDeleteNonexistentFile
{
    AbstractMobileImageStore *imageStore = [[LocalImageStore alloc] initWithLocalDirectory:IMAGE_DIRECTORY];
    NSString *key = @"NO-ONE-USE-THIS-AS-AN-IMAGE-KEY-PLEASE";
    
    XCTAssertFalse([imageStore deleteImageWithKey:key],
                   @"Deletion should not have been successful for a non-existent file.");
}

/// Verify that we can successfully perform basic image tasks locally: PUT, GET, and DELETE an image
- (void)testSaveGetAndDeleteImage
{
    AbstractMobileImageStore *imageStore = [[LocalImageStore alloc] initWithLocalDirectory:IMAGE_DIRECTORY];
    
    NSString *testFile = @"big_test_image_4096-4096";
    NSString *path = [[NSBundle bundleForClass:self.class] pathForResource:testFile ofType:@"jpg"];
    UIImage *imageToSave = [[UIImage alloc] initWithContentsOfFile:path];
    XCTAssertNotNil(imageToSave, @"Local test image seems to have been lost!");
    
    // Generate a random key to use for the image
    NSString *key = [[[[NSUUID alloc] init] UUIDString] stringByAppendingString:@".jpg"];
    
    // No image with this key should exist. (Barring considerable statistical improbability)
    XCTAssertFalse([imageStore imageExistsForKey:key],
                   @"The LocalImageStore believes that an image already exists for this key.");
    
    // Perform the upload
    BOOL saveSuccess = [imageStore putImage:imageToSave forKey:key];
    XCTAssertTrue(saveSuccess, @"LocalImageStore indicated that the save was unsuccessful.");
    
    // Since an image exists for the key, we should now expect ImageForKey to return true
    XCTAssertTrue([imageStore imageExistsForKey:key],
                  @"LocalImageStore should know that an image does exist for the key.");
    
    // Let's check that we can get the correct image back.
    UIImage *retrievedImage = [imageStore getImageForKey:key];
    
    XCTAssertNotNil(retrievedImage, @"Image retrieved back from LocalImageStore was nil");
    XCTAssertTrue([retrievedImage size].height == [imageToSave size].height);
    XCTAssertTrue([retrievedImage size].width  == [imageToSave size].width);
    
    // Finally, delete the image to clean up.
    BOOL deleteSuccess = [imageStore deleteImageWithKey:key];
    XCTAssertTrue(deleteSuccess, @"LocalImageStore indicated that deletion was unsuccessful.");
    
    // Verify that the image is not present
    XCTAssertFalse([imageStore imageExistsForKey:key],
                   @"Delete image didn't work - the ImageStore thinks an image exists for the key.");
    XCTAssertNil([imageStore getImageForKey:key],
                 @"Delete image didn't work - the ImageStore returned non-nil image data.");
}

/// Make sure that the flushImageData method removes all items
- (void)testFlushLocalData
{
    int NUMBER_OF_IMAGES = 2;
    AbstractMobileImageStore *imageStore = [[LocalImageStore alloc]
                                        initWithLocalDirectory:[IMAGE_DIRECTORY stringByAppendingString:@"/flushTest"]];
    
    NSString *testFile = @"big_test_image_4096-4096";
    NSString *path = [[NSBundle bundleForClass:self.class] pathForResource:testFile ofType:@"jpg"];
    UIImage *imageToSave = [[UIImage alloc] initWithContentsOfFile:path];
    XCTAssertNotNil(imageToSave, @"Local test image seems to have been lost!");
    
    NSMutableArray *keys = [[NSMutableArray alloc] init];
    for (int i = 0; i < NUMBER_OF_IMAGES; ++i) {
        // Generate a random key to use for the image
        NSString *key = [[[[NSUUID alloc] init] UUIDString] stringByAppendingString:@".jpg"];
        [keys addObject:key];
        
        // No image with this key should exist. (Barring considerable statistical improbability)
        XCTAssertFalse([imageStore imageExistsForKey:key],
                       @"The LocalImageStore believes that an image already exists for this key.");
        
        // Save the image
        BOOL saveSuccess = [imageStore putImage:imageToSave forKey:key];
        XCTAssertTrue(saveSuccess, @"LocalImageStore indicated that the save was unsuccessful.");
    }
    
    [imageStore flushLocalImageData];
    
    for (NSString *key in keys) {
        XCTAssertFalse([imageStore imageExistsForKey:key], @"Image for key %@ still exists!", key);
    }
}


@end
