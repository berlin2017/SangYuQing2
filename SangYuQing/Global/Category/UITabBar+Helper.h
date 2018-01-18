//
//  UITabBar+Helper.h
//  AnhuiNews
//
//  Created by History on 15/11/5.
//  Copyright © 2015年 ahxmt. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBar (Helper)

- (void)showItemBadgeAtIndex:(NSInteger)index;
- (void)showItemBadgeNumber:(NSInteger)number atIndex:(NSInteger)index;
- (void)hideItemBadgeAtIndex:(NSInteger)index;
@end
