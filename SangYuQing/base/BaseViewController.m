//
//  BaseViewController.m
//  SangYuQing
//
//  Created by mac on 2017/12/28.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "BaseViewController.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        if (HZVcStyleRoot != [self vcStyle]) {
            self.hidesBottomBarWhenPushed = YES;
        }
        self.automaticallyAdjustsScrollViewInsets = NO;
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
    }
    return self;
}

- (HZVcStyle)vcStyle
{
    return HZVcStylePush;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
      [self setupNavigationBackItem];
}

- (void)setupNavigationBackItem
{
    
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bar_bg"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTitleTextAttributes:@{
                                                                      NSForegroundColorAttributeName: [UIColor blackColor],
                                                                      NSFontAttributeName: [UIFont boldSystemFontOfSize:20.f]
                                                                      }];
    
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


- (void)didReceiveMemoryWarning {
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

@end
