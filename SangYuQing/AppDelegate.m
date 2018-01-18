//
//  AppDelegate.m
//  SangYuQing
//
//  Created by mac on 2017/12/28.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "AppDelegate.h"
#import "UIImageView+WebCache.h"
#import "MLTransition.h"
#import <AlipaySDK/AlipaySDK.h>
#import "WXApi.h"

@interface AppDelegate ()<WXApiDelegate>

@property (strong, nonatomic) UIView *lunchView;
@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [self.window makeKeyAndVisible];
    
    [WXApi registerApp:@"wx6b642202f57b9af8"];
    
    [MLTransition validatePanBackWithMLTransitionGestureRecognizerType:MLTransitionGestureRecognizerTypeScreenEdgePan];
    
    _lunchView = [[UIStoryboard storyboardWithName:@"LaunchScreen" bundle:nil] instantiateViewControllerWithIdentifier:@"LaunchScreen"].view;
    _lunchView.frame = CGRectMake(0, 0, self.window.screen.bounds.size.width, self.window.screen.bounds.size.height);
    [self.window addSubview:_lunchView];
    
    UIImageView *imageV = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.window.screen.bounds.size.width, self.window.screen.bounds.size.height)];
//    NSString *str = @"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1514450989988&di=b9d2b71adc10306f918cc5ff3db4ebae&imgtype=0&src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F01e4a1564da3d76ac7251c94308050.png%401280w_1l_2o_100sh.png";
//    [imageV sd_setImageWithURL:[NSURL URLWithString:str]];
    imageV.image = [UIImage imageNamed:@"welcome"];
    [_lunchView addSubview:imageV];
    
    [self.window bringSubviewToFront:_lunchView];
    
    [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(removeLun) userInfo:nil repeats:NO];
    
    [self loadCookies];
    
    [[UITabBarItem appearance] setTitleTextAttributes:@{
                                                        NSFontAttributeName: [UIFont systemFontOfSize:12.f],
                                                        }
                                             forState:UIControlStateSelected];
    [[UITabBarItem appearance] setTitleTextAttributes:@{
                                                        NSFontAttributeName: [UIFont systemFontOfSize:12.f],
                                                        }
                                             forState:UIControlStateNormal];
    [UITabBarItem appearance].titlePositionAdjustment = UIOffsetMake(0, -1);
    
    return YES;
}

// 加载Cookie 一般都是app刚刚启动的时候
- (void)loadCookies
{
    NSArray *cookies = [NSKeyedUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:@"cookie"]];
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    if (cookies&&cookies.count>0) {
        for (NSHTTPCookie *cookie in cookies)
        {
            [cookieStorage setCookie:cookie];
        }
    }
  
}

-(void)removeLun
{
    [_lunchView removeFromSuperview];
    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITabBarController* viewController = [sb instantiateViewControllerWithIdentifier:@"main"];
    [self.window setRootViewController:viewController];
    
}


- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)onResp:(BaseResp*)resp{
    if ([resp isKindOfClass:[PayResp class]]){
        PayResp*response=(PayResp*)resp;
        switch(response.errCode){
            case WXSuccess:
                //服务器端查询支付通知或查询API返回的结果再提示成功
                NSLog(@"支付成功");
                 [[NSNotificationCenter defaultCenter] postNotificationName:@"wx.pay.success" object:nil];
                break;
            default:
                NSLog(@"支付失败，retcode=%d",resp.errCode);
                break;
        }
    }
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            NSLog(@"result = %@",resultDic);
        }];
    }
    return YES;
}

// NOTE: 9.0以后使用新API接口
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<NSString*, id> *)options
{
    if ([url.host isEqualToString:@"safepay"]) {
        //跳转支付宝钱包进行支付，处理支付结果
        [[AlipaySDK defaultService] processOrderWithPaymentResult:url standbyCallback:^(NSDictionary *resultDic) {
            if([resultDic[@"resultStatus"] isEqualToString:@"9000"]){
               //支付成功
                NSData *data = [resultDic[@"result"] dataUsingEncoding:NSUTF8StringEncoding];
                NSDictionary *tempDictQueryDiamond = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
                NSString *no = tempDictQueryDiamond[@"alipay_trade_app_pay_response"][@"trade_no"];
                [[NSNotificationCenter defaultCenter] postNotificationName:@"ali.pay.success" object:no];
            }
            NSLog(@"result = %@",resultDic);
        }];
    }
    if ([url.host isEqualToString:@"pay"]) {
        return [WXApi handleOpenURL:url delegate:self];
    }
    
    return YES;
}



@end

