//
//  AHNWebBaseViewController.h
//  AnhuiNews
//
//  Created by History on 14/11/24.
//  Copyright (c) 2014年 ahxmt. All rights reserved.
//

#import "HZBaseViewController.h"

typedef NS_ENUM(NSInteger, HZWebActionButtonMode) {
    HZWebActionButtonNone        = 0,
    HZWebActionButtonShare       = 1 << 0,
    HZWebActionButtonFavourite   = 1 << 1,
    HZWebActionButtonUnfavourite = 1 << 2
};

@interface HZWebBaseViewController : HZBaseViewController
@property (nonatomic, strong) NSURL *webURL;
@property (nonatomic, assign) HZWebActionButtonMode actionButtonMode;
@property (nonatomic, copy) NSString *shareText;
@property (nonatomic, copy) NSString *shareTitle;

- (instancetype)initWithURL:(NSURL *)URL actionButtonMode:(HZWebActionButtonMode)mode;
- (instancetype)initWithText:(NSString *)text;
- (void)updateRightItems;
@end
