//
//  AHNWebBaseViewController.m
//  AnhuiNews
//
//  Created by History on 14/11/24.
//  Copyright (c) 2014年 ahxmt. All rights reserved.
//

#import "HZWebBaseViewController.h"
#import "NJKWebViewProgressView.h"
#import "NJKWebViewProgress.h"

@interface HZWebBaseViewController () < UIWebViewDelegate, NJKWebViewProgressDelegate>
{
    UIWebView *_webView;
    
    BOOL _showProgressView;
    
    NJKWebViewProgressView *_progressView;
    NJKWebViewProgress *_progressProxy;
}
@property (copy, nonatomic) NSString *HTMLString;
@end

@implementation HZWebBaseViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _actionButtonMode = HZWebActionButtonNone;
        self.hidesBottomBarWhenPushed = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _webView = [[UIWebView alloc] init];
    [self.view addSubview:_webView];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.mas_topLayoutGuide);
        make.left.right.bottom.mas_equalTo(self.view);
    }];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    if (_showProgressView) {
        _progressProxy = [[NJKWebViewProgress alloc] init];
        _webView.delegate = _progressProxy;
        _progressProxy.webViewProxyDelegate = self;
        _progressProxy.progressDelegate = self;
        
        CGFloat progressBarHeight = 2.f;
        CGRect navigaitonBarBounds = self.navigationController.navigationBar.bounds;
        CGRect barFrame = CGRectMake(0, navigaitonBarBounds.size.height - progressBarHeight, navigaitonBarBounds.size.width, progressBarHeight);
        _progressView = [[NJKWebViewProgressView alloc] initWithFrame:barFrame];
        _progressView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    }
    
    [self updateLeftItems];
    [self updateRightItems];
    _webView.scalesPageToFit = YES;
    if (_webURL) {
        [_webView loadRequest:[NSURLRequest requestWithURL:_webURL]];
    }
    else if (_HTMLString) {
        [_webView loadHTMLString:_HTMLString baseURL:nil];
    }
    else {
        [self.view makeCenterOffsetToast:@"链接无效,请重试"];
    }
}

- (instancetype)initWithURL:(NSURL *)URL actionButtonMode:(HZWebActionButtonMode)mode
{
    if (self = [super init]) {
        _webURL = URL;
        _actionButtonMode = mode;
        self.hidesBottomBarWhenPushed = YES;
        _showProgressView = YES;
        
    }
    return self;
}

- (instancetype)initWithText:(NSString *)text
{
    if (self = [super init]) {
        _HTMLString = [NSString stringWithFormat:@"<html><head></head><body><p><font size=\"20px\">%@</font></p></body></html>", text];
        _actionButtonMode = HZWebActionButtonNone;
        self.hidesBottomBarWhenPushed = YES;
        
        self.title = @"扫描结果";
        
        _showProgressView = NO;
    }
    return self;
}

- (void)updateLeftItems
{
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [backButton setBackgroundImage:[UIImage imageNamed:@"app_back"] forState:UIControlStateNormal];
    backButton.frame = CGRectMake(0, 0, 20, 20);
    [backButton addTarget:self action:@selector(goBackItemAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    
    if (!_webView.canGoBack) {
        self.navigationItem.leftBarButtonItems = @[backItem];
    }
    else {
        UIBarButtonItem *closeItem = [[UIBarButtonItem alloc] initWithTitle:@"关闭" style:UIBarButtonItemStyleBordered target:self action:@selector(closeItemAction)];
        self.navigationItem.leftBarButtonItems = @[backItem, closeItem];
    }
}

- (void)updateRightItems
{
    if (HZWebActionButtonNone == _actionButtonMode) {
        self.navigationItem.rightBarButtonItems = nil;
    }
    else {
        NSMutableArray *barItems = nil;
        if (_actionButtonMode & HZWebActionButtonShare) {
            UIButton *shareButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [shareButton setNormalBgImage:@"detail_share.png" highlightedBgImage:@"detail_share_hl.png"];
            shareButton.frame = CGRectMake(0, 0, 25, 25);
            [shareButton addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem *shareItem = [[UIBarButtonItem alloc] initWithCustomView:shareButton];
            if (!barItems) {
                barItems = [NSMutableArray array];
            }
            [barItems addObject:shareItem];
        }
        if (_actionButtonMode & HZWebActionButtonFavourite) {
            UIButton *favouriteButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [favouriteButton setNormalBgImage:@"detail_favourite_hl.png" highlightedBgImage:@"detail_favourite.png"];
            favouriteButton.frame = CGRectMake(0, 0, 25, 25);
            [favouriteButton addTarget:self action:@selector(favouriteAction) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem *favouriteItem = [[UIBarButtonItem alloc] initWithCustomView:favouriteButton];
            if (!barItems) {
                barItems = [NSMutableArray array];
            }
            [barItems addObject:favouriteItem];
        }
        if (_actionButtonMode & HZWebActionButtonUnfavourite) {
            UIButton *favouriteButton = [UIButton buttonWithType:UIButtonTypeCustom];
            [favouriteButton setNormalBgImage:@"detail_favourite.png" highlightedBgImage:@"detail_favourite_hl.png"];
            favouriteButton.frame = CGRectMake(0, 0, 25, 25);
            [favouriteButton addTarget:self action:@selector(favouriteAction) forControlEvents:UIControlEventTouchUpInside];
            UIBarButtonItem *favouriteItem = [[UIBarButtonItem alloc] initWithCustomView:favouriteButton];
            if (!barItems) {
                barItems = [NSMutableArray array];
            }
            [barItems addObject:favouriteItem];
        }
        self.navigationItem.rightBarButtonItems = barItems;
    }

}

- (void)goBackItemAction
{
    if (_webView.canGoBack) {
        [self updateLeftItems];
        [_webView goBack];
    }
    else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)closeItemAction
{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // Remove progress view
    // because UINavigationBar is shared with other ViewControllers
    [_progressView removeFromSuperview];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar addSubview:_progressView];
    
//    self.navigationController.navigationBar.barTintColor = [HZTheme navigationNormalBackgroundColor];
//    
//    [self.navigationController.navigationBar setTitleTextAttributes:@{
//                                                                      NSForegroundColorAttributeName: [HZTheme navigationNormalTextColor],
//                                                                      NSFontAttributeName: [UIFont boldSystemFontOfSize:20.f]
//                                                                      }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)shareAction
{
//    [UMSocialQQHandler setQQWithAppId:kQQAppId appKey:kQQAppKey url:_webURL.absoluteString];
//    [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeImage url:nil];
//
//    [UMSocialData defaultData].extConfig.qqData.url = _webURL.absoluteString;
//    [UMSocialData defaultData].extConfig.qqData.title = _shareTitle;
//    [UMSocialData defaultData].extConfig.wechatSessionData.url = _webURL.absoluteString;
//    [UMSocialData defaultData].extConfig.wechatSessionData.title = _shareTitle;
//    [UMSocialData defaultData].extConfig.wechatTimelineData.url = _webURL.absoluteString;
//    [UMSocialData defaultData].extConfig.wechatTimelineData.title = _shareTitle;
//    [UMSocialData defaultData].extConfig.wechatFavoriteData.url = _webURL.absoluteString;
//    [UMSocialData defaultData].extConfig.wechatFavoriteData.title = _shareTitle;
//    [UMSocialData defaultData].extConfig.qzoneData.url = _webURL.absoluteString;
//    [UMSocialData defaultData].extConfig.qzoneData.title = _shareTitle;
//
//
//    [UMSocialData defaultData].extConfig.sinaData.shareText = [NSString stringWithFormat:@"【%@】%@%@ @中安新闻客户端", (_shareTitle.length ? _shareTitle : @"中安新闻客户端"), (_shareText.length ? _shareText : @"来自中安新闻客户端的分享"), _webURL];
//
//    [UMSocialSnsService presentSnsIconSheetView:self
//                                         appKey:kUMengAppKey
//                                      shareText:_shareText
//                                     shareImage:[UIImage imageNamed:@"icon_120.png"]
//                                shareToSnsNames:@[UMShareToWechatTimeline, UMShareToWechatSession, UMShareToSina, UMShareToQzone, UMShareToQQ, UMShareToWechatFavorite]
//                                       delegate:self];
}

- (void)favouriteAction
{
    
}

#pragma mark - NJKWebViewProgressDelegate
-(void)webViewProgress:(NJKWebViewProgress *)webViewProgress updateProgress:(float)progress
{
    [_progressView setProgress:progress animated:YES];
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [HZLoadingHUD showUserInteractionDisabledHUDInView:self.view];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [HZLoadingHUD hideHUDInView:self.view];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [HZLoadingHUD hideHUDInView:self.view];
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
