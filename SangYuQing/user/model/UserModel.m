//
//  UserModel.m
//  SangYuQing
//
//  Created by mac on 2018/1/12.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"user_id": @"user_id",
             @"username": @"username",
             @"mobile": @"mobile",
             @"email": @"email",
             @"nickname": @"nickname",
             @"bonus_point": @"bonus_point",
             @"qq": @"qq",
             @"account_name": @"account_name",
             @"sex": @"sex",
             @"head_logo": @"head_logo",
             @"live_address": @"live_address",
             @"household_address": @"household_address",
             @"live_province_id": @"live_province_id",
             @"live_city_id": @"live_city_id",
             @"household_province_id": @"household_province_id",
             @"household_city_id": @"household_city_id",
             @"user_state": @"user_state",
             @"password": @"password",
             @"allow_state": @"allow_state",
             @"admin_id": @"admin_id",
             @"last_login_time": @"last_login_time",
             @"register_time": @"register_time",
             };
}

+ (NSValueTransformer *)user_idJSONTransformer
{
    return [MTLValueTransformer numberTransformer];
}
+ (NSValueTransformer *)bonus_pointJSONTransformer
{
    return [MTLValueTransformer numberTransformer];
}
+ (NSValueTransformer *)sexJSONTransformer
{
    return [MTLValueTransformer numberTransformer];
}
+ (NSValueTransformer *)live_province_idJSONTransformer
{
    return [MTLValueTransformer numberTransformer];
}

+ (NSValueTransformer *)live_city_idJSONTransformer
{
    return [MTLValueTransformer numberTransformer];
}
+ (NSValueTransformer *)household_province_idJSONTransformer
{
    return [MTLValueTransformer numberTransformer];
}
+ (NSValueTransformer *)household_city_idJSONTransformer
{
    return [MTLValueTransformer numberTransformer];
}
+ (NSValueTransformer *)user_stateJSONTransformer
{
    return [MTLValueTransformer numberTransformer];
}

+ (NSValueTransformer *)allow_stateJSONTransformer
{
    return [MTLValueTransformer numberTransformer];
}
+ (NSValueTransformer *)admin_idJSONTransformer
{
    return [MTLValueTransformer numberTransformer];
}
+ (NSValueTransformer *)last_login_timeJSONTransformer
{
    return [MTLValueTransformer numberTransformer];
}
+ (NSValueTransformer *)register_timeJSONTransformer
{
    return [MTLValueTransformer numberTransformer];
}

@end
