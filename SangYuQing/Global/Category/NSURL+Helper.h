//
//  NSURL+Helper.h
//  AnhuiNews
//
//  Created by History on 10/23/15.
//  Copyright © 2015 ahxmt. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (Helper)
- (NSDictionary *)queryDictionary;
- (NSString *)queryValueWithKey:(NSString *)key;
- (BOOL)checkHostWithString:(NSString *)host;
- (BOOL)checkSchemeWithString:(NSString *)scheme;
@end
