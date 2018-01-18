//
//  HZSystemInfoManager.m
//  AnhuiNews
//
//  Created by History on 15/10/20.
//  Copyright © 2015年 ahxmt. All rights reserved.
//

#import "HZSystemInfoManager.h"
#import <ifaddrs.h>
#import <arpa/inet.h>
#import "sys/utsname.h"

@implementation HZSystemInfoManager
+ (instancetype)share
{
    static HZSystemInfoManager *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!instance) {
            instance = [[HZSystemInfoManager alloc] init];
        }
    });
    return instance;
}
- (instancetype)init
{
    self = [super init];
    if (self) {
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        _appVersion = [infoDictionary[@"CFBundleShortVersionString"] copy];
        _appBuildVersion = [infoDictionary[@"CFBundleVersion"] copy];
        _appBundleIdentifier = [[[NSBundle mainBundle] bundleIdentifier] copy];
        _deviceName = [[self currentDeviceName] copy];
        _osVersion = [[[UIDevice currentDevice] systemVersion] copy];
        CGSize size = [[UIScreen mainScreen] bounds].size;
        _screenSize = size;
        HZDeviceResolutionMode mode = HZDeviceResolutionModeOthers;
        _pixelScale = HZPixelScale2X;
        if (960 == size.height * 2) { // iPhone4/4S
            mode = HZDeviceResolutionMode640X960;
        }
        else if (1136 == size.height * 2) { // iPhone5/5S/5C
            mode = HZDeviceResolutionMode640X1136;
        }
        else if (1334 == size.height * 2) { // iPhone6
            mode = HZDeviceResolutionMode750X1334;
        }
        else if (1472 == size.height * 2) { // iPhone6+
            mode = HZDeviceResolutionMode1242X2208;
            _pixelScale = HZPixelScale3X;
        }
        else if (1024 == size.height * 2) { // iPad mini
            mode = HZDeviceResolutionMode768X1024;
        }
        else if (2048 == size.height * 2) { // iPad mini2/air/3/4
            mode = HZDeviceResolutionMode1536X2048;
        }
        else {
            mode = HZDeviceResolutionModeOthers;
        }
        _resolutionMode = mode;
        _ip = [[self currentIP] copy];
    }
    return self;
}

- (NSString *)currentIP
{
    NSString *address = @"127.0.0.1";
    struct ifaddrs *interfaces = NULL;
    struct ifaddrs *temp_addr = NULL;
    int success = 0;
    // retrieve the current interfaces - returns 0 on success
    success = getifaddrs(&interfaces);
    if (success == 0) {
        // Loop through linked list of interfaces
        temp_addr = interfaces;
        while(temp_addr != NULL) {
            if(temp_addr->ifa_addr->sa_family == AF_INET) {
                // Check if interface is en0 which is the wifi connection on the iPhone
                if([[NSString stringWithUTF8String:temp_addr->ifa_name] isEqualToString:@"en0"]) {
                    // Get NSString from C String
                    address = [NSString stringWithUTF8String:inet_ntoa(((struct sockaddr_in *)temp_addr->ifa_addr)->sin_addr)];
                }
            }
            temp_addr = temp_addr->ifa_next;
        }
    }
    // Free memory
    freeifaddrs(interfaces);
    return address;
}
- (NSString *)currentDeviceName
{
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceString = [NSString stringWithCString:systemInfo.machine encoding:NSUTF8StringEncoding];
    
    NSDictionary *deviceDictionary = @{
                                       @"i386": @"Simulator",
                                       @"x86_64": @"Simulator",
                                       @"iPhone1,1": @"iPhone",
                                       @"iPhone1,2": @"iPhone3G",
                                       @"iPhone2,1": @"iPhone3GS",
                                       @"iPhone3,1": @"iPhone4",
                                       @"iPhone3,2": @"iPhone4",
                                       @"iPhone3,3": @"iPhone4",
                                       @"iPhone4,1": @"iPhone4s",
                                       @"iPhone5,1": @"iPhone5",
                                       @"iPhone5,2": @"iPhone5",
                                       @"iPhone5,3": @"iPhone5c",
                                       @"iPhone5,4": @"iPhone5c",
                                       @"iPhone6,1": @"iPhone5s",
                                       @"iPhone6,2": @"iPhone5s",
                                       @"iPhone7,1": @"iPhone6 Plus",
                                       @"iPhone7,2": @"iPhone6",
                                       @"iPhone8,1": @"iPhone6s Plus",
                                       @"iPhone8,2": @"iPhone6s",
                                       @"iPod1,1": @"iPod",
                                       @"iPod2,1": @"iPod",
                                       @"iPod3,1": @"iPod",
                                       @"iPod4,1": @"iPod",
                                       @"iPod5,1": @"iPod",
                                       @"iPad1,1": @"iPad",
                                       @"iPad2,1": @"iPad",
                                       @"iPad2,2": @"iPad",
                                       @"iPad2,3": @"iPad",
                                       @"iPad2,4": @"iPad",
                                       @"iPad2,5": @"iPad",
                                       @"iPad2,6": @"iPad",
                                       @"iPad2,7": @"iPad",
                                       @"iPad3,1": @"iPad",
                                       @"iPad3,2": @"iPad",
                                       @"iPad3,3": @"iPad",
                                       @"iPad3,4": @"iPad",
                                       @"iPad3,5": @"iPad",
                                       @"iPad3,6": @"iPad",
                                       };
    NSString *deviceName = [deviceDictionary objectForKey:deviceString];
    if (deviceName) {
        return deviceName;
    }
    else {
        return @"Unknow Device";
    }
}
@end
