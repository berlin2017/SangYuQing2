//
//  HZCustomTextFieldCell.m
//  ZhiJianHuo
//
//  Created by History on 15/11/15.
//  Copyright © 2015年 history. All rights reserved.
//

#import "HZCustomTextFieldCell.h"

NSString * const kCellIdfCustomTextField = @"kCellIdfCustomTextField";

@interface HZCustomTextFieldCell ()
{
    UILabel *_keyLabel;
    UITextField *_valueTextField;
    UIButton *_actionButton;
    UIImageView *_iconImageView;
}
@end

@implementation HZCustomTextFieldCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}
- (void)awakeFromNib {
    // Initialization code
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setAccessoryType:(UITableViewCellAccessoryType)accessoryType
{
    [super setAccessoryType:accessoryType];
    if (UITableViewCellAccessoryNone != accessoryType) {
        [_valueTextField mas_updateConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(self.contentView);
        }];
    }
}

- (void)setCustomStyle:(HZCustomCellStyle)customStyle
{
    if (_customStyle != customStyle) {
        _customStyle = customStyle;
        [self.contentView removeAllSubViews];
        switch (customStyle) {
            case HZCustomCellStyleDefault: {
                break;
            }
            case HZCustomCellStyleLabelTextField: {
                [self setupLabelTextField];
                break;
            }
            case HZCustomCellStyleLabelTextFieldButton: {
                [self setupLabelTextFieldButton];
                break;
            }
            case HZCustomCellStyleImageTextField: {
                [self setupImageTextField];
                break;
            }
            default: {
                break;
            }
        }
    }
}

- (void)setupLabelTextField
{
    _valueTextField = [[UITextField alloc] init];
    _valueTextField.borderStyle = UITextBorderStyleNone;
    _valueTextField.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_valueTextField];
    
    _keyLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_keyLabel];
    
    [_valueTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self.contentView).offset(-10);
        make.top.bottom.mas_equalTo(_keyLabel);
    }];
    
    
    [_keyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(10);
        make.right.mas_equalTo(_valueTextField.mas_left).offset(-10);
        make.centerY.mas_equalTo(self.contentView);
    }];
}

- (void)setupImageTextField
{
    _iconImageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_iconImageView];
    
    _valueTextField = [[UITextField alloc] init];
    _valueTextField.borderStyle = UITextBorderStyleNone;
    _valueTextField.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_valueTextField];
    
    [_keyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(10);
        make.centerY.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.contentView).offset(5);
        make.width.mas_equalTo(_iconImageView);
    }];
    
    [_valueTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_iconImageView.mas_right).offset(10);
        make.right.mas_equalTo(self.contentView).offset(-10);
        make.top.bottom.mas_equalTo(_iconImageView);
    }];
}

- (void)setupLabelTextFieldButton
{
    _keyLabel = [[UILabel alloc] init];
    [self.contentView addSubview:_keyLabel];
    [_keyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView).offset(10);
        make.centerY.mas_equalTo(self.contentView);
    }];
    _actionButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.contentView addSubview:_actionButton];
    
    _valueTextField = [[UITextField alloc] init];
    _valueTextField.borderStyle = UITextBorderStyleNone;
    _valueTextField.textAlignment = NSTextAlignmentRight;
    [self.contentView addSubview:_valueTextField];
    
    [_actionButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_valueTextField.mas_right).offset(5);
        make.right.mas_equalTo(self.contentView).offset(-10);
        make.top.bottom.mas_equalTo(_keyLabel);
    }];
    
    [_valueTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(_keyLabel.mas_right).offset(10);
        make.top.bottom.mas_equalTo(_keyLabel);
    }];
}

- (void)setKeyLabelTitle:(NSString *)title
{
    if (_keyLabel) {
        _keyLabel.text = title;
    }
}
- (void)setValueTextFieldTitle:(NSString *)title
{
    if (_valueTextField) {
        _valueTextField.text = title;
    }
}
- (void)setValueTextFieldPlaceholder:(NSString *)placeholder
{
    if (_valueTextField) {
        _valueTextField.placeholder = placeholder;
    }
}
- (void)setIconImage:(UIImage *)image
{
    if (_iconImageView) {
        _iconImageView.image = image;
        _iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    }
}
- (void)setActionButtonTitle:(NSString *)title
{
    if (_actionButton) {
        [_actionButton setTitle:title forState:UIControlStateNormal];
    }
}
- (void)setValueTextFieldTextAlignment:(NSTextAlignment)textAlignment
{
    if (_valueTextField) {
        _valueTextField.textAlignment = textAlignment;
    }
}
- (void)setValueTextFieldSecureTextEntry:(BOOL)secureTextEntry
{
    if (_valueTextField) {
        _valueTextField.secureTextEntry = secureTextEntry;
    }
}
@end
