//
//  HZPreference.m
//  AnhuiNews
//
//  Created by History on 10/23/15.
//  Copyright © 2015 ahxmt. All rights reserved.
//

#import "HZPreference.h"

@implementation HZPreference
+ (void)saveObject:(id)object forKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:object forKey:key];
    [defaults synchronize];
}
+ (void)saveBool:(BOOL)value forKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:value forKey:key];
    [defaults synchronize];
}
+ (void)saveInteger:(NSInteger)value forKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setInteger:value forKey:key];
    [defaults synchronize];
}
+ (void)saveFloat:(CGFloat)value forKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setFloat:value forKey:key];
    [defaults synchronize];
}
+ (void)saveURL:(NSURL *)URL forKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setURL:URL forKey:key];
    [defaults synchronize];
}
+ (void)saveCoordinate:(CLLocationCoordinate2D)coordinate forKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setFloat:coordinate.latitude forKey:[key stringByAppendingString:@".latitude"]];
    [defaults setFloat:coordinate.longitude forKey:[key stringByAppendingString:@".longitude"]];
    [defaults synchronize];
}

+ (void)removeObjectForKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:key];
    [defaults synchronize];
}
+ (void)removeCoordinateForKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:[key stringByAppendingString:@".latitude"]];
    [defaults removeObjectForKey:[key stringByAppendingString:@".longitude"]];
    [defaults synchronize];
}

+ (id)objectForKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:key];
}
+ (BOOL)boolForKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:key];
}
+ (NSInteger)integerForKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults integerForKey:key];
}
+ (CGFloat)floatForKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults floatForKey:key];
}
+ (NSURL *)URLForKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults URLForKey:key];
}
+ (CLLocationCoordinate2D)coordinateForKey:(NSString *)key
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return CLLocationCoordinate2DMake(
                                      [defaults floatForKey:[key stringByAppendingString:@".latitude"]],
                                      [defaults floatForKey:[key stringByAppendingString:@".longitude"]]
                                      );
}
@end
