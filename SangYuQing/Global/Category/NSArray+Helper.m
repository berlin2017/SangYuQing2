//
//  NSArray+Helper.m
//  AnhuiNews
//
//  Created by History on 10/23/15.
//  Copyright © 2015 ahxmt. All rights reserved.
//

#import "NSArray+Helper.h"

@implementation NSMutableArray (Helper)
- (BOOL)addObjectSafely:(id)anObject
{
    if (anObject) {
        [self addObject:anObject];
        return YES;
    }
    else {
        return NO;
    }
}
@end
