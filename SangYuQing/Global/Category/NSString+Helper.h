//
//  NSString+Helper.h
//  AnhuiNews
//
//  Created by History on 15/9/11.
//  Copyright © 2015年 ahxmt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Helper)
- (BOOL)isValidPhoneNumber;
- (BOOL)isValidUserName;
- (BOOL)isValidPassword;
- (NSString *)BASE64_HMAC_SHA1EncryptWithPrivateKey:(NSString *)key;
- (NSString *)BASE64_HMAC_SHA256EncryptWithPrivateKey:(NSString *)key;
- (NSString *)verifyValueForParam:(NSDictionary *)param;
+ (BOOL)isEmptyString:(NSString *)string;
- (BOOL)isValidEmail;

+ (NSString *)stringForUUID;

- (NSString *)stringByUTF8Encode;
- (NSString *)stringByUTF8Decode;

- (NSString *)md5;
- (NSString*)sha1;

- (NSDictionary *)queryDictionary;

- (NSString *)replaceHTMLEntities;

/**
 *  汉字全拼
 *
 *  @return hanziquanpin
 */
- (NSString *)spelling;
/**
 *  汉字全拼
 *
 *  @param space 是否用空格分开
 *
 *  @return han zi quan pin
 */
- (NSString *)spellingWithSpace:(BOOL)space;
/**
 *  汉字首字母
 *
 *  @return hzszm
 */
- (NSString *)spellingInitial;
@end
