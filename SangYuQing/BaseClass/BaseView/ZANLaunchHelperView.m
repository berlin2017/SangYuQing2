//
//  AHNLaunchHelperView.m
//  AnhuiNews
//
//  Created by History on 14-10-14.
//  Copyright (c) 2014年 ahnews. All rights reserved.
//

#import "ZANLaunchHelperView.h"
#import "HZSystemInfoManager.h"

@interface ZANLaunchHelperView () <UIScrollViewDelegate>
{
    __weak IBOutlet UIScrollView *_scrollView;
    NSInteger _count;
}
@end

@implementation ZANLaunchHelperView

- (void)awakeFromNib
{
    CGSize size = [[UIScreen mainScreen] bounds].size;
    
    NSArray *imageNameArray = @[@"LaunchHelper.bundle/launch_helper_1", @"LaunchHelper.bundle/launch_helper_2", @"LaunchHelper.bundle/launch_helper_3"];
    _count = imageNameArray.count;
    HZDeviceResolutionMode mode = [HZSystemInfoManager share].resolutionMode;
    NSString *appendString = @"";
    switch (mode) {
        case HZDeviceResolutionMode640X960:
        case HZDeviceResolutionMode768X1024:
        case HZDeviceResolutionMode1536X2048:
            appendString = @"_4.png";
            break;
        case HZDeviceResolutionMode640X1136:
        case HZDeviceResolutionMode750X1334:
        case HZDeviceResolutionMode1242X2208:
        case HZDeviceResolutionModeOthers:
        default:
            appendString = @"_5.png";
            break;
    }
    
    UIImageView *lastView = nil;
    
    for (NSInteger index = 0; index < _count; ++ index) {
        UIImageView *imageView = [[UIImageView alloc] init];
        NSString *imageRealName = [imageNameArray[index] stringByAppendingString:appendString];
        if (_count - 1 == index) {
            imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tanGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapLastImageViewAction:)];
            [imageView addGestureRecognizer:tanGesture];
        }
        imageView.image = [UIImage imageNamed:imageRealName];
        [self->_scrollView addSubview:imageView];
        
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self->_scrollView);
            make.size.mas_equalTo(CGSizeMake(size.width, size.height));
            if (lastView) {
                make.left.mas_equalTo(lastView.mas_right);
            }
            else {
                make.left.mas_equalTo(self->_scrollView);
            }
        }];
        
        lastView = imageView;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGSize size = [[UIScreen mainScreen] bounds].size;
    [_scrollView setContentSize:CGSizeMake(size.width * (_count + 1), size.height)];
}
+ (void)showInView:(UIView *)superView
{
    CGSize size = [[UIScreen mainScreen] bounds].size;
    ZANLaunchHelperView *launchAdView = HZLoadNib(kViewNibLaunchHelper);
    launchAdView.frame = CGRectMake(-size.width, 0, size.width, size.height);
    [superView addSubview:launchAdView];
    
    [UIView animateWithDuration:0.3
                     animations:^{
                         launchAdView.frame = CGRectMake(0, 0, size.width, size.height);
                     }
                     completion:^(BOOL finished) {
                         
                     }];
}

- (void)tapLastImageViewAction:(UITapGestureRecognizer *)recognizer
{
    [self dismissViewAnimation];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGSize size = [[UIScreen mainScreen] bounds].size;
    NSInteger contentOffsetX = scrollView.contentOffset.x;
    if (contentOffsetX > size.width * (_count - 0.5)) {
        [self dismissViewAnimation];
    }
}

- (void)dismissViewAnimation
{
    [UIView animateWithDuration:0.3
                     animations:^{
                         CGSize size = [[UIScreen mainScreen] bounds].size;
                         self.frame = CGRectMake(-size.width, 0, size.width, size.height);
                     }
                     completion:^(BOOL finished) {
                         [self performSelector:@selector(removeFromSuperview) withObject:nil afterDelay:2];
                     }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
