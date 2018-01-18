//
//  HZLoadingHUD.h
//  HZLoadingHUD
//
//  Created by History on 15/1/22.
//  Copyright (c) 2015年 History. All rights reserved.
//

typedef NS_ENUM(NSInteger, HZLoadingHUDMode) {
    HZLoadingHUDModeDefalut = 0,
    HZLoadingHUDModeProgress = 1
};

#import <UIKit/UIKit.h>

@interface HZLoadingHUD : UIView
@property (assign, nonatomic) CGFloat progress;
@property (assign, nonatomic) HZLoadingHUDMode mode;
+ (instancetype)HUDForView:(UIView *)view;
+ (instancetype)showHUDInView:(UIView *)view;
+ (void)hideHUDInView:(UIView *)view;
+ (void)hideHUDInView:(UIView *)view showMessage:(NSString *)message;
+ (instancetype)showHUDInView:(UIView *)view title:(NSString *)title;
+ (instancetype)showUserInteractionDisabledHUDInView:(UIView *)view;
@end
