//
//  LocalEncryptedCredentialsProvider.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 4/12/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "LocalEncryptedCredentialsProvider.h"
#import "AmazonCredentialsEncodable.h"
#import "CredentialsEncryption.h"
#import "PCBLogWrapper.h"

#define filename @"credentials"

@implementation LocalEncryptedCredentialsProvider

@synthesize filepath;
@synthesize localKey;

- (instancetype)init
{
    self = [super init];
    if (self) {
        // Set the default filepath.
        NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) firstObject];
        filepath = [documentsDirectory stringByAppendingPathComponent:filename];
    }
    return self;
}

-(AmazonCredentials *)credentials
{
    return [self retrieveCredentialsWithKey:localKey];
}

-(void)refresh {
    [self credentials];
}

-(BOOL)credentialsStoreFileExists
{
    return [[NSFileManager defaultManager] fileExistsAtPath:filepath];
}

/// Stores credentials in the local storage location,
/// encrypted with the provided key.
-(BOOL)storeCredentials:(AmazonCredentials *)credentials
                withKey:(NSString *)key
{
    // Store the localKey
    localKey = key;

    const AmazonCredentialsEncodable *encodableCredentials = [[AmazonCredentialsEncodable alloc] initFromAmazonCredentials:credentials];
    const NSData *credentialsAsData = [NSKeyedArchiver archivedDataWithRootObject:encodableCredentials];

    // Encrypt the data
    const NSData *encryptedData = [CredentialsEncryption encryptData:credentialsAsData WithKey:localKey];
    BOOL writeSuccess = [encryptedData writeToFile:filepath
                                       atomically:YES];
    return writeSuccess;
}

/// Retrieve keys from the local storage location.
-(AmazonCredentials *)retrieveCredentialsWithKey:(NSString *)key
{
    if (![self credentialsStoreFileExists] || key == nil) {
        return [[AmazonCredentials alloc] initWithAccessKey:@"dummy"
                                              withSecretKey:@"dummy"];
    }

    localKey = key;
    const NSData *dataFromFile = [NSData dataWithContentsOfFile:filepath];

    // Decrypt the data
    NSData *decryptedData = [CredentialsEncryption decryptData:dataFromFile WithKey:localKey];

    AmazonCredentials *returnedCredentials;

    @try {
        AmazonCredentialsEncodable *decodedCredentials = [NSKeyedUnarchiver unarchiveObjectWithData:decryptedData];
        returnedCredentials = [decodedCredentials asAmazonCredentials];
    }
    @catch (NSException *exception) {
        // Some issue is encountered when trying to decode the credentials.
        // Most likely this is because the user entered the wrong local key.
        returnedCredentials = nil;
    }
    @finally {
        return returnedCredentials;
    }
}

+(LocalEncryptedCredentialsProvider *)sharedInstance {
    static LocalEncryptedCredentialsProvider *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    return sharedInstance;
}

@end