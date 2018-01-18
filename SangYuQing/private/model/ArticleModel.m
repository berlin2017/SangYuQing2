//
//  ArticleModel.m
//  SangYuQing
//
//  Created by mac on 2018/1/14.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "ArticleModel.h"

@implementation ArticleModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"user_id": @"user_id",
             @"szjw_id": @"szjw_id",
             @"sz_id": @"sz_id",
             @"jiwen_title": @"jiwen_title",
             @"jiwen_type": @"jiwen_type",
             @"liulan_count": @"liulan_count",
             @"state": @"state",
             @"create_time": @"create_time",
             @"update_time": @"update_time",
             @"head_logo": @"head_logo",
             @"username": @"username",
             @"nickname": @"nickname",
             @"jiwen_body": @"jiwen_body",
             };
}

+ (NSValueTransformer *)user_idJSONTransformer
{
    return [MTLValueTransformer numberTransformer];
}
+ (NSValueTransformer *)szjw_idJSONTransformer
{
    return [MTLValueTransformer numberTransformer];
}
+ (NSValueTransformer *)sz_idJSONTransformer
{
    return [MTLValueTransformer numberTransformer];
}
+ (NSValueTransformer *)jiwen_typeJSONTransformer
{
    return [MTLValueTransformer numberTransformer];
}
+ (NSValueTransformer *)liulan_countJSONTransformer
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
+ (NSValueTransformer *)update_timeJSONTransformer
{
    return [MTLValueTransformer numberTransformer];
}
@end
