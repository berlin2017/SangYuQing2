//
//  HZGlobalEnum.h
//  AnhuiNews
//
//  Created by History on 9/28/15.
//  Copyright © 2015 ahxmt. All rights reserved.
//

#ifndef HZGlobalEnum_h
#define HZGlobalEnum_h

typedef NS_ENUM(NSInteger, HZDeviceResolutionMode) {
    HZDeviceResolutionMode640X960 = 1, //  iPhone4/4S
    HZDeviceResolutionMode640X1136, // iPhone5/5S/5C
    HZDeviceResolutionMode750X1334, // iPhone6
    HZDeviceResolutionMode1242X2208, // iPhone6+
    HZDeviceResolutionMode768X1024, // iPad mini
    HZDeviceResolutionMode1536X2048, // iPad mini2/air3/4
    HZDeviceResolutionModeOthers,
};

typedef NS_ENUM(NSInteger, ZANPraiseCriticismMode) {
    ZANPraiseCriticismModeNone = 0,
    ZANPraiseCriticismModePraise,
    ZANPraiseCriticismModeCriticism,
};

typedef NS_ENUM(NSInteger, ZANNewsContentFontSize) {
    ZANNewsContentFontSizeSmall = -1,
    ZANNewsContentFontSizeNormal,
    ZANNewsContentFontSizeLarge,
    ZANNewsContentFontSizeLargeX,
//    ZANNewsContentFontSizeLargeXX,
//    ZANNewsContentFontSizeLargeXXX,
};

typedef NS_ENUM(NSUInteger, ZANIndependentColumnMode) {
    ZANIndependentColumnModeSpecialMore = -1, // 专题更多
    ZANIndependentColumnMode24HotNews = 0, // 24小时热点
    ZANIndependentColumnModeActivity, // 活动
    ZANIndependentColumnModeSecretary, // 省委书记报道集
    ZANIndependentColumnModeGovernor, // 省长报道集
    ZANIndependentColumnModeSystemMessage, // 系统消息
};

typedef NS_ENUM(NSInteger, ZANUserBindMode) {
    ZANUserBindModePhone        = 1 << 0,
    ZANUserBindModeQQ           = 1 << 1,
    ZANUserBindModeTencentWeiBo = 1 << 2,
    ZANUserBindModeSina         = 1 << 3,
    ZANUserBindModeWeiXin       = 1 << 4,
    ZANUserBindModeEmail        = 1 << 5
};

typedef NS_ENUM(NSInteger, ZANUserScoreTargetMode) {
    ZANUserScoreTargetModeSign         = 1 << 0,
    ZANUserScoreTargetModeReadNews     = 1 << 1,
    ZANUserScoreTargetModeComment      = 1 << 2,
    ZANUserScoreTargetModeShareNews    = 1 << 3,
    ZANUserScoreTargetModeInviteFriend = 1 << 4,
    ZANUserScoreTargetModeBreakNews    = 1 << 5,
};

typedef NS_ENUM(NSUInteger, ZANNewsStyle) {
    ZANNewsStyleTextOnly = 0,
    ZANNewsStyleBigImage,
    ZANNewsStyleImageText,
    ZANNewsStyleThreeImage,
    ZANNewsStyleLowAdImage,
    ZANNewsStyleSubscirbeTag,
    ZANNewsStyleHighAdImage,
};

typedef NS_ENUM(NSUInteger, ZANNewsMode) {
    ZANNewsModeDefault = 0,// 默认
    ZANNewsModeSpecial, // 专题
    ZANNewsModeLink, // 外链
    ZANNewsModeImageSet, // 图集
    ZANNewsModeLive, // 直播
    ZANNewsModeVideo, // 视频
    ZANNewsModeAudio, // 音频

};
#endif /* HZGlobalEnum_h */
