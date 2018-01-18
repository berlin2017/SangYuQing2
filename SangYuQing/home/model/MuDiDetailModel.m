//
//  MuDiDetailModel.m
//  SangYuQing
//
//  Created by mac on 2018/1/11.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "MuDiDetailModel.h"
#import "ArticleModel.h"
#import "LiuYanModel.h"
#import "PhotoModel.h"
#import "VideoModel.h"

@implementation MuDiDetailModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"account_name": @"account_name",
             @"create_time": @"create_time",
             @"sz_name": @"sz_name",
             @"sz_avatar": @"sz_avatar",
             @"cemetery_id": @"cemetery_id",
             @"sz_id": @"sz_id",
             @"user_id": @"user_id",
             @"jibai_count": @"jibai_count",
             @"liulan_count": @"liulan_count",
             @"total_jifen": @"total_jifen",
             @"birthdate": @"birthdate",
             @"deathdate": @"deathdate",
             @"mubei": @"mubei",
             @"beijing": @"beijing",
             @"follow": @"follow",
             @"articles":@"articles",
             @"albums":@"albums",
             @"videos":@"videos",
             };
}

+ (NSValueTransformer *)followJSONTransformer
{
    return [MTLValueTransformer numberTransformer];
}

+ (NSValueTransformer *)articlesJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[ArticleModel class]];
}

+ (NSValueTransformer *)albumsJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[PhotoModel class]];
}

+ (NSValueTransformer *)videosJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[VideoModel class]];
}


@end
