//
//  BaseViewController.h
//  SangYuQing
//
//  Created by mac on 2017/12/28.
//  Copyright © 2017年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, HZVcStyle) {
    HZVcStyleRoot = 0,
    HZVcStylePush,
    HZVcStylePresent,
};


@interface BaseViewController : UIViewController

- (HZVcStyle)vcStyle;

@end
