//
//  CityModel.m
//  SangYuQing
//
//  Created by mac on 2018/1/18.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "CityModel.h"

@implementation CityModel
+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"city_id": @"id",
             @"name": @"name",
             @"pid": @"pid",
             };
}
@end
