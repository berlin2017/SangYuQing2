//
//  AHNBaseViewController.h
//  AnhuiNews
//
//  Created by History on 14-9-19.
//  Copyright (c) 2014年 ahxmt. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString * const kHZThemeChangeNotifiation;

typedef NS_ENUM(NSUInteger, HZVcStyle) {
    HZVcStyleRoot = 0,
    HZVcStylePush,
    HZVcStylePresent,
};
@protocol HZViewControllerProtocol <NSObject>

@optional
+ (instancetype)viewControllerFromStoryboard;

- (BOOL)canChangeColorSelf;
@required
- (HZVcStyle)vcStyle;

@end

@interface HZBaseViewController : UIViewController <HZViewControllerProtocol>
/**
 *  切换主题
 *  子类复写
 */
- (void)themeChangeNotification;
@end
