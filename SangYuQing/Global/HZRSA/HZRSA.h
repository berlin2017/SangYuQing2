//
//  HZRSA.h
//  AnhuiNews
//
//  Created by History on 15/7/22.
//  Copyright (c) 2015年 ahxmt. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface HZRSA : NSObject

- (instancetype)initWithPublicKeyPath:(NSString *)publicKeyPath;
+ (instancetype)rsa;
- (NSData *) encryptWithData:(NSData *)content;
- (NSData *) encryptWithString:(NSString *)content;
- (NSString *) encryptToString:(NSString *)content;

@end
