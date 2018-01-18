//
//  HZRSA.m
//  AnhuiNews
//
//  Created by History on 15/7/22.
//  Copyright (c) 2015年 ahxmt. All rights reserved.
//

#import "HZRSA.h"

@interface HZRSA ()
{
    SecKeyRef _publicKeyRef;
    SecCertificateRef _certificateRef;
    SecPolicyRef _policyRef;
    SecTrustRef _trustRef;
    size_t _maxPlainLength;
}
@end

@implementation HZRSA

+ (instancetype)rsa
{
    NSString *keyPath = [[NSBundle mainBundle] pathForResource:@"public_key" ofType:@"der"];
    HZRSA *rsa = [[HZRSA alloc] initWithPublicKeyPath:keyPath];
    return rsa;
}
- (id)initWithPublicKeyPath:(NSString *)publicKeyPath
{
    self = [super init];
    
    if (!publicKeyPath.length) {
        HZLog(@"Can not find pub.der");
        return nil;
    }
    
    NSData *publicKeyDate = [[NSData alloc] initWithContentsOfFile:publicKeyPath];
    if (!publicKeyDate) {
        HZLog(@"Can not read from pub.der");
        return nil;
    }
    _certificateRef = SecCertificateCreateWithData(kCFAllocatorDefault, ( __bridge CFDataRef)publicKeyDate);
    if (!_certificateRef) {
        HZLog(@"Can not read certificate from pub.der");
        return nil;
    }
    
    _policyRef = SecPolicyCreateBasicX509();
    OSStatus returnCode = SecTrustCreateWithCertificates(_certificateRef, _policyRef, &_trustRef);
    if (returnCode) {
        HZLog(@"SecTrustCreateWithCertificates fail. Error Code: %@", @(returnCode));
        return nil;
    }
    
    SecTrustResultType trustResultType;
    returnCode = SecTrustEvaluate(_trustRef, &trustResultType);
    if (returnCode) {
        HZLog(@"SecTrustEvaluate fail. Error Code: %@", @(returnCode));
        return nil;
    }
    
    _publicKeyRef = SecTrustCopyPublicKey(_trustRef);
    if (!_publicKeyRef) {
        HZLog(@"SecTrustCopyPublicKey fail");
        return nil;
    }
    
    _maxPlainLength = SecKeyGetBlockSize(_publicKeyRef) - 12;
    return self;
}

- (NSData *) encryptWithData:(NSData *)content {
    
    size_t plainLength = [content length];
    if (plainLength > _maxPlainLength) {
        HZLog(@"content(%@) is too long, must < %@", @(plainLength), @(_maxPlainLength));
        return nil;
    }
    
    void *plain = malloc(plainLength);
    [content getBytes:plain
               length:plainLength];
    
    size_t cipherLen = 128; // 目前使用的RSA加密長度為1024bits(即128bytes)
    void *cipher = malloc(cipherLen);
    
    OSStatus returnCode = SecKeyEncrypt(_publicKeyRef, kSecPaddingPKCS1, plain,
                                        plainLength, cipher, &cipherLen);
    
    NSData *result = nil;
    if (returnCode) {
        HZLog(@"SecKeyEncrypt fail. Error Code: %@", @(returnCode));
    }
    else {
        result = [NSData dataWithBytes:cipher length:cipherLen];
    }
    
    free(plain);
    free(cipher);
    
    return result;
}

- (NSData *) encryptWithString:(NSString *)content
{
    return [self encryptWithData:[content dataUsingEncoding:NSUTF8StringEncoding]];
}

- (NSString *) encryptToString:(NSString *)content
{
    NSData *data = [self encryptWithString:content];
    return [self base64forData:data];
}

// convert NSData to NSString
- (NSString *)base64forData:(NSData *)data
{
#if 1
    NSString *encodeString = [data base64EncodedStringWithOptions:NSDataBase64EncodingEndLineWithLineFeed];
    return encodeString;
#else
    const uint8_t* input = (const uint8_t*)[theData bytes];
    NSInteger length = [theData length];
    
    static char table[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=";
    
    NSMutableData* data = [NSMutableData dataWithLength:((length + 2) / 3) * 4];
    uint8_t* output = (uint8_t*)data.mutableBytes;
    
    NSInteger i;
    for (i=0; i < length; i += 3) {
        NSInteger value = 0;
        NSInteger j;
        for (j = i; j < (i + 3); j++) {
            value <<= 8;
            
            if (j < length) {
                value |= (0xFF & input[j]);
            }
        }
        
        NSInteger theIndex = (i / 3) * 4;
        output[theIndex + 0] =                    table[(value >> 18) & 0x3F];
        output[theIndex + 1] =                    table[(value >> 12) & 0x3F];
        output[theIndex + 2] = (i + 1) < length ? table[(value >> 6)  & 0x3F] : '=';
        output[theIndex + 3] = (i + 2) < length ? table[(value >> 0)  & 0x3F] : '=';
    }
    
    return [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
#endif
}

- (void)dealloc
{
    CFRelease(_certificateRef);
    CFRelease(_trustRef);
    CFRelease(_policyRef);
    CFRelease(_publicKeyRef);
}

@end
