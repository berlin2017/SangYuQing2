//
//  HZSettingsManager.m
//  AnhuiNews
//
//  Created by History on 15/10/19.
//  Copyright © 2015年 ahxmt. All rights reserved.
//

#import "HZSettingsManager.h"

@implementation HZSettingsManager
+ (BOOL)shouldShowImage
{
    return ![HZPreference boolForKey:@"com.ahn.should.show.image"];
}
+ (void)saveSholudShowImage:(BOOL)shouldShowImage
{
    [HZPreference saveBool:shouldShowImage forKey:@"com.ahn.should.show.image"];
}
@end
