//
//  OrderInfo.m
//  SangYuQing
//
//  Created by mac on 2018/1/16.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "OrderInfo.h"

@implementation OrderInfo

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"trade_no": @"trade_no",
             @"pay_type": @"pay_type",
             @"money": @"money",
             @"prepay_id": @"prepay_id",
             @"nonce_str": @"nonce_str",
             @"package": @"package",
             @"timestamp": @"timestamp",
             @"sign": @"sign",
             @"orderString":@"orderString",
             };
}

+ (NSValueTransformer *)pay_typeJSONTransformer
{
    return [MTLValueTransformer numberTransformer];
}
+ (NSValueTransformer *)moneyJSONTransformer
{
    return [MTLValueTransformer numberTransformer];
}
+ (NSValueTransformer *)timestampJSONTransformer
{
    return [MTLValueTransformer numberTransformer];
}
@end
