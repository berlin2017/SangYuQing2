//
//  JPModel.m
//  SangYuQing
//
//  Created by mac on 2018/1/14.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "JPModel.h"

@implementation JPModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"jipin_id": @"jipin_id",
             @"name": @"name",
             @"image": @"image",
             @"jifen": @"jifen",
             @"expired": @"expired",
             };
}

+ (NSValueTransformer *)jipin_idJSONTransformer
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
@end
