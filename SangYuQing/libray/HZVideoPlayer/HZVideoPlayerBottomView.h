//
//  HZVideoPlayerBottomView.h
//  Demo
//
//  Created by History on 14/11/11.
//  Copyright (c) 2014年 ahnews. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HZVideoPlayerBottomView;

@protocol HZVideoPlayerBottomViewDelegate <NSObject>

@optional
- (void)didClickFullScreen:(BOOL)fullScreen;
- (void)didClickPlay:(BOOL)playing;
- (void)didDragSlider:(CGFloat)progress;
- (void)willDragSlider;

@end
@interface HZVideoPlayerBottomView : UIView
@property (nonatomic, weak) id<HZVideoPlayerBottomViewDelegate> delegate;
- (void)setProgress:(CGFloat)progress;
- (void)setTimeLabelText:(NSString *)timeLabelText;
@end
