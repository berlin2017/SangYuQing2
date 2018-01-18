//
//  NSDate+Helper.m
//  AnhuiNews
//
//  Created by History on 10/23/15.
//  Copyright © 2015 ahxmt. All rights reserved.
//

#import "NSDate+Helper.h"

@implementation NSDate (Helper)
- (NSString *)dateHelperString
{
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    NSDate *yesterday =  [[NSDate alloc] initWithTimeIntervalSinceNow:-secondsPerDay];
    NSDate *today = [NSDate date];
    NSCalendar* calendar = [NSCalendar currentCalendar];
    unsigned unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit |  NSDayCalendarUnit;
    NSDateComponents* comp1 = [calendar components:unitFlags fromDate:self];
    NSDateComponents* comp2 = [calendar components:unitFlags fromDate:yesterday];
    NSDateComponents* comp3 = [calendar components:unitFlags fromDate:today];
    
    if (comp1.year == comp2.year && comp1.month == comp2.month && comp1.day == comp2.day) {
        return @"昨日";
    }
    else if (comp1.year == comp3.year && comp1.month == comp3.month && comp1.day == comp3.day) {
        return @"今日";
    }
    else {
        return [self formattedDateWithFormat:@"MM-dd"];
    }
}
- (NSString *)intervalString
{
    NSTimeInterval interval = [self timeIntervalSince1970];
    return [NSString stringWithFormat:@"%.0f", interval];
}
@end
