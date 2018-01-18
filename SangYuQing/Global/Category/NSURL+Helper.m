//
//  NSURL+Helper.m
//  AnhuiNews
//
//  Created by History on 10/23/15.
//  Copyright © 2015 ahxmt. All rights reserved.
//

#import "NSURL+Helper.h"

@implementation NSURL (Helper)
- (NSDictionary *)queryDictionary
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    NSString *queryString = self.query;
    NSArray *components = [queryString componentsSeparatedByString:@"&"];
    for (NSString *keyValueString in components) {
        NSArray *keyValueArray = [keyValueString componentsSeparatedByString:@"="];
        if (2 == keyValueArray.count) {
            [dictionary setObject:keyValueArray[1] forKey:keyValueArray[0]];
        }
    }
    if (dictionary.count) {
        return dictionary;
    }
    else {
        return nil;
    }
}

- (NSString *)queryValueWithKey:(NSString *)key
{
    return [self queryDictionary][key];
}

- (BOOL)checkHostWithString:(NSString *)host
{
    if ([self.host isEqualToString:host]) {
        return YES;
    }
    else {
        return NO;
    }
}

- (BOOL)checkSchemeWithString:(NSString *)scheme
{
    if ([self.scheme isEqualToString:scheme]) {
        return YES;
    }
    else {
        return NO;
    }
}

@end
