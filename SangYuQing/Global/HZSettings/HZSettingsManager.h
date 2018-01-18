//
//  HZSettingsManager.h
//  AnhuiNews
//
//  Created by History on 15/10/19.
//  Copyright © 2015年 ahxmt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HZSettingsManager : NSObject
+ (BOOL)shouldShowImage;
+ (void)saveSholudShowImage:(BOOL)shouldShowImage;
@end
