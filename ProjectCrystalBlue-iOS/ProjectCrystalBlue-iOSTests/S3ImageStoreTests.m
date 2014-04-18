//
//  S3ImageStoreTests.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 1/25/14.
//  Copyright (c) 2014 Logan Hood. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AbstractMobileCloudImageStore.h"
#import "LocalImageStore.h"
#import "LocalEncryptedCredentialsProvider.h"
#import "S3ImageStore.h"

#define IMAGE_DIRECTORY @"project-crystal-blue-test-temp"
#define DIRTY_KEY_FILE_NAME @"dirty_s3_image_keys.txt" // make sure this matches the filename in S3ImageStore

@interface S3ImageStoreTests : XCTestCase

@end

@implementation S3ImageStoreTests
/* IMPORTANT: If these unit tests are failing due to AWS exceptions, it is probably because
 * credentials aren't available. Try running the application and entering your credentials with a
 * local passcode "1234", then re-running the tests. */

- (void)setUp
{
    // Sets the local passcode to 1234
    [[LocalEncryptedCredentialsProvider sharedInstance] setLocalKey:@"1234"];
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

/// Verify that default image can be retrieved
- (void)testDefaultImage
{
    XCTAssertNotNil([S3ImageStore defaultImage]);
}

/** Verify that the S3ImageStore will retrieve a local image before trying S3.
 *  This test should succeed even while offline.
 */
- (void)testRetrieveLocalImage
{
    AbstractMobileCloudImageStore *s3ImageStore = [[S3ImageStore alloc] initWithLocalDirectory:IMAGE_DIRECTORY];
    AbstractMobileImageStore *localStore = [[LocalImageStore alloc] initWithLocalDirectory:IMAGE_DIRECTORY];
    
    NSString *testFile = @"UNIT_TEST_UPLOAD_IMAGE_16x16";
    NSString *path = [[NSBundle bundleForClass:self.class] pathForResource:testFile ofType:@"jpg"];
    UIImage *testImage = [[UIImage alloc] initWithContentsOfFile:path];
    
    NSString *testKey = [[[NSUUID alloc] init] UUIDString];
    [localStore putImage:testImage forKey:testKey];
    
    // Since the image is now stored locally, the s3ImageStore should be able to retrieve it without contacting S3.
    UIImage *retrieved = [s3ImageStore getImageForKey:testKey];
    XCTAssertNotNil(retrieved, @"Retrieved image was nil.");
    XCTAssertTrue([retrieved size].height == [testImage size].height);
    XCTAssertTrue([retrieved size].width  == [testImage size].width);
}

/// Verify that a default image is retrieved for an image that does not exist.
- (void)testNonexistantImageReturnsDefaultImage
{
    AbstractMobileCloudImageStore *imageStore = [[S3ImageStore alloc] initWithLocalDirectory:IMAGE_DIRECTORY];
    NSString *nonexistantImage = @"NO-ONE-USE-THIS-AS-A-KEY-PLEASE";
    
    XCTAssertFalse([imageStore imageExistsForKey:nonexistantImage]);

    UIImage *resultDefaultImage = [imageStore getImageForKey:nonexistantImage];
    XCTAssertNotNil(resultDefaultImage);
}

/** Verify that we can successfully upload an image to S3.
 *  Then, check that if we download it, we get the right image back.
 */
- (void)testUploadImage
{
    AbstractMobileCloudImageStore *s3imageStore = [[S3ImageStore alloc] initWithLocalDirectory:IMAGE_DIRECTORY];
    AbstractMobileImageStore *localImageStore = [[LocalImageStore alloc] initWithLocalDirectory:IMAGE_DIRECTORY];
    
    NSString *testFile = @"UNIT_TEST_UPLOAD_IMAGE_16x16";
    NSString *path = [[NSBundle bundleForClass:self.class] pathForResource:testFile ofType:@"jpg"];
    UIImage *imageToUpload = [[UIImage alloc] initWithContentsOfFile:path];
    XCTAssertNotNil(imageToUpload, @"Upload test image seems to have been lost!");
    
    // Generate a random key for upload
    NSString *key = [[[[NSUUID alloc] init] UUIDString] stringByAppendingString:@".jpg"];
    XCTAssertFalse([s3imageStore imageExistsForKey:key]);

    // Perform the upload
    BOOL uploadSuccess = [s3imageStore putImage:imageToUpload forKey:key];
    XCTAssertTrue(uploadSuccess, @"S3ImageStore indicated that the upload was unsuccessful.");
    
    // Make sure that it's correctly stored locally
    XCTAssertTrue([localImageStore imageExistsForKey:key]);
    XCTAssertTrue([s3imageStore imageExistsForKey:key]);
    UIImage *localImage = [localImageStore getImageForKey:key];
    XCTAssertNotNil(localImage, @"Local image was nil");
    XCTAssertEqual([localImage size].width, [imageToUpload size].width);
    XCTAssertEqual([localImage size].height, [imageToUpload size].height);
    
    // Delete the local version to force the ImageStore to get the S3 version.
    [localImageStore deleteImageWithKey:key];
    XCTAssertFalse([localImageStore imageExistsForKey:key]);
    
    // Now that we've uploaded the image, let's check that we can get it back from S3.
    UIImage *retrievedImage = [s3imageStore getImageForKey:key];
    XCTAssertNotNil(retrievedImage, @"Image retrieved back from S3 was nil");
    XCTAssertEqual([retrievedImage size].width, [imageToUpload size].width);
    XCTAssertEqual([retrievedImage size].height, [imageToUpload size].height);
    
    // Retrieving the image from S3 should automatically create a local version again.
    localImage = [localImageStore getImageForKey:key];
    XCTAssertNotNil(localImage, @"Local image was nil");
    XCTAssertEqual([localImage size].width, [imageToUpload size].width);
    XCTAssertEqual([localImage size].height, [imageToUpload size].height);
    
    // Finally, delete the image to clean up.
    BOOL deleteSuccess = [s3imageStore deleteImageWithKey:key];
    XCTAssertTrue(deleteSuccess, @"S3ImageStore indicated that deletion was unsuccessful.");
    
    // Check that the image stored locally is deleted too.
    XCTAssertFalse([localImageStore imageExistsForKey:key]);
}

/**
 *  Simulates a scenario where some images have been created while offline and added to a dirty key set.
 *  Then we call the Sync function and verify that they get uploaded to S3.
 */
- (void)testSyncFunction
{
    int NUMBER_OF_IMAGES_TO_TEST = 3; // don't set this too high since this test actually hits S3 and uses bandwidth
    
    AbstractMobileImageStore *localImageStore = [[LocalImageStore alloc] initWithLocalDirectory:IMAGE_DIRECTORY];
    LocalTransactionCache *dirtyImageKeyStore = [[LocalTransactionCache alloc] initInDirectory:IMAGE_DIRECTORY
                                                                                  withFileName:DIRTY_KEY_FILE_NAME];
    
    NSString *testFile = @"UNIT_TEST_UPLOAD_IMAGE_16x16";
    NSString *path = [[NSBundle bundleForClass:self.class] pathForResource:testFile ofType:@"jpg"];
    UIImage *image = [[UIImage alloc] initWithContentsOfFile:path];

    NSMutableSet *testKeySet = [[NSMutableSet alloc] init];
    for (int i = 0; i < NUMBER_OF_IMAGES_TO_TEST; ++i) {
        NSString *key = [[[[NSUUID alloc] init] UUIDString] stringByAppendingString:@".jpg"];
        [testKeySet addObject:key];
        [localImageStore putImage:image forKey:key];
        [dirtyImageKeyStore add:key];
    }
    
    XCTAssertEqual([dirtyImageKeyStore count], (unsigned long)NUMBER_OF_IMAGES_TO_TEST);
    
    // Now that we've set up the scenario, we can clear our instances and initialize the s3 client.
    dirtyImageKeyStore = nil;
    localImageStore = nil;
    AbstractMobileCloudImageStore *s3 = [[S3ImageStore alloc] initWithLocalDirectory:IMAGE_DIRECTORY];
    
    // The keys should be marked as dirty.
    for (NSString *key in testKeySet) {
        XCTAssertTrue([s3 keyIsDirty:key]);
    }
    
    // Do the sync
    BOOL syncSuccess = [s3 synchronizeWithCloud];
    XCTAssertTrue(syncSuccess);
    
    // The keys should no longer be marked as dirty.
    for (NSString *key in testKeySet) {
        XCTAssertFalse([s3 keyIsDirty:key]);
    }
    
    // Cleanup - delete images from S3 and locally
    for (NSString *key in testKeySet) {
        BOOL deleteSuccess = [s3 deleteImageWithKey:key];
        XCTAssertTrue(deleteSuccess, @"S3ImageStore indicated that deletion was unsuccessful.");
    }
    
    [s3 flushLocalImageData];
}

@end
