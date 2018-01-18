//
//  HZVideoPlayerBottomView.m
//  Demo
//
//  Created by History on 14/11/11.
//  Copyright (c) 2014年 ahnews. All rights reserved.
//

#import "HZVideoPlayerBottomView.h"

@interface HZVideoPlayerBottomView ()
{
    __weak IBOutlet UIProgressView *_progress;
    __weak IBOutlet UISlider *_slider;
    BOOL _isPlay;
    BOOL _isFullScreen;
    __weak IBOutlet UIButton *_playButton;
    __weak IBOutlet UILabel *_timeLabel;
    __weak IBOutlet UIButton *_fullScreenButton;
    
    BOOL _touchDown;
}
@end
@implementation HZVideoPlayerBottomView
- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [_slider setThumbImage:[UIImage imageNamed:@"VideoPlayer.bundle/player_thumb.png"] forState:UIControlStateNormal];
    [_slider setThumbImage:[UIImage imageNamed:@"VideoPlayer.bundle/player_thumb.png"] forState:UIControlStateHighlighted];
    [_slider setMinimumTrackImage:[[UIImage imageNamed:@"VideoPlayer.bundle/player_leftslider.png"] resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
    [_slider setMaximumTrackImage:[[UIImage imageNamed:@"VideoPlayer.bundle/player_rightslider.png"] resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeStretch] forState:UIControlStateNormal];
    _isFullScreen = NO;
    _isPlay = NO;
    _touchDown = NO;
    
    [_fullScreenButton setBackgroundImage:[UIImage imageNamed:@"VideoPlayer.bundle/player_fullscreen.png"] forState:UIControlStateNormal];
    [_playButton setBackgroundImage:[UIImage imageNamed:@"VideoPlayer.bundle/player_play.png"] forState:UIControlStateNormal];
}


- (IBAction)playAction:(id)sender
{
    _isPlay = !_isPlay;
    if (_isPlay) {
        [_playButton setNormalBgImage:@"VideoPlayer.bundle/player_pause.png" highlightedBgImage:nil];
    }
    else {
        [_playButton setNormalBgImage:@"VideoPlayer.bundle/player_play.png" highlightedBgImage:nil];
    }
    if ([_delegate respondsToSelector:@selector(didClickPlay:)]) {
        [_delegate didClickPlay:_isPlay];
    }
}

- (IBAction)fullScreenAction:(id)sender
{
    _isFullScreen = !_isFullScreen;
    if ([_delegate respondsToSelector:@selector(didClickFullScreen:)]) {
        [_delegate didClickFullScreen:_isFullScreen];
    }
}

- (IBAction)sliderValueChangedAction:(id)sender
{
    
}

- (IBAction)touchUpInsideAction:(id)sender
{
    if ([_delegate respondsToSelector:@selector(didDragSlider:)]) {
        [_delegate didDragSlider:_slider.value];
    }
}
- (IBAction)touchDownAction:(id)sender
{
    if ([_delegate respondsToSelector:@selector(willDragSlider)]) {
        [_delegate willDragSlider];
    }
}

- (void)setProgress:(CGFloat)progress
{
    if (progress < 0 || progress > 1) {
        return;
    }
    _slider.value = progress;
}
- (void)setTimeLabelText:(NSString *)timeLabelText
{
    _timeLabel.text = timeLabelText;
}
@end
