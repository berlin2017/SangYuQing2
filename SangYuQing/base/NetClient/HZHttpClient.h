//
//  HZNetClient.h
//  HZNetClient
//
//  Created by History on 15/8/22.
//  Copyright (c) 2015年 History. All rights reserved.
//

#import "AFNetworking.h"

typedef void (^HZNetClientSuccess)(NSURLSessionDataTask *task, id object);
typedef void (^HZNetClientFailure)(NSURLSessionDataTask *task, NSError *error);

@interface HZHttpClient : AFHTTPSessionManager

+ (instancetype)httpClient;

- (NSURLSessionDataTask *)hcGET:(NSString *)URLString parameters:(id)parameters success:(HZNetClientSuccess)success failure:(HZNetClientFailure)failure;
- (NSURLSessionDataTask *)hcPOST:(NSString *)URLString parameters:(id)parameters success:(HZNetClientSuccess)success failure:(HZNetClientFailure)failure;
- (NSURLSessionDataTask *)hcDELETE:(NSString *)URLString parameters:(id)parameters success:(HZNetClientSuccess)success failure:(HZNetClientFailure)failure;
- (NSDictionary *)encryptionDictionary:(NSDictionary *)dictionary;
- (NSString *)privateStringWithDictionary:(NSDictionary *)dictionary;
@end
