//
//  UIImage+Helper.m
//  AnhuiNews
//
//  Created by History on 10/23/15.
//  Copyright © 2015 ahxmt. All rights reserved.
//

#import "UIImage+Helper.h"

@implementation UIImage (Helper)
+ (UIImage *)imageWithColor:(UIColor *)color size:(CGSize)size

{
    @autoreleasepool {
        CGRect rect = CGRectMake(0, 0, size.width, size.height);
        UIGraphicsBeginImageContext(rect.size);
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetFillColorWithColor(context,
                                       color.CGColor);
        CGContextFillRect(context, rect);
        UIImage *img = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        return img;
    }
}

- (UIImage *)clipImageWithRect:(CGRect)rect
{
    CGImageRef imageRefOut = CGImageCreateWithImageInRect(self.CGImage, rect);
    UIImage *returnImage = [[UIImage alloc] initWithCGImage:imageRefOut];
    CGImageRelease(imageRefOut);
    return returnImage;
}

- (UIImage *)changeImageToSize:(CGSize)size
{
    UIGraphicsBeginImageContextWithOptions(size, NO, 0.0);
    CGRect imageRect = CGRectMake(0.0, 0.0, size.width, size.height);
    [self drawInRect:imageRect];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

- (UIImage *)thumbImageWithSize:(CGSize)size
{
    if (!self) {
        return nil;
    }
    CGSize oldSize = self.size;
    
    CGRect rect;
    if (oldSize.width / oldSize.height >= 1) {
        CGFloat scale = oldSize.height / size.height;
        CGSize tmp = CGSizeMake(size.width * scale, size.height * scale);
        rect = (CGRect){.origin = CGPointMake((oldSize.width - tmp.width) / 2, 0), .size = tmp};
    }
    else {
        CGFloat scale = oldSize.width / size.width;
        CGSize tmp = CGSizeMake(size.width * scale, size.height * scale);
        rect = (CGRect){.origin = CGPointMake(0, (oldSize.height - tmp.height) / 2), .size = tmp};
    }
    
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0.0);    
    [self drawInRect:rect];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}
+ (UIImage *)hz_imageNamed:(NSString *)name
{
    CGFloat height = CGRectGetHeight([UIScreen mainScreen].bounds);
    if (480 == height) {
        return [UIImage imageNamed:[NSString stringWithFormat:@"%@~568h.%@", [name stringByDeletingPathExtension], [name pathExtension]]];
    }
    NSString *fileName = [NSString stringWithFormat:@"%@~%@h.%@", [name stringByDeletingPathExtension], [@(height) stringValue], [name pathExtension]];
    UIImage *image = [UIImage imageNamed:fileName];
    if (image) {
        return image;
    }
    else {
        return [UIImage imageNamed:name];
    }
}

+ (UIImage *)smallLogoPicture
{
    return [UIImage imageNamed:@"news_small_picture_download.png"];
}
+ (UIImage *)bigLogoPicture
{
    return [UIImage imageNamed:@"news_big_picture_download.png"];
}
+ (UIImage *)horizontalLogoPicture
{
    return [UIImage imageNamed:@"news_horizontal_picture_download.png"];
}
@end
