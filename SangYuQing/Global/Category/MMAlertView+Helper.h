//
//  MMAlertView+Helper.h
//  AnhuiNews
//
//  Created by History on 15/11/18.
//  Copyright © 2015年 ahxmt. All rights reserved.
//

#import "MMAlertView.h"

@interface MMAlertView (Helper)
+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message;
+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message confirmButtonTitle:(NSString *)confirmButtonTitle;
- (void)setDetailLabelTextAlignment:(NSTextAlignment)alignment;
@end
