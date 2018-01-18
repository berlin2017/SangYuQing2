//
//  HZNetClient.m
//  HZNetClient
//
//  Created by History on 15/8/22.
//  Copyright (c) 2015年 History. All rights reserved.
//

#import "HZHttpClient.h"

@implementation HZHttpClient

+ (instancetype)httpClient
{
    return [[[self class] alloc] initWithBaseURL:[NSURL URLWithString:@"http://m.anhuinews.com"]];
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"text/html", @"text/javascript", @"text/json", @"application/json", @"application/x-json", nil];
    }
    return self;
}

- (instancetype)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    if (self) {
        self.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/plain", @"text/html", @"text/javascript", @"text/json", @"application/json", nil];
        
        [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    }
    return self;
}

- (NSURLSessionDataTask *)hcGET:(NSString *)URLString parameters:(id)parameters success:(HZNetClientSuccess)success failure:(HZNetClientFailure)failure
{
    HZLog(@"URL - [%@/%@]\nPRARM - [%@]", self.baseURL, URLString, parameters);
    self.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    return
    [self GET:URLString
   parameters:parameters
      success:^(NSURLSessionDataTask *task, id responseObject) {
          if (success) {
              success(task, responseObject);
          }
      }
      failure:^(NSURLSessionDataTask *task, NSError *error) {
          BOOL reachable = [AFNetworkReachabilityManager sharedManager].reachable;
          if (failure) {
              if (!reachable) {
                  failure(task, [NSError errorWithDomain:@"com.history.error" code:5000 userInfo:@{
                                                                                                   NSLocalizedDescriptionKey: @"当前没有网络"
                                                                                                   }]);
              }
              else if (3840 == error.code) {
                  failure(task, [NSError errorWithDomain:@"com.history.error" code:3840 userInfo:@{
                                                                                                   NSLocalizedDescriptionKey: @"解析JSON数据失败"
                                                                                                   }]);
              }
              else {
                  NSString *string = [[NSString alloc] initWithData:error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
                  HZLog(@"%@", string);
#ifdef DEBUG
                  failure(task, [NSError errorWithDomain:@"com.history.error" code:9000 userInfo:@{
                                                                                                   NSLocalizedDescriptionKey: string
                                                                                                   }]);
#else
                  failure(task, [NSError errorWithDomain:@"com.history.error" code:9000 userInfo:@{
                                                                                                   NSLocalizedDescriptionKey: @"发生未知错误"
                                                                                                   }]);
#endif
              }
          }
      }];
}
- (NSURLSessionDataTask *)hcPOST:(NSString *)URLString parameters:(id)parameters success:(HZNetClientSuccess)success failure:(HZNetClientFailure)failure
{
    HZLog(@"*********  *******  URL - [%@/%@]\nPRARM - [%@]", self.baseURL, URLString, parameters);
    self.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    return
    [self POST:URLString
    parameters:parameters
       success:^(NSURLSessionDataTask *task, id responseObject) {
           if (success) {
               success(task, responseObject);
           }
       }
       failure:^(NSURLSessionDataTask *task, NSError *error) {
           BOOL reachable = [AFNetworkReachabilityManager sharedManager].reachable;
           if (failure) {
               if (!reachable) {
                   failure(task, [NSError errorWithDomain:@"com.history.error" code:5000 userInfo:@{
                                                                                                    NSLocalizedDescriptionKey: @"当前没有网络"
                                                                                                    }]);
               }
               else if (3840 == error.code) {
                   failure(task, [NSError errorWithDomain:@"com.history.error" code:3840 userInfo:@{
                                                                                                    NSLocalizedDescriptionKey: @"解析JSON数据失败"
                                                                                                    }]);
               }
               else {
                   NSString *string = [[NSString alloc] initWithData:error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
                   HZLog(@"%@", string);
#ifdef DEBUG
                   failure(task, [NSError errorWithDomain:@"com.history.error" code:9000 userInfo:@{
                                                                                                    NSLocalizedDescriptionKey: string
                                                                                                    }]);
#else
                   failure(task, [NSError errorWithDomain:@"com.history.error" code:9000 userInfo:@{
                                                                                                    NSLocalizedDescriptionKey: @"发生未知错误"
                                                                                                    }]);
#endif
               }
           }
       }];
}

- (NSURLSessionDataTask *)hcDELETE:(NSString *)URLString parameters:(id)parameters success:(HZNetClientSuccess)success failure:(HZNetClientFailure)failure
{
    self.requestSerializer.stringEncoding = NSUTF8StringEncoding;
    return
    [self DELETE:URLString
      parameters:parameters
         success:^(NSURLSessionDataTask *task, id responseObject) {
             if (success) {
                 success(task, responseObject);
             }
         }
         failure:^(NSURLSessionDataTask *task, NSError *error) {
             BOOL reachable = [AFNetworkReachabilityManager sharedManager].reachable;
             if (failure) {
                 if (!reachable) {
                     failure(task, [NSError errorWithDomain:@"com.history.error" code:5000 userInfo:@{
                                                                                                      NSLocalizedDescriptionKey: @"当前没有网络"
                                                                                                      }]);
                 }
                 else if (3840 == error.code) {
                     failure(task, [NSError errorWithDomain:@"com.history.error" code:3840 userInfo:@{
                                                                                                      NSLocalizedDescriptionKey: @"解析JSON数据失败"
                                                                                                      }]);
                 }
                 else {
                     NSString *string = [[NSString alloc] initWithData:error.userInfo[AFNetworkingOperationFailingURLResponseDataErrorKey] encoding:CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)];
                     HZLog(@"%@", string);
#ifdef DEBUG
                     failure(task, [NSError errorWithDomain:@"com.history.error" code:9000 userInfo:@{
                                                                                                      NSLocalizedDescriptionKey: string
                                                                                                      }]);
#else
                     failure(task, [NSError errorWithDomain:@"com.history.error" code:9000 userInfo:@{
                                                                                                      NSLocalizedDescriptionKey: @"发生未知错误"
                                                                                                      }]);
#endif
                 }
             }
         }];
}

#pragma mark - Private
- (NSDictionary *)encryptionDictionary:(NSDictionary *)dictionary
{
    NSMutableDictionary *mutableCopyDictionary = [dictionary mutableCopy];
    NSArray *allKeys = [mutableCopyDictionary allKeys];
    allKeys =
    [allKeys sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        NSComparisonResult result = [obj2 compare:obj1];
        return result;
    }];
    
    NSMutableArray *allKeyValues = [NSMutableArray array];
    for (NSString *key in allKeys) {
        [allKeyValues addObject:[NSString stringWithFormat:@"%@=%@", key, dictionary[key]]];
    }
    
    NSString *jointString = [allKeyValues componentsJoinedByString:@"&"];
    NSString *privateString = [jointString BASE64_HMAC_SHA1EncryptWithPrivateKey:@"com.ahn.user.secret"];
    [mutableCopyDictionary setObject:privateString forKey:@"sign"];
    return mutableCopyDictionary;
}
- (NSString *)privateStringWithDictionary:(NSDictionary *)dictionary
{
    NSMutableDictionary *mutableCopyDictionary = [dictionary mutableCopy];
    NSArray *allKeys = [mutableCopyDictionary allKeys];
    allKeys =
    [allKeys sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
        NSComparisonResult result = [obj2 compare:obj1];
        return result;
    }];
    
    NSMutableArray *allKeyValues = [NSMutableArray array];
    for (NSString *key in allKeys) {
        [allKeyValues addObject:[NSString stringWithFormat:@"%@=%@", key, dictionary[key]]];
    }
    
    NSString *jointString = [allKeyValues componentsJoinedByString:@"&"];
    NSString *privateString = [jointString BASE64_HMAC_SHA1EncryptWithPrivateKey:@"com.ahn.user.secret"];
    return privateString;
}
@end
