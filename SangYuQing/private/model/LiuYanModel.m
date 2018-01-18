//
//  LiuYanModel.m
//  SangYuQing
//
//  Created by mac on 2018/1/10.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "LiuYanModel.h"

@implementation LiuYanModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"user_id": @"user_id",
             @"szly_id": @"szly_id",
             @"sz_id": @"sz_id",
             @"content": @"content",
             @"type": @"type",
             @"showname": @"showname",
             @"state": @"state",
             @"create_time": @"create_time",
             @"head_logo": @"head_logo",
             @"username": @"username",
             @"nickname": @"nickname",
             };
}

+ (NSValueTransformer *)user_idJSONTransformer
{
    return [MTLValueTransformer numberTransformer];
}
+ (NSValueTransformer *)szly_idJSONTransformer
{
    return [MTLValueTransformer numberTransformer];
}
+ (NSValueTransformer *)sz_idJSONTransformer
{
    return [MTLValueTransformer numberTransformer];
}
+ (NSValueTransformer *)typeJSONTransformer
{
    return [MTLValueTransformer numberTransformer];
}
+ (NSValueTransformer *)shownameJSONTransformer
{
    return [MTLValueTransformer numberTransformer];
}
+ (NSValueTransformer *)stateJSONTransformer
{
    return [MTLValueTransformer numberTransformer];
}
+ (NSValueTransformer *)create_timeJSONTransformer
{
    return [MTLValueTransformer numberTransformer];
}
@end
