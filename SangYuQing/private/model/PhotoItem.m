//
//  PhotoItem.m
//  SangYuQing
//
//  Created by mac on 2018/1/14.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "PhotoItem.h"

@implementation PhotoItem

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"szxcp_id": @"szxcp_id",
             @"szxc_id": @"szxc_id",
             @"name": @"name",
             @"image": @"image",
             };
}


@end
