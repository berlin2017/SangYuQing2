//
//  HZPublicMacro.h
//  AnhuiNews
//
//  Created by History on 10/23/15.
//  Copyright © 2015 ahxmt. All rights reserved.
//

#ifndef HZPublicMacro_h
#define HZPublicMacro_h

#ifndef HZDegreesToRadians
#define HZDegreesToRadians(d) ((d) * M_PI / 180.0f)
#endif

#ifndef HZRadiansToDegrees
#define HZRadiansToDegrees(r) ((r) * 180.0f / M_PI)
#endif

#ifndef HZApplicationDelegate
#define HZApplicationDelegate   ([UIApplication sharedApplication].delegate)
#endif

#ifndef HZDeviceVersion
#define HZDeviceVersion         [[[UIDevice currentDevice] systemVersion] floatValue]
#endif

#ifndef HZGBKEncoding
#define HZGBKEncoding           CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000)
#endif

#ifndef HZInitVc
#define HZInitVc(sbName, vcIdf) [[UIStoryboard storyboardWithName:sbName bundle:nil] instantiateViewControllerWithIdentifier:vcIdf];
#endif

#ifndef HZLoadNib
#define HZLoadNib(nibName)      [[[NSBundle mainBundle] loadNibNamed:nibName owner:self options:nil] lastObject];
#endif

#ifndef HZClearColor
#define HZClearColor            [UIColor clearColor]
#endif

#ifndef NSRangeMake
static inline NSRange NSRangeMake(NSUInteger location, NSUInteger length)
{
    NSRange r;
    r.location = location;
    r.length = length;
    return r;
}
#endif


#ifndef HZLog

//#define WriteToLogFile

#ifdef DEBUG

#ifdef WriteToLogFile
#define HZLog(fmt, ...) \
NSLog(@"\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< [LOG START %s : %d]\n" fmt @"\n[LOG END] >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n\n", __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__); \
{ \
NSString *format = [NSString stringWithFormat:@"\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< [LOG START %s : %d]\n" fmt @"\n[LOG END] >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n\n", __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__]; \
NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"log.txt"]; \
if (![[NSFileManager defaultManager] fileExistsAtPath:path]) { \
fprintf(stderr,"Creating file at %s",[path UTF8String]); \
[[NSData data] writeToFile:path atomically:YES]; \
} \
NSFileHandle *handle = [NSFileHandle fileHandleForWritingAtPath:path]; \
[handle truncateFileAtOffset:[handle seekToEndOfFile]]; \
[handle writeData:[format dataUsingEncoding:NSUTF8StringEncoding]]; \
[handle closeFile]; \
}
#else
#define HZLog(fmt, ...) \
NSLog(@"\n<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<< [LOG START %s : %d]\n" fmt @"\n[LOG END] >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>\n\n", __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#endif

#else

#define HZLog(fmt, ...) \
do{}while(0);
#endif

#define HZLogCGRect(rc)     HZLog(@"CGRect : (%f, %f) - (%f, %f)", rc.origin.x, rc.origin.y, rc.size.width, rc.size.height)
#define HZLogCGPoint(pt)    HZLog(@"CGPoint : (%f, %f)", pt.x, pt.y)
#define HZLogCGSize(sz)     HZLog(@"CGSize : (%f, %f)", sz.width, sz.height)

#endif

#endif /* HZPublicMacro_h */
