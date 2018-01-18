//
//  UIImageView+WebCacheExtension.h
//  AnhuiNews
//
//  Created by History on 15/10/19.
//  Copyright © 2015年 ahxmt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (WebCacheExtension)
- (void)sd_extension_setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder;
@end
