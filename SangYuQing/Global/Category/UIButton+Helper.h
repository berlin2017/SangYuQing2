//
//  UIButton+Helper.h
//  AnhuiNews
//
//  Created by History on 10/23/15.
//  Copyright © 2015 ahxmt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (Helper)
- (void)setTitle:(NSString *)title normalBgImage:(NSString *)normal highlightedBgImage:(NSString *)highlighted;
- (void)setNormalBgImage:(NSString *)normal highlightedBgImage:(NSString *)highlighted;
- (void)setNormalTitle:(NSString *)normal highlightedTitle:(NSString *)highlighted;
@end
