//
//  UIColor+Helper.h
//  AnhuiNews
//
//  Created by History on 10/23/15.
//  Copyright © 2015 ahxmt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Helper)
+ (UIColor *)colorWith255Red:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;
+ (UIColor *)colorWith255Red:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha;
+ (UIColor *)colorWithHexRGB:(u_int32_t)rgb;
+ (UIColor *)colorWithHexRGB:(u_int32_t)rgb alpha:(CGFloat)alpha;
+ (UIColor *)colorWithHexString:(NSString *)rgb;
+ (UIColor *)randomColor;
@end
