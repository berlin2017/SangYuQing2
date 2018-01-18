//
//  UserManager.h
//  SangYuQing
//
//  Created by mac on 2018/1/12.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserModel;

@interface UserManager : NSObject
+ (UserModel *)ahnUser;
+ (void)saveAhnUser:(UserModel *)ahnUser;
+ (void)clearAllUser;
@end
