//
//  MMAlertView+Helper.m
//  AnhuiNews
//
//  Created by History on 15/11/18.
//  Copyright © 2015年 ahxmt. All rights reserved.
//

#import "MMAlertView+Helper.h"
#import "MMPopupItem.h"
#import <objc/runtime.h>

@implementation MMAlertView (Helper)
+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message
{
    [[[MMAlertView alloc] initWithConfirmTitle:title detail:message] show];
}
+ (void)showAlertWithTitle:(NSString *)title message:(NSString *)message confirmButtonTitle:(NSString *)confirmButtonTitle
{
    MMPopupItem *confirm = MMItemMake(confirmButtonTitle, MMItemTypeHighlight, ^(NSInteger index) {
        
    });
    [[[MMAlertView alloc] initWithTitle:title detail:message items:@[confirm]] show];
}

- (void)setDetailLabelTextAlignment:(NSTextAlignment)alignment
{
    [self setValue:@(alignment) forKeyPath:@"detailLabel.textAlignment"];
}
@end
