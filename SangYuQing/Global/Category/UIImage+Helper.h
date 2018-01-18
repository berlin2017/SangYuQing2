//
//  UIImage+Helper.h
//  AnhuiNews
//
//  Created by History on 10/23/15.
//  Copyright © 2015 ahxmt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Helper)
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size;
- (UIImage *)clipImageWithRect:(CGRect)rect;
- (UIImage *)changeImageToSize:(CGSize)size;
- (UIImage *)thumbImageWithSize:(CGSize)size;
+ (UIImage *)hz_imageNamed:(NSString *)name;
+ (UIImage *)smallLogoPicture;
+ (UIImage *)bigLogoPicture;
+ (UIImage *)horizontalLogoPicture;
@end
