//
//  BeiJingModel.m
//  SangYuQing
//
//  Created by mac on 2018/1/18.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "BeiJingModel.h"

@implementation BeiJingModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"background_id": @"background_id",
             @"image": @"image",
             @"jifen": @"jifen",
             @"type": @"type",
             @"goumai": @"goumai",
             @"default_type": @"default",
             @"image_url":@"image_url",
             };
}

+ (NSValueTransformer *)goumaiJSONTransformer
{
    return [MTLValueTransformer numberTransformer];
}

+ (NSValueTransformer *)default_typeJSONTransformer
{
    return [MTLValueTransformer numberTransformer];
}

@end
