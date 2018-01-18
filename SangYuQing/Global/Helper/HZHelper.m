//
//  HZHelper.m
//  AnhuiNews
//
//  Created by History on 10/23/15.
//  Copyright © 2015 ahxmt. All rights reserved.
//

#import "HZHelper.h"

@implementation HZHelper

@end

@implementation HZHelper (AppConfig)

+ (NSString *)appBundleIdentifier
{
    NSString *identifier = [[NSBundle mainBundle] bundleIdentifier];
    return identifier;
}

+ (NSString *)appVersion
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    return infoDictionary[@"CFBundleShortVersionString"];
}

+ (NSString *)appBuildVerion
{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    return infoDictionary[@"CFBundleVersion"];
}
@end