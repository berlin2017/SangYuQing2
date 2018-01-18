//
//  JiFenDetailModel.m
//  SangYuQing
//
//  Created by mac on 2018/1/16.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "JiFenDetailModel.h"

@implementation JiFenDetailModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"order_numer": @"order_numer",
             @"type": @"type",
             @"point_value": @"point_value",
             @"add_time": @"add_time",
             @"remark": @"remark",
             @"price": @"price",
             @"payment_type": @"payment_type",
             };
}
@end
