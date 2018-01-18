//
//  UIColor+Helper.m
//  AnhuiNews
//
//  Created by History on 10/23/15.
//  Copyright © 2015 ahxmt. All rights reserved.
//

#import "UIColor+Helper.h"

@implementation UIColor (Helper)
+ (UIColor *)colorWith255Red:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue
{
    return [UIColor colorWith255Red:red green:green blue:blue alpha:1.0];
}
+ (UIColor *)colorWith255Red:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue alpha:(CGFloat)alpha
{
    return [UIColor colorWithRed:red/255.0 green:green/255.0 blue:blue/255.0 alpha:alpha];
}
+ (UIColor *)colorWithHexRGB:(u_int32_t)rgb
{
    return [UIColor colorWithHexRGB:rgb alpha:1.0];
}
+ (UIColor *)colorWithHexRGB:(u_int32_t)rgb alpha:(CGFloat)alpha
{
    CGFloat red = (rgb & 0xff0000) >> 16;
    CGFloat green = (rgb & 0x00ff00) >> 8;
    CGFloat blue = rgb & 0x0000ff;
    return [UIColor colorWith255Red:red green:green blue:blue alpha:alpha];
}
+ (UIColor *)colorWithHexString:(NSString *)hexString
{
    hexString = [hexString lowercaseString];
    u_int32_t rgbValue = 0;
    NSInteger startLocation = 0;
    if (NSNotFound != [hexString rangeOfString:@"#"].location) {
        startLocation = [hexString rangeOfString:@"#"].location;
    }
    else if (NSNotFound != [hexString rangeOfString:@"0x"].location) {
        startLocation = [hexString rangeOfString:@"0x"].location;
    }
    
    NSScanner *scanner = [NSScanner scannerWithString:hexString];
    [scanner setScanLocation:startLocation];
    [scanner scanHexInt:&rgbValue];
    return [UIColor colorWithHexRGB:rgbValue];
}

+ (UIColor *)randomColor
{
    CGFloat red = arc4random() % 256;
    CGFloat green = arc4random() % 256;
    CGFloat blue = arc4random() % 256;
    return [UIColor colorWith255Red:red green:green blue:blue];
}

@end
