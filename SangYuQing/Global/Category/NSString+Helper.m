//
//  NSString+Helper.m
//  AnhuiNews
//
//  Created by History on 15/9/11.
//  Copyright © 2015年 ahxmt. All rights reserved.
//

#import "NSString+Helper.h"
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>
#import "HZHelper.h"

@implementation NSString (Helper)
- (BOOL)isValidPhoneNumber
{
    NSString *regex = @"^1\\d{10}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    if ([predicate evaluateWithObject:self]) {
        return YES;
    }
    else {
        return NO;
    }
}

- (BOOL)isValidUserName
{
    NSString *regex = @"^[a-zA-Z0-9_]{6,12}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    NSString *allNumberRegex = @"^\\d+$";
    NSPredicate *allNumberPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", allNumberRegex];
    if ([predicate evaluateWithObject:self] && ![allNumberPredicate evaluateWithObject:self]) {
        return YES;
    }
    else {
        return NO;
    }
}

- (BOOL)isValidPassword
{
    NSString *regex = @"^[a-zA-Z0-9!@#$%^&*()_+=-]{6,18}$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    if ([predicate evaluateWithObject:self]) {
        return YES;
    }
    else {
        return NO;
    }
}

- (NSString *)BASE64_HMAC_SHA1EncryptWithPrivateKey:(NSString *)key
{
    NSData* privateData = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSData* publicData = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    const void* privateBytes = [privateData bytes];
    const void* publicBytes = [publicData bytes];
    
    void* outs = malloc(CC_SHA1_DIGEST_LENGTH);
    
    CCHmac(kCCHmacAlgSHA1, privateBytes, [privateData length], publicBytes, [publicData length], outs);
    
    NSData* signatureData = [NSData dataWithBytesNoCopy:outs length:CC_SHA1_DIGEST_LENGTH freeWhenDone:YES];
    
    NSString *string = [signatureData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    HZLog(@"%@", string);
    return string;
}

- (NSString *)BASE64_HMAC_SHA256EncryptWithPrivateKey:(NSString *)key
{
    NSData* privateData = [key dataUsingEncoding:NSUTF8StringEncoding];
    NSData* publicData = [self dataUsingEncoding:NSUTF8StringEncoding];
    
    const void* privateBytes = [privateData bytes];
    const void* publicBytes = [publicData bytes];
    
    void* outs = malloc(CC_SHA256_DIGEST_LENGTH);
    
    CCHmac(kCCHmacAlgSHA256, privateBytes, [privateData length], publicBytes, [publicData length], outs);
    
    NSData* signatureData = [NSData dataWithBytesNoCopy:outs length:CC_SHA256_DIGEST_LENGTH freeWhenDone:YES];
    NSString *string = [signatureData base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    HZLog(@"%@", string);
    return string;
}

- (NSString *)verifyValueForParam:(NSDictionary *)param
{
    NSArray *allKeys = [param allKeys];
    allKeys =
    [allKeys sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        NSComparisonResult result = [obj2 compare:obj1];
        return result;
    }];
    NSString *lastKey = [allKeys lastObject];
    NSString *publicString = [NSString stringWithFormat:@"%@=%@|app_version=%@", lastKey, param[lastKey], [HZHelper appVersion]];
    NSString *privateString = [publicString md5];
    return privateString;
}
+ (BOOL)isEmptyString:(NSString *)string
{
    if (!string || !string.length) {
        return YES;
    }
    return NO;
}
- (BOOL)isValidEmail
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

+ (NSString *)stringForUUID
{
    CFUUIDRef uuidObj    = CFUUIDCreate(nil);
    NSString *uuidString = (NSString *)CFBridgingRelease(CFUUIDCreateString(nil, uuidObj));
    CFRelease(uuidObj);
    return uuidString;
}

- (NSString *)stringByUTF8Encode
{
    return
    (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(
                                                                          NULL,
                                                                          (__bridge CFStringRef)self,
                                                                          NULL,
                                                                          CFSTR("!*'();:@&=+$,/?%#[]\" "),
                                                                          kCFStringEncodingUTF8
                                                                          )
                                  );
}
- (NSString *)stringByUTF8Decode
{
    return
    (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapes(
                                                                             NULL,
                                                                             (__bridge CFStringRef)self,
                                                                             CFSTR("")
                                                                             )
                                  );
    
}

- (NSString *)md5
{
    const char *cStr = [self UTF8String];
    unsigned char result[16];
    CC_MD5(cStr, (CC_LONG)strlen(cStr), result);
    return [NSString stringWithFormat:
            @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x",
            result[0], result[1], result[2], result[3],
            result[4], result[5], result[6], result[7],
            result[8], result[9], result[10], result[11],
            result[12], result[13], result[14], result[15]
            ];
}

- (NSString *)sha1
{
    const char *cstr = [self UTF8String];
    NSData *data = [NSData dataWithBytes:cstr length:self.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, (CC_LONG)data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++) {
        [output appendFormat:@"%02x", digest[i]];
    }
    return output;
    
}

- (NSDictionary *)queryDictionary
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    NSArray *components = [self componentsSeparatedByString:@"&"];
    for (NSString *keyValueString in components) {
        NSArray *keyValueArray = [keyValueString componentsSeparatedByString:@"="];
        if (2 == keyValueArray.count) {
            [dictionary setObject:keyValueArray[1] forKey:keyValueArray[0]];
        }
    }
    if (dictionary.count) {
        return dictionary;
    }
    else {
        return nil;
    }
}

- (NSString *)replaceHTMLEntities
{
    NSString *sourceString = self;
    sourceString = [sourceString stringByReplacingOccurrencesOfString:@"&nbsp;" withString:@" "];
    sourceString = [sourceString stringByReplacingOccurrencesOfString:@"&quot;" withString:@"\""];
    sourceString = [sourceString stringByReplacingOccurrencesOfString:@"&lt;" withString:@"<"];
    sourceString = [sourceString stringByReplacingOccurrencesOfString:@"&gt;" withString:@">"];
    sourceString = [sourceString stringByReplacingOccurrencesOfString:@"&#160;" withString:@" "];
    sourceString = [sourceString stringByReplacingOccurrencesOfString:@"&#183;" withString:@"·"];
    return sourceString;
}

- (NSString *)spelling
{
    return [self spellingWithSpace:NO];
}

- (NSString *)spellingWithSpace:(BOOL)space
{
    if (self.length) {
        NSMutableString *copy = [self mutableCopy];
        CFStringTransform((__bridge CFMutableStringRef)copy, NULL, kCFStringTransformMandarinLatin, NO);
        CFStringTransform((__bridge CFMutableStringRef)copy, NULL, kCFStringTransformStripDiacritics, NO);
        if (!space) {
            [copy replaceOccurrencesOfString:@" " withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, copy.length)];
        }
        return copy;
    }
    else {
        return nil;
    }
}

- (NSString *)spellingInitial
{
    if (self.length) {
        NSMutableString *copy = [self mutableCopy];
        CFStringTransform((__bridge CFMutableStringRef)copy, NULL, kCFStringTransformMandarinLatin, NO);
        CFStringTransform((__bridge CFMutableStringRef)copy, NULL, kCFStringTransformStripDiacritics, NO);
        NSArray *array = [copy componentsSeparatedByString:@" "];
        NSMutableString *initial = [NSMutableString string];
        for (NSString *subSpelling in array) {
            [initial appendString:[subSpelling substringToIndex:1]];
        }
        return initial;
    }
    else {
        return nil;
    }
}

@end
