//
//  VideoModel.m
//  SangYuQing
//
//  Created by mac on 2018/1/14.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "VideoModel.h"

@implementation VideoModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"video": @"video",
             @"image": @"image",
             @"sz_id": @"sz_id",
             @"name": @"name",
             @"szv_id": @"szv_id",
             };
}

@end
