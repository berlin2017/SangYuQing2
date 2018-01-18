//
//  UIImageView+WebCacheExtension.m
//  AnhuiNews
//
//  Created by History on 15/10/19.
//  Copyright © 2015年 ahxmt. All rights reserved.
//

#import "UIImageView+WebCacheExtension.h"
#import "HZSettingsManager.h"

@implementation UIImageView (WebCacheExtension)
- (void)sd_extension_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    BOOL shouldLoadImage = [HZSettingsManager shouldShowImage];
//    shouldLoadImage = NO;
    if (shouldLoadImage) {
        [self sd_setImageWithURL:url placeholderImage:placeholder];
    }
    else {
        [self sd_setImageWithURL:nil placeholderImage:placeholder];
    }
}
@end
