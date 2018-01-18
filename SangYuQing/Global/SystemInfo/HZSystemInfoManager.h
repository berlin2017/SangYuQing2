//
//  HZSystemInfoManager.h
//  AnhuiNews
//
//  Created by History on 15/10/20.
//  Copyright © 2015年 ahxmt. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef NS_ENUM(NSUInteger, HZPixelScale) {
    HZPixelScale2X = 2,
    HZPixelScale3X,
};
@interface HZSystemInfoManager : NSObject
@property (copy, nonatomic, readonly  ) NSString *appVersion;// app 版本
@property (copy, nonatomic, readonly  ) NSString *appBuildVersion;// app Build 版本
@property (copy, nonatomic, readonly  ) NSString *appBundleIdentifier;// app 包名
@property (copy, nonatomic, readonly  ) NSString *ip;// 设备IP
@property (copy, nonatomic, readonly  ) NSString *deviceName;// 设备平台
@property (copy, nonatomic, readonly  ) NSString *osVersion;// 系统版本
@property (assign, nonatomic, readonly) CGSize   screenSize;// 屏幕尺寸
@property (assign, nonatomic, readonly) HZDeviceResolutionMode resolutionMode; // 设备分辨率
@property (assign, nonatomic, readonly) HZPixelScale pixelScale;
+ (instancetype)share;
@end
