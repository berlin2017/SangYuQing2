//
//  HZHelper.h
//  AnhuiNews
//
//  Created by History on 10/23/15.
//  Copyright © 2015 ahxmt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HZHelper : NSObject

@end

@interface HZHelper (AppConfig)

+ (NSString *)appBundleIdentifier;
+ (NSString *)appVersion;
+ (NSString *)appBuildVerion;
@end