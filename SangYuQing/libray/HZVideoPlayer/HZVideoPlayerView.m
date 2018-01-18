//
//  HZVideoPlayerView.m
//  Demo
//
//  Created by History on 14/11/10.
//  Copyright (c) 2014年 ahnews. All rights reserved.
//

#import "HZVideoPlayerView.h"
#import <AVFoundation/AVFoundation.h>
#import "HZVideoPlayerBottomView.h"
#import "HZSystemInfoManager.h"

void *HZPlayer = &HZPlayer;

const CGFloat kVideoPlayerViewAnimationDuration = 0.3f;

const CGFloat kVideoPlayerBottomHeigh = 40.f;


@interface HZVideoPlayerView () <HZVideoPlayerBottomViewDelegate>
{
    UIView *_controlBar;
    UIProgressView *_progressView;
    UISlider *_sliderView;
    UIButton *_playButton;
    UIButton *_fullScreenButton;
    UILabel *_timeLabel;
    
    UIView *_playerView;
    
    UIButton *_closeButton;
    
    UIControl *_tapControl;
    
    BOOL _isPlay;
    BOOL _controlBarShow;
    
    CGRect _lastFrame;
    
}
@property (nonatomic, strong) AVPlayer *player;

@end
@implementation HZVideoPlayerView
- (instancetype)initWithVideoURL:(NSURL *)URL
{
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        
        _tapControl = [[UIControl alloc] init];
        [_tapControl addTarget:self action:@selector(tapPlayerViewAction) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_tapControl];
        [_tapControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(self);
        }];

        // init control bar
        _controlBar = [[UIView alloc] init];
        _controlBar.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.4];
        [self addSubview:_controlBar];
        [_controlBar mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.mas_equalTo(self);
            make.height.mas_equalTo(kVideoPlayerBottomHeigh);
        }];
        
        _playButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_controlBar addSubview:_playButton];
        [_playButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_controlBar);
            make.left.mas_equalTo(_controlBar).offset(10);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        [_playButton setBackgroundImage:[UIImage imageNamed:@"VideoPlayer.bundle/player_play.png"] forState:UIControlStateNormal];
        [_playButton addTarget:self action:@selector(playButtonAction) forControlEvents:UIControlEventTouchUpInside];
        
        _sliderView = [[UISlider alloc] init];
        [_controlBar addSubview:_sliderView];
        [_sliderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_controlBar);
            make.left.mas_equalTo(_playButton.mas_right).offset(10);
        }];
        [_sliderView setThumbImage:[UIImage imageNamed:@"VideoPlayer.bundle/player_thumb.png"] forState:UIControlStateNormal];
        [_sliderView setThumbImage:[UIImage imageNamed:@"VideoPlayer.bundle/player_thumb.png"] forState:UIControlStateHighlighted];
        [_sliderView setMinimumTrackImage:[[UIImage imageNamed:@"VideoPlayer.bundle/player_leftslider.png"] resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
        [_sliderView setMaximumTrackImage:[[UIImage imageNamed:@"VideoPlayer.bundle/player_rightslider.png"] resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
        [_sliderView addTarget:self action:@selector(sliderViewTouchUpInsideAction) forControlEvents:UIControlEventTouchUpInside];
        [_sliderView addTarget:self action:@selector(sliderViewTouchDownAction) forControlEvents:UIControlEventTouchDown];
        
        _fullScreenButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_controlBar addSubview:_fullScreenButton];
        [_fullScreenButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.mas_equalTo(_controlBar);
            make.left.mas_equalTo(_sliderView.mas_right).offset(10);
            make.right.mas_equalTo(_controlBar).offset(-10);
            make.size.mas_equalTo(CGSizeMake(20, 20));
        }];
        [_fullScreenButton setBackgroundImage:[UIImage imageNamed:@"VideoPlayer.bundle/player_fullscreen.png"] forState:UIControlStateNormal];
        [_fullScreenButton addTarget:self action:@selector(fullScreenButtonAction) forControlEvents:UIControlEventTouchUpInside];
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.font = [UIFont systemFontOfSize:12.f];
        [_controlBar addSubview:_timeLabel];
        [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.mas_equalTo(_fullScreenButton.mas_left).offset(-10);
            make.bottom.mas_equalTo(_controlBar).offset(-2);
        }];
        
        _closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self addSubview:_closeButton];
        [_closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.mas_equalTo(self);
            make.size.mas_equalTo(CGSizeMake(30, 30));
        }];
        [_closeButton setNormalBgImage:@"VideoPlayer.bundle/player_exit.png" highlightedBgImage:nil];
        [_closeButton addTarget:self action:@selector(closeVideoPlayerView) forControlEvents:UIControlEventTouchUpInside];
        
        [self setVideoURL:URL];
        
        [self addCurrentPlayerTimeKVO];
    
    }
    return self;
}

- (void)playButtonAction
{
    _isPlay = !_isPlay;
    if (_isPlay) {
        [self play];
    }
    else {
        [self pause];
    }
}

- (void)sliderViewTouchUpInsideAction
{
    CMTime cmTime = CMTimeMake(_sliderView.value * _totalTime, 1);
    [self speed:cmTime];
    [self addCurrentPlayerTimeKVO];
}
- (void)sliderViewTouchDownAction
{
    [self removeCurrentPlayerTimeKVO];
}

- (void)fullScreenButtonAction
{
    _fullScreen = !_fullScreen;
    
    [UIView animateWithDuration:kVideoPlayerViewAnimationDuration
                     animations:^{
                         if (_fullScreen) {
                             
                             _lastFrame = self.frame;
                             
                             self.transform = CGAffineTransformMakeRotation(M_PI_2);
                             self.frame = [UIScreen mainScreen].bounds;
                             
                             [_controlBar mas_remakeConstraints:^(MASConstraintMaker *make) {
                                 make.left.mas_equalTo(self);
                                 make.top.mas_equalTo(self).offset(CGRectGetWidth(self.frame) - 40);
                                 make.height.mas_equalTo(kVideoPlayerBottomHeigh);
                                 make.width.mas_equalTo(CGRectGetHeight(self.frame));
                             }];
                             [_tapControl mas_remakeConstraints:^(MASConstraintMaker *make) {
                                 make.left.top.mas_equalTo(self);
                                 make.size.mas_equalTo(CGSizeMake(CGRectGetHeight(self.frame), CGRectGetWidth(self.frame)));
                             }];
                             
                             [_closeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                                 make.top.mas_equalTo(self);
                                 make.left.mas_equalTo(self).offset(CGRectGetHeight(self.frame) - 30);
                                 make.size.mas_equalTo(CGSizeMake(30, 30));
                             }];
                         }
                         else {
                             self.transform = CGAffineTransformIdentity;
                             
                             self.frame = _lastFrame;
                             
                             [_controlBar mas_remakeConstraints:^(MASConstraintMaker *make) {
                                 make.left.right.bottom.mas_equalTo(self);
                                 make.height.mas_equalTo(kVideoPlayerBottomHeigh);
                             }];
                             [_tapControl mas_remakeConstraints:^(MASConstraintMaker *make) {
                                 make.edges.mas_equalTo(self);
                             }];
                             
                             [_closeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
                                 make.top.right.mas_equalTo(self);
                                 make.size.mas_equalTo(CGSizeMake(30, 30));
                             }];
                         }
                     }
                     completion:^(BOOL finished) {
                         
                         if ([_delegate respondsToSelector:@selector(playerView:changeToScreenMode:)]) {
                             [_delegate playerView:self changeToScreenMode:_fullScreen ? HZVideoPlayerScreenModeFull : HZVideoPlayerScreenModeDefault];
                         }
                     }];
}

- (void)tapPlayerViewAction
{
    [self setControlBarShow:!_controlBarShow];
}

- (void)closeVideoPlayerView
{
    _fullScreen = NO;
    
    [self pause];
    
    if ([_delegate respondsToSelector:@selector(closeVideoPlayerView:)]) {
        [_delegate closeVideoPlayerView:self];
    }
    
    [self removeFromSuperview];
    
}

#pragma mark -
- (void)addCurrentPlayerTimeKVO
{
    [self addObserver:self forKeyPath:@"currentPlayerTime" options:NSKeyValueObservingOptionNew context:NULL];
}

- (void)removeCurrentPlayerTimeKVO
{
    [self removeObserver:self forKeyPath:@"currentPlayerTime"];
}

- (void)play
{
    [_playButton setNormalBgImage:@"VideoPlayer.bundle/player_pause.png" highlightedBgImage:nil];
    
    [self.player play];
    _playbackState = HZVideoPlayerPlaybackStatePlaying;
    
    [self performSelector:@selector(setControlBarShow:) withObject:@(NO) afterDelay:5];
}

- (void)pause
{
    [_playButton setNormalBgImage:@"VideoPlayer.bundle/player_play.png" highlightedBgImage:nil];
    
    [self.player pause];
    _playbackState = HZVideoPlayerPlaybackStatePaused;
}

- (void)repeatPlaying
{
    [self.player seekToTime:kCMTimeZero];
    [self play];
}

- (void)speed:(CMTime)speedTime
{
    [self.player.currentItem seekToTime:speedTime];
    
}

- (void)setControlBarShow:(BOOL)show
{
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(setControlBarShow:) object:@(NO)];
    
    [UIView animateWithDuration:kVideoPlayerViewAnimationDuration
                     animations:^{
                         _controlBar.alpha = show ? 1.f : 0.f;
                     }
                     completion:^(BOOL finished) {
                         _controlBarShow = show;
                         if (_controlBarShow) {
                             [self performSelector:@selector(setControlBarShow:) withObject:@(NO) afterDelay:5];
                         }
                         else {
                             [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(setControlBarShow:) object:@(NO)];
                         }
                     }];
}

#pragma mark -

- (void)setVideoURL:(NSURL *)videoURL
{
    if (_videoURL != videoURL) {
        AVAsset *movieAsset = [AVURLAsset URLAssetWithURL:videoURL options:nil];
        [self __setAssert:movieAsset];
        _videoURL = videoURL;
    }
}

#pragma mark __set
- (void)__setAssert:(AVAsset *)assert
{
    AVPlayerItem *playerItem = [AVPlayerItem playerItemWithAsset:assert];
    self.player =[AVPlayer playerWithPlayerItem:playerItem];
    [self.player addObserver:self forKeyPath:@"rate" options:NSKeyValueObservingOptionNew context:HZPlayer];
    
    [playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    
    [playerItem addObserver:self forKeyPath:@"loadedTimeRanges"options:NSKeyValueObservingOptionNew context:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self  selector:@selector(moviePlayDidEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:playerItem];
    
}


- (void)moviePlayDidEnd:(NSNotification *)nac
{
    _playbackState = HZVideoPlayerPlaybackStateStopped;
    
    if ([_delegate respondsToSelector:@selector(didPlayEndOfVideoPlayerView:)]) {
        [_delegate didPlayEndOfVideoPlayerView:self];
    }
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    AVPlayerItem *playerItem = (AVPlayerItem *)object;
    
    if ([keyPath isEqualToString:@"status"]) {
        
        if ([playerItem status] == AVPlayerStatusReadyToPlay) {
            
            [self.player pause];
            _timeScale = playerItem.currentTime.timescale;
            CMTime duration = self.player.currentItem.duration;
            
            _totalTime = CMTimeGetSeconds(duration);
            _timeLabel.text = [NSString stringWithFormat:@"%@/%@", [self timeStringWithTime:self.currentPlayerTime], [self timeStringWithTime:self.totalTime]];
            if ([_delegate respondsToSelector:@selector(readyForStartPlayingOfVideoPlayerView:)]) {
                [_delegate readyForStartPlayingOfVideoPlayerView:self];
            }
            _playbackState = HZVideoPlayerPlaybackStatePaused;
            
            
            [self monitoringPlayback:self.player.currentItem];
            
        }
        else if ([playerItem status] == AVPlayerStatusFailed) {
            if ([_delegate respondsToSelector:@selector(cantPlayOfVideoPlayerView:)]) {
                [_delegate cantPlayOfVideoPlayerView:self];
            }
        }
    }
    else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        _bufferTime = [self availableDuration];

        NSInteger rate = [[NSString stringWithFormat:@"%f",self.player.rate] integerValue];
        
        if (_playbackState == HZVideoPlayerPlaybackStatePlaying && !rate) {
            
            if ([_delegate respondsToSelector:@selector(networkNotBestOfVideoPlayerView:)]) {
                [_delegate networkNotBestOfVideoPlayerView:self];
            }
            CGFloat ti = [[NSString stringWithFormat:@"%f", _bufferTime] floatValue];
            if (ti > _currentPlayerTime + 2) {
                [self.player play];
            }
        }
    }
    else if ([keyPath isEqualToString:@"currentPlayerTime"]) {
        CGFloat progress = self.currentPlayerTime / self.totalTime;
        if (progress < 0 || progress > 1) {
            return;
        }
        _sliderView.value = progress;
        _timeLabel.text = [NSString stringWithFormat:@"%@/%@", [self timeStringWithTime:self.currentPlayerTime], [self timeStringWithTime:self.totalTime]];
    }
}

- (NSString *)timeStringWithTime:(NSInteger)seconds
{
    NSInteger second = seconds % 60;
    NSInteger minute = seconds / 60;
    return [NSString stringWithFormat:@"%02li:%02li", (long)minute, (long)second];
}

- (NSTimeInterval)availableDuration
{
    NSArray *loadedTimeRanges = [[self.player currentItem] loadedTimeRanges];
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSeconds;
    return result;
}
- (void)monitoringPlayback:(AVPlayerItem *)playerItem
{
    __weak typeof(self.player) weakPlayer = self.player;
    __weak typeof(self) weakSelf = self;
    [weakPlayer addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:NULL usingBlock:^(CMTime time) {
        CGFloat currentSecond = playerItem.currentTime.value / playerItem.currentTime.timescale;
        weakSelf.currentPlayerTime = currentSecond;
    }];
}

+ (Class)layerClass {
    return [AVPlayerLayer class];
}
- (AVPlayer *)player {
    return [(AVPlayerLayer *)[self layer] player];
}
- (void)setPlayer:(AVPlayer *)player {
    [(AVPlayerLayer *)[self layer] setPlayer:player];
}

- (void)dealloc
{
    [self removeCurrentPlayerTimeKVO];
    AVPlayerItem *currentItem = self.player.currentItem;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:currentItem];
    [self.player removeObserver:self forKeyPath:@"rate"];
    [currentItem removeObserver:self forKeyPath:@"status"];
    [currentItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
}
@end
