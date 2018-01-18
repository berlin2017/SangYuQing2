//
//  NSError+Helper.m
//  AnhuiNews
//
//  Created by History on 10/23/15.
//  Copyright © 2015 ahxmt. All rights reserved.
//

#import "NSError+Helper.h"

NSString * const kHZErrorDomain                     = @"com.ahn.error";

@implementation NSError (Helper)
+ (NSError *)networkingError
{
    return
    [NSError customErrorWithCode:5000 localizedDescription:@"您当前无网络,请设置您的网络"];
}

+ (NSError *)jsonParseError
{
    return
    [NSError customErrorWithCode:3840 localizedDescription:@"解析数据失败,工程师正在努力解决"];
}

+ (NSError *)serviceError
{
    return
    [NSError customErrorWithCode:5001 localizedDescription:@"服务器开小差了,请稍等"];
}

+ (NSError *)appExceptionError
{
    return
    [NSError customErrorWithCode:5002 localizedDescription:@"一些奇怪的事情发生了,请稍后重试"];
}

+ (NSError *)customErrorWithCode:(NSInteger)code localizedDescription:(NSString *)description
{
    NSError *error = [NSError errorWithDomain:kHZErrorDomain code:code userInfo:@{
                                                                                  NSLocalizedDescriptionKey: description
                                                                                  }];
    return error;
}

@end
