//
//  HZQRCode.h
//  AnhuiNews
//
//  Created by History on 15/7/13.
//  Copyright (c) 2015年 ahxmt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HZQRCode : NSObject

+ (UIImage *)qrCodeImageWithString:(NSString *)qrString size:(CGFloat)size;
+ (UIImage *)qrCodeImageWithString:(NSString *)qrString size:(CGFloat)size icon:(UIImage *)icon iconSize:(CGSize)iconSize;

+ (UIImage *)specialColorImage:(UIImage*)image withRed:(CGFloat)red green:(CGFloat)green blue:(CGFloat)blue;
+ (UIImage *)addIconToQRCodeImage:(UIImage *)image withIcon:(UIImage *)icon withIconSize:(CGSize)iconSize;
+ (UIImage *)addIconToQRCodeImage:(UIImage *)image withIcon:(UIImage *)icon withScale:(CGFloat)scale;

@end