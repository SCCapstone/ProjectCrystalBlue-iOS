//
//  CredentialsEncryption.m
//  ProjectCrystalBlueOSX
//
//  Created by Logan Hood on 4/14/14.
//  Copyright (c) 2014 Project Crystal Blue. All rights reserved.
//

#import "CredentialsEncryption.h"
#import <Security/Security.h>

@implementation CredentialsEncryption

+ (NSData *)encryptData:(const NSData *)plaintextData
                WithKey:(const NSString *)key
{
    return [self.class applyOTPToData:plaintextData UsingKey:key Encrypting:YES];
}

+ (NSData *)decryptData:(const NSData *)encryptedData
                WithKey:(const NSString *)key
{
    return [self.class applyOTPToData:encryptedData UsingKey:key Encrypting:NO];
}

/// Helper method. inData is encrypted/decrypted with the key. Set the third parameter to YES for
/// encryption and NO for decryption.
+ (NSData *)applyOTPToData:(const NSData *)inData
                  UsingKey:(const NSString *)key
                Encrypting:(const bool)toEncrypt
{
    const unsigned long dataSizeBytes = inData.length * sizeof(unsigned char);
    unsigned char *dataBytes = malloc(dataSizeBytes);
    [inData getBytes:dataBytes length:dataSizeBytes];

    NSRange keyRange;
    keyRange.length = key.length;
    keyRange.location = 0;

    const unsigned long keySizeBytes = key.length * sizeof(unsigned char); /* using ASCII encoding, so 1 byte characters */
    unsigned char *keyBytes = malloc(keySizeBytes);
    [key getBytes:keyBytes
        maxLength:key.length
       usedLength:NULL
         encoding:NSASCIIStringEncoding
          options:NSStringEncodingConversionAllowLossy
            range:keyRange
   remainingRange:NULL];

    const short multiplier = (toEncrypt ? 1 : -1);
    for (int unsigned long i = 0; i < inData.length; ++i) {
        dataBytes[i] -= multiplier * keyBytes[i % keySizeBytes];
    }

    NSData *dataFromBytes = [NSData dataWithBytes:dataBytes length:dataSizeBytes];

    free(dataBytes);
    free(keyBytes);
    return dataFromBytes;
}

@end
