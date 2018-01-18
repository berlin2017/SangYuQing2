//
//  VideoPlayViewController.m
//  SangYuQing
//
//  Created by mac on 2018/1/10.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "VideoPlayViewController.h"
#import "HZVideoPlayerView.h"
#import "HZSystemInfoManager.h"

@interface VideoPlayViewController ()<HZVideoPlayerViewDelegate>
@property (strong, nonatomic) HZVideoPlayerView *playerView;
@end

@implementation VideoPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.playerView];
    [self.navigationController.navigationBar setHidden:YES];
}

- (HZVideoPlayerView *)playerView{
    if (!_playerView) {
        _playerView= [[HZVideoPlayerView alloc] initWithVideoURL:[NSURL URLWithString:@"http://www.hwsyq.com/data/video/2018/01/1514874517787.mp4"]];
        CGFloat height = CGRectGetHeight([UIApplication sharedApplication].statusBarFrame)+64;
        _playerView.frame = CGRectMake(0, height, [HZSystemInfoManager share].screenSize.width, [HZSystemInfoManager share].screenSize.width * 0.75);
        _playerView.delegate = self;
    }
   
    return _playerView;
}

- (void)closeVideoPlayerView:(HZVideoPlayerView *)playerView
{
    [self.navigationController popViewControllerAnimated:YES];
    [self setNeedsStatusBarAppearanceUpdate];
}
@end
