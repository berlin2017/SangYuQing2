//
//  JPUser.m
//  SangYuQing
//
//  Created by mac on 2018/1/17.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "JPUser.h"

@implementation JPUser

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"user_id": @"user_id",
             @"username": @"username",
             @"account_name": @"account_name",
             };
}

+ (NSValueTransformer *)user_idJSONTransformer
{
    return [MTLValueTransformer numberTransformer];
}
@end
