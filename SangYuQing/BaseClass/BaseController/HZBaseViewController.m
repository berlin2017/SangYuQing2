//
//  AHNBaseViewController.m
//  AnhuiNews
//
//  Created by History on 14-9-19.
//  Copyright (c) 2014年 ahxmt. All rights reserved.
//

#import "HZBaseViewController.h"

NSString * const kHZThemeChangeNotifiation = @"com.history.theme.change.notification";

@interface HZBaseViewController ()

@end

@implementation HZBaseViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        if (HZVcStyleRoot != [self vcStyle]) {
            self.hidesBottomBarWhenPushed = YES;
        }
        self.automaticallyAdjustsScrollViewInsets = NO;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeChangeNotification) name:kHZThemeChangeNotifiation object:nil];
    }
    return self;
}
- (instancetype)init
{
    if (self = [super init]) {
        if (HZVcStyleRoot != [self vcStyle]) {
            self.hidesBottomBarWhenPushed = YES;
        }
        self.automaticallyAdjustsScrollViewInsets = NO;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(themeChangeNotification) name:kHZThemeChangeNotifiation object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setupNavigationBackItem];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self setupNavigationBarTintColor];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - Private Function
- (void)setupNavigationBarTintColor
{
    if ([self respondsToSelector:@selector(canChangeColorSelf)]) {
        if ([self canChangeColorSelf]) {
            return;
        }
    }
    HZVcStyle vcStyle = [self vcStyle];
    switch (vcStyle) {
        case HZVcStyleRoot: {
            self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
            self.navigationController.navigationBar.barTintColor = [HZThemeManager navigationHighlightedBackgroundColor];
            [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
            [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                              NSForegroundColorAttributeName: [HZThemeManager navigationHighlightedTextColor],
                                                                              NSFontAttributeName: [UIFont boldSystemFontOfSize:20.f],
                                                                              }];
            break;
        }
        case HZVcStylePush:
        case HZVcStylePresent: {
//            [[UINavigationBar appearance] setBackgroundImage:[[UIImage alloc] init] forBarMetrics:UIBarMetricsDefault];
//            [[UINavigationBar appearance] setShadowImage:[[UIImage alloc] init]];
            self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
            self.navigationController.navigationBar.barTintColor = [HZThemeManager navigationNormalBackgroundColor];
            [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
            [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                              NSForegroundColorAttributeName: [HZThemeManager navigationNormalTextColor],
                                                                              NSFontAttributeName: [UIFont boldSystemFontOfSize:20.f]
                                                                              }];

            break;
        }
        default: {
            break;
        }
    }
}
- (void)setupNavigationBackItem
{
    HZVcStyle vcStyle = [self vcStyle];
    switch (vcStyle) {
        case HZVcStyleRoot: {
            break;
        }
        case HZVcStylePush: {
            UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [backButton setBackgroundImage:[UIImage imageNamed:@"app_back"] forState:UIControlStateNormal];
            backButton.frame = CGRectMake(0, 0, 20, 20);
            [backButton addTarget:self action:@selector(popBackAction) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
            
            self.navigationItem.leftBarButtonItem = backItem;
            break;
        }
        case HZVcStylePresent: {
            UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [backButton setBackgroundImage:[UIImage imageNamed:@"app_back"] forState:UIControlStateNormal];
            backButton.frame = CGRectMake(0, 0, 20, 20);
            [backButton addTarget:self action:@selector(dismissBackAction) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
            
            self.navigationItem.leftBarButtonItem = backItem;
            break;
        }
        default: {
            break;
        }
    }
}

- (void)popBackAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dismissBackAction
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - HZViewControllerProtocol
+ (instancetype)viewControllerFromStoryboard
{
    NSAssert(YES, @"You shuld load viewController with `HZInitVc(sbName, vcIdf)`");
    return nil;
}
- (HZVcStyle)vcStyle
{
    return HZVcStylePush;
}

#pragma mark - Theme
- (void)themeChangeNotification
{
    
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:kHZThemeChangeNotifiation object:nil];
}
@end
