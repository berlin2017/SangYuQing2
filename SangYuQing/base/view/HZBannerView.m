//
//  HZBannerView.m
//  HZSegmentViewDemo
//
//  Created by History on 15/3/5.
//  Copyright (c) 2015年 History. All rights reserved.
//

#import "HZBannerView.h"
#import "iCarousel.h"
#import "UIImageView+WebCacheExtension.h"
#import "NSAttributedString+Helper.h"

@interface HZBannerView () <iCarouselDataSource, iCarouselDelegate>
{
    iCarousel *_iCarousel;
    
    NSInteger _numberOfItems;
    
    UIView *_titleBgView;
    
    UILabel *_titleLabel;
    
    UILabel *_pageLabel;
    UIPageControl *_pageControl;

    MASConstraint *_pageBgViewWidthConstraint;
    
    BOOL _sholdShowTitleLable;
    
    NSTimer *_timer;
}
@property (strong, nonatomic) UIImage *placeholderImage;
@end
@implementation HZBannerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)init
{
    self = [super init];
    if (self) {
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _mode = HZBannerViewModeCustom;
        [self setup];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        _mode = HZBannerViewModeCustom;
        [self setup];
    }
    return self;
}

- (instancetype)initWithMode:(HZBannerViewMode)mode
{
    self = [super init];
    if (self) {
        self.translatesAutoresizingMaskIntoConstraints = NO;
        _mode = mode;
        [self setup];
    }
    return self;
}
#pragma mark - Private
- (void)setup
{
    _sholdShowTitleLable = YES;
    
    _iCarousel = [[iCarousel alloc] init];
    _iCarousel.dataSource = self;
    _iCarousel.delegate = self;
    _iCarousel.decelerationRate = 0.7;
    _iCarousel.type = iCarouselTypeLinear;
    _iCarousel.pagingEnabled = YES;
    _iCarousel.bounceDistance = 0.4;
    _iCarousel.backgroundColor = [UIColor whiteColor];
    [self addSubview:_iCarousel];
    [_iCarousel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
    
    
    _titleBgView = [[UIView alloc] init];
    _titleBgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    [self addSubview:_titleBgView];
    [_titleBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.and.bottom.mas_equalTo(self).with.insets(UIEdgeInsetsZero);
        make.height.mas_equalTo(30.f);
    }];
    
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.backgroundColor = [UIColor clearColor];
    _titleLabel.font = [UIFont systemFontOfSize:15.f];
    _titleLabel.textColor = [UIColor whiteColor];
    [_titleBgView addSubview:_titleLabel];
    [_titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_titleBgView).with.insets(UIEdgeInsetsMake(0, 10, 0, 40));
    }];
    
    if (HZBannerViewModeCustom == _mode) {
        _pageLabel = [[UILabel alloc] init];
        _pageLabel.backgroundColor = [UIColor clearColor];
        _pageLabel.textAlignment = NSTextAlignmentRight;
        [_titleBgView addSubview:_pageLabel];
        [_pageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.and.bottom.mas_equalTo(_titleBgView).with.insets(UIEdgeInsetsMake(0, 0, 0, 5));
            make.width.mas_equalTo(40.f);
        }];
    }
    else {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.currentPageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.pageIndicatorTintColor = [UIColor whiteColor];
        _pageControl.hidesForSinglePage = YES;
        [_titleBgView addSubview:_pageControl];
        [_pageControl mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.right.and.bottom.mas_equalTo(_titleBgView).with.insets(UIEdgeInsetsMake(0, 0, 0, 5));
        }];
    }
    
    //edit by berlin
    [_titleBgView removeFromSuperview];
}


- (void)updateConstraints
{
    [super updateConstraints];
}

- (void)setDataSource:(id<HZBannerViewDataSource>)dataSource
{
    if (_dataSource != dataSource) {
        _dataSource = dataSource;
        [self reloadData];
    }
}

- (void)reloadData
{
    _numberOfItems = [_dataSource numberOfBannerView:self];
    
    if ([_dataSource respondsToSelector:@selector(shouldShowTitleLableOfBannerView:)]) {
        _sholdShowTitleLable = [_dataSource shouldShowTitleLableOfBannerView:self];
    }
    
    if (_numberOfItems <= 1) {
        _iCarousel.scrollEnabled = NO;
    }
    else {
        _iCarousel.scrollEnabled = YES;
    }
    
    if ([_dataSource respondsToSelector:@selector(placeholderImageOfBannerView:)]) {
        _placeholderImage = [_dataSource placeholderImageOfBannerView:self];
    }
    if (HZBannerViewModeDefault == _mode) {
        _pageControl.numberOfPages = _numberOfItems;
        [self setNeedsUpdateConstraints];
        if (_numberOfItems <= 1) {
            _pageLabel.hidden = YES;
            _pageControl.hidden = YES;
        }
        else {
            _pageLabel.hidden = NO;
            _pageControl.hidden = NO;
        }
    }
    [_iCarousel reloadData];
    [self updatePageLabelText];
    [self updateImageText];
    
    [self startTimer];
}

- (void)updatePageLabelText
{
    if (HZBannerViewModeCustom == _mode) {
        NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@/%@", @(_iCarousel.currentItemIndex + 1), @(_numberOfItems)]];
        NSRange r;
        r.location = 0;
        r.length = 1;
        [attributedString setForegroundColor:[UIColor whiteColor] range:r];
        NSRange r2;
        r2.location = 1;
        r2.length = 2;
        
        [attributedString setForegroundColor:[UIColor grayColor] range:r2];
//        [attributedString setFont:[HZThemeManager pageControlHighlightedFont] range:NSRangeMake(0, 1)];
//        [attributedString setFont:[HZThemeManager pageControlNormalFont] range:NSRangeMake(1, 2)];
        _pageLabel.attributedText = attributedString;
    }
    else {
        _pageControl.currentPage = _iCarousel.currentItemIndex;
    }
}

- (void)updateImageText
{
    if (!_sholdShowTitleLable) {
        _titleLabel.hidden = YES;
        _titleBgView.backgroundColor = [UIColor clearColor];
    }
    else {
        _titleLabel.hidden = NO;
        if ([_dataSource respondsToSelector:@selector(bannerView:imageTextAtIndex:)]) {
            _titleLabel.text = [_dataSource bannerView:self imageTextAtIndex:_iCarousel.currentItemIndex];
            _titleBgView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
        }
    }
}

#pragma mark - iCarousel DataSource & Delegate
- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return _numberOfItems;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    NSURL *URL = [_dataSource bannerView:self imageURLAtIndex:index];
    UIImage *image = [_dataSource bannerView:self imageAtIndex:index];
    UIImageView *imageView = nil;
    if (!view) {
        view = [[UIView alloc] initWithFrame:carousel.bounds];
        view.backgroundColor = [UIColor whiteColor];
        imageView = [[UIImageView alloc] init];
        imageView.contentMode = UIViewContentModeScaleToFill;
        imageView.tag = 1;
        [view addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(view);
        }];
    }
    else {
        imageView = (UIImageView *)[view viewWithTag:1];
    }
    
    if (URL) {
      [imageView sd_extension_setImageWithURL:URL placeholderImage:_placeholderImage];
    }else{
         imageView.image = image;
    }
    
    return view;
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    if (iCarouselOptionWrap == option) {
        return 1.f;
    }
    else {
        return value;
    }
}

- (void)carousel:(iCarousel *)carousel didSelectItemAtIndex:(NSInteger)index
{
    if ([_delegate respondsToSelector:@selector(bannerView:didClickIndex:)]) {
        [_delegate bannerView:self didClickIndex:index];
    }
}

- (void)carouselDidEndScrollingAnimation:(iCarousel *)carousel
{
    
}

- (void)carouselDidScroll:(iCarousel *)carousel
{
    if (carousel.currentItemIndex < 0) {
        return;
    }
    [self updatePageLabelText];
    [self updateImageText];
}

#pragma mark - Timer
- (void)startTimer
{
    [self stopTimer];
    _timer = [NSTimer scheduledTimerWithTimeInterval:5.f target:self selector:@selector(roolToNextPage) userInfo:nil repeats:YES];
}

- (void)roolToNextPage
{
    [_iCarousel scrollToItemAtIndex:(_iCarousel.currentItemIndex + 1) % _numberOfItems animated:YES];
}
- (void)stopTimer
{
    if (_timer) {
        [_timer invalidate];
        _timer = nil;
    }
}
- (void)dealloc
{
    [self stopTimer];
}
@end
