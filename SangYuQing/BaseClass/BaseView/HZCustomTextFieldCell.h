//
//  HZCustomTextFieldCell.h
//  ZhiJianHuo
//
//  Created by History on 15/11/15.
//  Copyright © 2015年 history. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HZCustomCellStyle) {
    HZCustomCellStyleDefault = 0,
    HZCustomCellStyleLabelTextField,
    HZCustomCellStyleLabelTextFieldButton,
    HZCustomCellStyleImageTextField,
};

extern NSString * const kCellIdfCustomTextField;

@interface HZCustomTextFieldCell : UITableViewCell

@property (strong, nonatomic, readonly) UILabel *keyLabel;
@property (strong, nonatomic, readonly) UITextField *valueTextField;
@property (strong, nonatomic, readonly) UIButton *actionButton;
@property (strong, nonatomic, readonly) UIImageView *iconImageView;

@property (assign, nonatomic) HZCustomCellStyle customStyle;
- (void)setKeyLabelTitle:(NSString *)title;
- (void)setValueTextFieldTitle:(NSString *)title;
- (void)setValueTextFieldPlaceholder:(NSString *)placeholder;
- (void)setIconImage:(UIImage *)image;
- (void)setActionButtonTitle:(NSString *)title;
- (void)setValueTextFieldTextAlignment:(NSTextAlignment)textAlignment;
- (void)setValueTextFieldSecureTextEntry:(BOOL)secureTextEntry;
@end
