//
//  UIButton+Helper.m
//  AnhuiNews
//
//  Created by History on 10/23/15.
//  Copyright © 2015 ahxmt. All rights reserved.
//

#import "UIButton+Helper.h"

@implementation UIButton (Helper)
- (void)setTitle:(NSString *)title normalBgImage:(NSString *)normal highlightedBgImage:(NSString *)highlighted
{
    [self setTitle:title forState:UIControlStateNormal];
    if (normal) {
        [self setBackgroundImage:[UIImage imageNamed:normal] forState:UIControlStateNormal];
    }
    if (highlighted) {
        [self setBackgroundImage:[UIImage imageNamed:highlighted] forState:UIControlStateHighlighted];
    }
}
- (void)setNormalBgImage:(NSString *)normal highlightedBgImage:(NSString *)highlighted
{
    if (normal) {
        [self setBackgroundImage:[UIImage imageNamed:normal] forState:UIControlStateNormal];
    }
    if (highlighted) {
        [self setBackgroundImage:[UIImage imageNamed:highlighted] forState:UIControlStateHighlighted];
    }
}
- (void)setNormalTitle:(NSString *)normal highlightedTitle:(NSString *)highlighted
{
    [self setTitle:normal forState:UIControlStateNormal];
    [self setTitle:highlighted forState:UIControlStateHighlighted];
}

@end
