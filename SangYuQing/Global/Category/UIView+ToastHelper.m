//
//  UIView+ToastHelper.m
//  AnhuiNews
//
//  Created by History on 15/9/11.
//  Copyright © 2015年 ahxmt. All rights reserved.
//

#import "UIView+ToastHelper.h"

@implementation UIView (ToastHelper)
- (void)makeCenterOffsetToast:(NSString *)message
{
    CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
    style.horizontalPadding = 15.f;
    style.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7f];
    [self makeToast:message duration:2.f position:CSToastPositionCenter style:style];
}

- (void)makeBottomOffsetToast:(NSString *)message
{
    CSToastStyle *style = [[CSToastStyle alloc] initWithDefaultStyle];
    style.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7f];
    style.horizontalPadding = 15.f;
    [self makeToast:message duration:2.f position:CSToastPositionBottom style:style];
}
@end
