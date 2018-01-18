//
//  NSError+Helper.h
//  AnhuiNews
//
//  Created by History on 10/23/15.
//  Copyright © 2015 ahxmt. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const kHZErrorDomain;

@interface NSError (Helper)
+ (NSError *)networkingError;
+ (NSError *)jsonParseError;
+ (NSError *)serviceError;
+ (NSError *)appExceptionError;
+ (NSError *)customErrorWithCode:(NSInteger)code localizedDescription:(NSString *)description;
@end
