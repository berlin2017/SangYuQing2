  //
//  MTLValueTransformer+Helper.m
//  AnhuiNews
//
//  Created by History on 15/9/11.
//  Copyright © 2015年 ahxmt. All rights reserved.
//

#import "MTLValueTransformer+Helper.h"

#define kDateFormatter  @"yyyy-MM-dd HH:mm:ss"

@implementation MTLValueTransformer (Helper)
+ (NSValueTransformer *)boolTransformer
{
    return [NSValueTransformer mtl_valueMappingTransformerWithDictionary:@{@"yes": @(YES),
                                                                           @"no": @(NO)}
                                                            defaultValue:@(NO) reverseDefaultValue:@"no"];
}
+ (NSValueTransformer *)timeTransformer
{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(NSString *time, BOOL *success, NSError *__autoreleasing *error) {
        NSDate *date = [NSDate dateWithString:time formatString:kDateFormatter];
        return date;
    }
                                                reverseBlock:^id(NSDate *date, BOOL *success, NSError *__autoreleasing *error) {
                                                    return [date formattedDateWithFormat:kDateFormatter];
                                                }];
}

+ (NSValueTransformer *)numberTransformer
{
    return [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        return value;
    } reverseBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
        return value;
    }];
}

@end
