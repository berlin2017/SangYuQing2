//
//  HZVideoPlayerView.h
//  Demo
//
//  Created by History on 14/11/10.
//  Copyright (c) 2014年 ahnews. All rights reserved.
//

#import <UIKit/UIKit.h>

@import CoreMedia;

typedef NS_ENUM(NSInteger, HZVideoPlayerPlaybackState) {
    HZVideoPlayerPlaybackStateStopped = 0,
    HZVideoPlayerPlaybackStatePlaying,
    HZVideoPlayerPlaybackStatePaused,
    HZVideoPlayerPlaybackStateFailed
};

typedef NS_ENUM(NSUInteger, HZVideoPlayerScreenMode) {
    HZVideoPlayerScreenModeDefault = 0,
    HZVideoPlayerScreenModeFull,
};

@class HZVideoPlayerView;

@protocol HZVideoPlayerViewDelegate <NSObject>

@optional
- (void)didPlayEndOfVideoPlayerView:(HZVideoPlayerView *)playerView;
- (void)readyForStartPlayingOfVideoPlayerView:(HZVideoPlayerView *)playerView;
- (void)cantPlayOfVideoPlayerView:(HZVideoPlayerView *)playerView;
- (void)networkNotBestOfVideoPlayerView:(HZVideoPlayerView *)playerView;
- (void)closeVideoPlayerView:(HZVideoPlayerView *)playerView;
- (void)playerView:(HZVideoPlayerView *)playerView changeToScreenMode:(HZVideoPlayerScreenMode)screenMode;
@end

@interface HZVideoPlayerView : UIView
@property (nonatomic, weak) id<HZVideoPlayerViewDelegate> delegate;
@property (nonatomic, assign) HZVideoPlayerPlaybackState playbackState;
@property (nonatomic, strong) NSURL *videoURL;
@property (nonatomic, readonly) CGFloat totalTime;
@property (nonatomic, readonly) CMTimeScale timeScale;

@property (nonatomic, assign) CGFloat bufferTime;
@property (nonatomic, assign) CGFloat currentPlayerTime;

@property (nonatomic, assign, readonly) BOOL fullScreen;

- (instancetype)initWithVideoURL:(NSURL *)URL;
- (void)speed:(CMTime)speedValue;
- (void)play;
- (void)pause;
- (void)repeatPlaying;
@end
