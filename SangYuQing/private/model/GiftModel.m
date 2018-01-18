//
//  GiftModel.m
//  SangYuQing
//
//  Created by mac on 2018/1/11.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "GiftModel.h"

@implementation GiftModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"jipin_id": @"jipin_id",
             @"jc_id": @"jc_id",
             @"name": @"name",
             @"image": @"image",
             @"jifen": @"jifen",
             @"expired": @"expired",
             @"use_range": @"use_range",
             @"state": @"state",
             };
}

+ (NSValueTransformer *)jipin_idJSONTransformer
{
    return [MTLValueTransformer numberTransformer];
}
+ (NSValueTransformer *)jc_idJSONTransformer
{
    return [MTLValueTransformer numberTransformer];
}
+ (NSValueTransformer *)jifenJSONTransformer
{
    return [MTLValueTransformer numberTransformer];
}
+ (NSValueTransformer *)expiredJSONTransformer
{
    return [MTLValueTransformer numberTransformer];
}
+ (NSValueTransformer *)stateJSONTransformer
{
    return [MTLValueTransformer numberTransformer];
}

@end
