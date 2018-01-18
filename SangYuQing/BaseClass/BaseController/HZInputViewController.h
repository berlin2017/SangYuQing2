//
//  HZInputViewController.h
//  AnhuiNews
//
//  Created by History on 15/3/10.
//  Copyright (c) 2015年 ahxmt. All rights reserved.
//

#import "HZBaseViewController.h"

typedef NS_ENUM(NSInteger, HZInputMode) {
    HZInputModePlainTextInput = 0,
    HZInputModeMultiLineTextInput,
    HZInputModeSecureTextInput,
    HZInputModeLoginAndPasswordInput,
};

typedef NS_ENUM(NSInteger, HZRegexMode) {
    HZRegexModeNone = 0,
    HZRegexModePhone,
    HZRegexModePwd,
    HZRegexModeNameAndPwd,
};

extern NSString * const kHZPlainTextPlaceholderKey;
extern NSString * const kHZSecureTextPlaceholderKey;

@class HZInputViewController;

@protocol HZInputViewControllerDelegate <NSObject>

@optional
- (void)inputViewController:(HZInputViewController *)inputViewController didFinishWithText:(NSString *)text;
- (void)inputViewController:(HZInputViewController *)inputViewController didFinishWithUserName:(NSString *)name pwd:(NSString *)pwd;

@end
@interface HZInputViewController : HZBaseViewController
@property (assign, nonatomic) NSInteger tag;
@property (assign, nonatomic) HZInputMode inputMode;
@property (assign, nonatomic) HZRegexMode regexMode;
@property (weak, nonatomic) id<HZInputViewControllerDelegate> delegate;
@property (copy, nonatomic) NSString *previewText;
@property (assign, nonatomic) UIKeyboardType firstKeyboardType;
@property (assign, nonatomic) UIKeyboardType secondKeyboardType;

- (void)setTextPlaceholderDictionary:(NSDictionary *)placeholderDictionary;
@end
