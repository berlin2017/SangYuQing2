//
//  PhotoModel.m
//  SangYuQing
//
//  Created by mac on 2018/1/10.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "PhotoModel.h"

@implementation PhotoModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"szxc_id": @"szxc_id",
             @"user_id": @"user_id",
             @"sz_id": @"sz_id",
             @"name": @"name",
             @"image": @"image",
             @"type": @"type",
             @"state": @"state",
             @"create_time": @"create_time",
             };
}

+ (NSValueTransformer *)user_idJSONTransformer
{
    return [MTLValueTransformer numberTransformer];
}
+ (NSValueTransformer *)szxc_idJSONTransformer
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
+ (NSValueTransformer *)stateJSONTransformer
{
    return [MTLValueTransformer numberTransformer];
}
+ (NSValueTransformer *)create_timeJSONTransformer
{
    return [MTLValueTransformer numberTransformer];
}
@end
