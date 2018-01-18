//
//  GiftCategoryModel.m
//  SangYuQing
//
//  Created by mac on 2018/1/14.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "GiftCategoryModel.h"
#import "GiftLanMuModel.h"

@implementation GiftCategoryModel

+ (NSDictionary *)JSONKeyPathsByPropertyKey
{
    return @{
             @"jc_id": @"jc_id",
             @"jc_pid": @"jc_pid",
             @"jc_name": @"jc_name",
             @"sub_cate": @"sub_cate",
             };
}

+ (NSValueTransformer *)sub_cateJSONTransformer
{
    return [MTLJSONAdapter arrayTransformerWithModelClass:[GiftLanMuModel class]];
}
@end
