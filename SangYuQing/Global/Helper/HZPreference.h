//
//  HZPreference.h
//  AnhuiNews
//
//  Created by History on 10/23/15.
//  Copyright © 2015 ahxmt. All rights reserved.
//

@import Foundation;
@import UIKit;
@import CoreLocation;


@interface HZPreference : NSObject
+ (void)saveObject:(id)object forKey:(NSString *)key;
+ (void)saveBool:(BOOL)value forKey:(NSString *)key;
+ (void)saveInteger:(NSInteger)value forKey:(NSString *)key;
+ (void)saveFloat:(CGFloat)value forKey:(NSString *)key;
+ (void)saveURL:(NSURL *)URL forKey:(NSString *)key;
+ (void)saveCoordinate:(CLLocationCoordinate2D)coordinate forKey:(NSString *)key;

+ (void)removeObjectForKey:(NSString *)key;
+ (void)removeCoordinateForKey:(NSString *)key;

+ (id)objectForKey:(NSString *)key;
+ (BOOL)boolForKey:(NSString *)key;
+ (NSInteger)integerForKey:(NSString *)key;
+ (CGFloat)floatForKey:(NSString *)key;
+ (NSURL *)URLForKey:(NSString *)key;
+ (CLLocationCoordinate2D)coordinateForKey:(NSString *)key;
@end