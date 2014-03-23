//
//  S3ImageStore.h
//  ProjectCrystalBlueOSX
//
//  Image store implementation using Amazon's Simple Storage Service (S3).
//
//  Created by Logan Hood on 1/25/14.
//  Copyright (c) 2014 Logan Hood. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AbstractMobileCloudImageStore.h"
#import <AWSS3/AWSS3.h>
#import "LocalTransactionCache.h"

@interface S3ImageStore : AbstractMobileCloudImageStore {
    AmazonS3Client *s3Client;
    AbstractMobileImageStore *localStore;
    LocalTransactionCache *dirtyKeys;
}

@end
