//
//  HZTheme.h
//  AnhuiNews
//
//  Created by History on 15/8/28.
//  Copyright (c) 2015年 ahxmt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HZThemeManager : NSObject
// Color
/**
 *  主色调
 */
+ (UIColor *)globalMainColor;
+ (UIColor *)navigationHighlightedBackgroundColor;
+ (UIColor *)navigationHighlightedTextColor;
+ (UIColor *)navigationNormalBackgroundColor;
+ (UIColor *)navigationNormalTextColor;
+ (UIColor *)pageControlHighlightedColor;
+ (UIColor *)pageControlNormalColor;
+ (UIColor *)borderColor;
// Font
+ (UIFont *)pageControlNormalFont;
+ (UIFont *)pageControlHighlightedFont;
@end
