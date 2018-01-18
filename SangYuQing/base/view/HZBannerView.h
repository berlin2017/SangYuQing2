//
//  HZBannerView.h
//  HZSegmentViewDemo
//
//  Created by History on 15/3/5.
//  Copyright (c) 2015年 History. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HZBannerView;

typedef NS_ENUM(NSInteger, HZBannerViewMode) {
    HZBannerViewModeDefault = 0,
    HZBannerViewModeCustom
};

@protocol HZBannerViewDelegate <NSObject>

@optional
- (void)bannerView:(HZBannerView *)bannerView didClickIndex:(NSInteger)index;
@end

@protocol HZBannerViewDataSource <NSObject>

- (NSInteger)numberOfBannerView:(HZBannerView *)bannerView;
- (NSURL *)bannerView:(HZBannerView *)bannerView imageURLAtIndex:(NSInteger)index;

- (UIImage *)bannerView:(HZBannerView *)bannerView imageAtIndex:(NSInteger)index;

@optional
- (NSString *)bannerView:(HZBannerView *)bannerView imageTextAtIndex:(NSInteger)index;
- (UIImage *)placeholderImageOfBannerView:(HZBannerView *)bannerView;
- (UIColor *)highlightColorOfBannerView:(HZBannerView *)bannerView;
- (BOOL)shouldShowTitleLableOfBannerView:(HZBannerView *)bannerView;

@end
@interface HZBannerView : UIView
@property (nonatomic, weak) id<HZBannerViewDelegate> delegate;
@property (nonatomic, weak) id<HZBannerViewDataSource> dataSource;
@property (nonatomic, assign, readonly) HZBannerViewMode mode;
- (instancetype)initWithMode:(HZBannerViewMode)mode;
- (void)reloadData;
@end
