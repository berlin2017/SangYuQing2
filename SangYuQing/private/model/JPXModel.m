//
//  JPXModel.m
//  SangYuQing
//
//  Created by mac on 2018/1/30.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "JPXModel.h"
#import "JPModel.h"
#import "JPUser.h"

@implementation JPXModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"szjpx_id": @"szjpx_id",
             @"is_show": @"is_show",
             @"expired_time": @"expired_time",
             @"jpx_type": @"jpx_type",
             @"userInfo":@"userInfo",
             @"jipinInfo": @"jipinInfo",
             };
}

+ (NSValueTransformer *)szjpx_idJSONTransformer
{
    return [MTLValueTransformer numberTransformer];
}
+ (NSValueTransformer *)expired_timeJSONTransformer
{
    return [MTLValueTransformer numberTransformer];
}
+ (NSValueTransformer *)jpx_typeJSONTransformer
{
    return [MTLValueTransformer numberTransformer];
}

+ (NSValueTransformer *)is_showJSONTransformer
{
    return [MTLValueTransformer numberTransformer];
}

+ (NSValueTransformer *)jipinInfoJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[JPModel class]];
}

+ (NSValueTransformer *)userInfoJSONTransformer
{
    return [MTLJSONAdapter dictionaryTransformerWithModelClass:[JPUser class]];
}
@end
