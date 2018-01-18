//
//  UserManager.m
//  SangYuQing
//
//  Created by mac on 2018/1/12.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "UserManager.h"
#import "UserModel.h"

NSString * const kZANAhnUserFileName    = @"ahnews_user.atm";

@implementation UserManager

+ (NSString *)ahnUserPath
{
    NSString *path = nil;
    NSArray *library = NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES);
    if (library.count) {
        path = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES)[0] stringByAppendingPathComponent:kZANAhnUserFileName];
    }
    else {
        path = [[NSFileManager documentDirectory] stringByAppendingPathComponent:kZANAhnUserFileName];
    }
    return path;
}

+ (UserModel *)ahnUser{
    NSString *path = [self ahnUserPath];
    UserModel *model = nil;
    if ([NSFileManager isFileExists:path]) {
        model = [NSKeyedUnarchiver unarchiveObjectWithFile:path];
    }
    return model;
}

+ (void)saveAhnUser:(UserModel *)ahnUser{
    if (ahnUser) {
        [NSKeyedArchiver archiveRootObject:ahnUser toFile:[self ahnUserPath]];
        [HZPreference saveObject:ahnUser.account_name forKey:@"username"];
    }
}


+ (void)clearAllUser{
    if ([NSFileManager isFileExists:[self ahnUserPath]]) {
        [NSFileManager deleteFileAtPath:[self ahnUserPath]];
    }
}

@end
