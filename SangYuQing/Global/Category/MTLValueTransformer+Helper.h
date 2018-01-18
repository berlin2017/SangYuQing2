//
//  MTLValueTransformer+Helper.h
//  AnhuiNews
//
//  Created by History on 15/9/11.
//  Copyright © 2015年 ahxmt. All rights reserved.
//

#import "MTLValueTransformer.h"

@interface MTLValueTransformer (Helper)
+ (NSValueTransformer *)boolTransformer;
+ (NSValueTransformer *)timeTransformer;
+ (NSValueTransformer *)numberTransformer;
@end
