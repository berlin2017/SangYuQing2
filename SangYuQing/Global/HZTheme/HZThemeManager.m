//
//  HZTheme.m
//  AnhuiNews
//
//  Created by History on 15/8/28.
//  Copyright (c) 2015年 ahxmt. All rights reserved.
//

#import "HZThemeManager.h"

typedef NS_ENUM(NSUInteger, HZThemeStyle) {
    HZThemeStyleDefault = 0,
    HZThemeStyleNight,
};

@interface HZThemeManager ()
@property (assign, nonatomic) HZThemeStyle style;
@property (strong, nonatomic) NSDictionary *themeMap;
@end

@implementation HZThemeManager
- (instancetype)init
{
    self = [super init];
    if (self) {
        _style = [HZPreference integerForKey:@"com.ahn.theme.style"];
        NSString *fileName = @"theme_default";
        switch (_style) {
            case HZThemeStyleDefault: {
                fileName = @"theme_default";
                break;
            }
            case HZThemeStyleNight: {
                fileName = @"theme_night";
                break;
            }
            default: {
                break;
            }
        }
        _themeMap = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:fileName ofType:@"plist"]];
    }
    return self;
}
+ (instancetype)share
{
    static HZThemeManager * instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!instance) {
            instance = [[HZThemeManager alloc] init];
        }
    });
    return instance;
}
+ (UIColor *)globalMainColor
{
    return [UIColor colorWithHexString:[[HZThemeManager share].themeMap valueForKey:@"global.main.color"]];
}
+ (UIColor *)navigationHighlightedBackgroundColor
{
    return [UIColor colorWithHexString:[[HZThemeManager share].themeMap valueForKey:@"navigation.highlighted.background.color"]];
}
+ (UIColor *)navigationHighlightedTextColor
{
    return [UIColor colorWithHexString:[[HZThemeManager share].themeMap valueForKey:@"navigation.highlighted.text.color"]];
}
+ (UIColor *)navigationNormalBackgroundColor
{
    return [UIColor colorWithHexString:[[HZThemeManager share].themeMap valueForKey:@"navigation.normal.background.color"]];
}
+ (UIColor *)navigationNormalTextColor
{
    return [self globalMainColor];
}
+ (UIColor *)pageControlHighlightedColor
{
    return [self globalMainColor];
}
+ (UIColor *)pageControlNormalColor
{
    return [UIColor colorWithHexString:[[HZThemeManager share].themeMap valueForKey:@"page.control.normal.color"]];
}
+ (UIColor *)borderColor
{
    return [UIColor lightGrayColor];
}

+ (UIFont *)pageControlNormalFont
{
    return [UIFont systemFontOfSize:[[[HZThemeManager share].themeMap valueForKey:@"page.control.normal.font"] integerValue]];
}
+ (UIFont *)pageControlHighlightedFont
{
    return [UIFont systemFontOfSize:[[[HZThemeManager share].themeMap valueForKey:@"page.control.highlighted.font"] integerValue]];
}
@end
