//
//  UITabBar+Helper.m
//  AnhuiNews
//
//  Created by History on 15/11/5.
//  Copyright © 2015年 ahxmt. All rights reserved.
//

#import "UITabBar+Helper.h"

const NSInteger kHZTabbarItemCount = 4;

@implementation UITabBar (Helper)

- (void)showItemBadgeAtIndex:(NSInteger)index
{
    [self hideItemBadgeAtIndex:index];
    
    //新建小红点
    UIView *badgeView = [[UIView alloc]init];
    badgeView.tag = 888 + index;
    badgeView.layer.cornerRadius = 5;
    badgeView.backgroundColor = [UIColor redColor];
    CGRect tabFrame = self.frame;
    //确定小红点的位置
    CGFloat percentX = (index + 0.6) / kHZTabbarItemCount;
    CGFloat x = ceilf(percentX * tabFrame.size.width);
    CGFloat y = ceilf(0.1 * tabFrame.size.height);
    badgeView.frame = CGRectMake(x, y, 10, 10);
    [self addSubview:badgeView];
}
- (void)showItemBadgeNumber:(NSInteger)number atIndex:(NSInteger)index
{
    [self hideItemBadgeAtIndex:index];
    //新建小红点
    UILabel *badgeLabel = [[UILabel alloc] init];
    badgeLabel.tag = 888 + index;
    badgeLabel.layer.cornerRadius = 9;
    badgeLabel.layer.masksToBounds = YES;
    badgeLabel.backgroundColor = [UIColor redColor];
    CGRect tabFrame = self.frame;
    //确定小红点的位置
    CGFloat percentX = (index + 0.55) / kHZTabbarItemCount;
    CGFloat x = ceilf(percentX * tabFrame.size.width);
    CGFloat y = ceilf(0.1 * tabFrame.size.height);
    badgeLabel.frame = CGRectMake(x, y, 18, 18);
    badgeLabel.text = [@(number) stringValue];
    badgeLabel.textColor = [UIColor whiteColor];
    badgeLabel.font = [UIFont boldSystemFontOfSize:11.f];
    badgeLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:badgeLabel];
}
- (void)hideItemBadgeAtIndex:(NSInteger)index
{
    for (UIView *subView in self.subviews) {
        if (subView.tag == 888 + index) {
            [subView removeFromSuperview];
        }
    }
}
@end
