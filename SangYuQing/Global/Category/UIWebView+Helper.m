//
//  UIWebView+Helper.m
//  AnhuiNews
//
//  Created by History on 10/23/15.
//  Copyright © 2015 ahxmt. All rights reserved.
//

#import "UIWebView+Helper.h"

@implementation UIWebView (Helper)
- (void)loadErrorHTML
{
    NSString *path = [[NSBundle mainBundle] pathForResource:@"content_error" ofType:@"html"];
    NSString *htmlString = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    [self loadHTMLString:htmlString baseURL:nil];
}
@end
