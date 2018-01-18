//
//  HZImageShowViewController.m
//  AnhuiNews
//
//  Created by History on 15/6/3.
//  Copyright (c) 2015年 ahnews. All rights reserved.
//

#import "ZANImageShowViewController.h"

const NSInteger kHZImageScrollViewBaseTag = 3000;
const NSInteger kHZImageViewTag           = 1000;

@interface ZANImageShowViewController () <UIScrollViewDelegate>
{
    UIView *_contentView;
    UIScrollView *_scrollView;
    NSInteger _numberOfImages;
    
    UILabel *_pageLabel;
    BOOL _hideNavigationbar;
}
@property (nonatomic, strong) NSMutableArray *imageURLArray;
@property (nonatomic, strong) NSMutableArray *imageTextArray;
@property (nonatomic, strong) NSMutableArray *imageDataArray;
@end

@implementation ZANImageShowViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _scrollView = [[UIScrollView alloc]init];
    [self.view addSubview:_scrollView];
    [_scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self.view);
    }];
    
    _pageLabel = [[UILabel alloc]init];
    [self.view addSubview:_pageLabel];
    [_pageLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view).mas_offset(10);
        make.bottom.mas_equalTo(self.view).mas_offset(-20);
    }];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.delegate =self;
    
    self.view.backgroundColor = [UIColor blackColor];
    
    [self setup];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self.navigationController action:@selector(popViewControllerAnimated:)];
    [self.view addGestureRecognizer:tapGesture];
    
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    _scrollView.contentOffset = CGPointMake([UIScreen mainScreen].bounds.size.width * _currentIndex, 0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setDataSource:(id<HZImageShowViewControllerDataSource>)dataSource
{
    if (_dataSource != dataSource) {
        _dataSource = dataSource;
        [self reloadData];
    }
}

- (void)reloadData
{
    _numberOfImages = [_dataSource numberOfImages:self];
    
    if ([_dataSource respondsToSelector:@selector(imageShowViewController:imageDataAtIndex:)]) {
        _imageDataArray = [NSMutableArray array];
        for (NSInteger index = 0; index < _numberOfImages; ++ index) {
            [_imageDataArray addObject:[_dataSource imageShowViewController:self imageDataAtIndex:index]];
        }
    }
    else if ([_dataSource respondsToSelector:@selector(imageShowViewController:imageURLAtIndex:)]) {
        _imageURLArray = [NSMutableArray array];
        for (NSInteger index = 0; index < _numberOfImages; ++ index) {
            [_imageURLArray addObject:[_dataSource imageShowViewController:self imageURLAtIndex:index]];
        }
    }
    
    if ([_dataSource respondsToSelector:@selector(imageShowViewController:imageTextAtIndex:)]) {
        _imageTextArray = [NSMutableArray array];
        for (NSInteger index = 0; index < _numberOfImages; ++ index) {
            NSString *text = [_dataSource imageShowViewController:self imageTextAtIndex:index];
            if (text) {
                [_imageTextArray addObject:text];
            }
        }
    }
}

- (void)setup
{
    if (!_contentView) {
        _contentView = [[UIView alloc] init];
        _contentView.backgroundColor = [UIColor blackColor];
        [_scrollView addSubview:_contentView];
        
        [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(_scrollView);
            make.height.mas_equalTo(_scrollView);
        }];
    }
    
    [_contentView removeAllSubViews];
    
    if (_numberOfImages <= 0) {
        return;
    }
    
    UIScrollView *lastView = nil;
    for (NSInteger index = 0; index < _numberOfImages; ++ index) {
        UIScrollView *view = [[UIScrollView alloc] init];
        view.tag = kHZImageScrollViewBaseTag + index;
        view.delegate = self;
        view.backgroundColor = [UIColor blackColor];
        [_contentView addSubview:view];
        
        if (lastView) {
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(_contentView.mas_top);
                make.left.mas_equalTo(lastView.mas_right);
                make.bottom.mas_equalTo(_contentView.mas_bottom);
                make.width.mas_equalTo(lastView.mas_width);
            }];
        }
        else {
            [view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.mas_equalTo(_contentView.mas_top);
                make.left.mas_equalTo(_contentView.mas_left);
                make.bottom.mas_equalTo(_contentView.mas_bottom);
            }];
        }
        lastView = view;
        
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.tag = kHZImageViewTag;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [view addSubview:imageView];
//        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
//            make.left.mas_equalTo(_scrollView);
//            make.right.mas_equalTo(_scrollView);
//        }];
        
        if (_imageDataArray) {
            imageView.image = _imageDataArray[index];
            [self updateImageViewWithImageScrollView:view];
        }
        else if (_imageURLArray) {
            NSURL *URL = _imageURLArray[index];
            [[SDWebImageManager sharedManager] setCacheKeyFilter:^(NSURL *url) {
                return [url.absoluteString md5];
            }];
            NSString *key = [[SDWebImageManager sharedManager] cacheKeyForURL:URL];
            UIImage *cachedImage = [[SDImageCache sharedImageCache] imageFromDiskCacheForKey:key];
            if (cachedImage) {
                [imageView setImage:cachedImage];
                [self updateImageViewWithImageScrollView:view];
            }
            else {
                [imageView sd_setImageWithURL:URL
                             placeholderImage:[UIImage bigLogoPicture]
                                    completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                                        
                                        [self updateImageViewWithImageScrollView:view];
                                    }];
            }
        }
        else {
            
        }
    }
    [_contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(_scrollView.mas_width).multipliedBy(_numberOfImages);
        make.right.mas_equalTo(lastView.mas_right);
        make.height.mas_equalTo(_scrollView.mas_height);
    }];
    [self updateImageTextLableAtIndex:_currentIndex];
}

#pragma mark -
- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
    UIView *imageView = [scrollView viewWithTag:kHZImageViewTag];
    return imageView;
}

- (void)scrollViewDidEndZooming:(UIScrollView *)scrollView withView:(UIView *)view atScale:(CGFloat)scale
{
    [scrollView setZoomScale:scale animated:NO];
}

- (void)scrollViewDidZoom:(UIScrollView *)scrollView
{
    UIImageView *imageView = (UIImageView *)[scrollView viewWithTag:kHZImageViewTag];
    CGFloat offsetX = (scrollView.width > scrollView.contentSize.width) ?
    (scrollView.width - scrollView.contentSize.width) * 0.5 : 0.0;
    CGFloat offsetY = (scrollView.height > scrollView.contentSize.height) ?
    (scrollView.height - scrollView.contentSize.height) * 0.5 : 0.0;
    imageView.center = CGPointMake(scrollView.contentSize.width * 0.5 + offsetX,
                                   scrollView.contentSize.height * 0.5 + offsetY);
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (_scrollView == scrollView) {
        NSInteger contentOffsetX = scrollView.contentOffset.x;
        NSInteger index = floor((contentOffsetX - scrollView.width / 2) / scrollView.width)+1;
        if (index >= 0 && index < _numberOfImages) {
            [self updateImageTextLableAtIndex:index];
            [self resetScaleOfIndex:_currentIndex];
            _currentIndex = index;
        }
    }
}


- (void)resetScaleOfIndex:(NSInteger)index
{
    UIScrollView *imageScrollView = (UIScrollView *)[_contentView viewWithTag:kHZImageScrollViewBaseTag + index];
    [imageScrollView setZoomScale:1.f animated:YES];
}

- (void)updateImageViewWithImageScrollView:(UIScrollView *)scrollView
{
    UIImageView *imageView = (UIImageView *)[scrollView viewWithTag:kHZImageViewTag];
    if (imageView.image) {
        CGFloat scale = [self updateImageSizeWithImageView:imageView];
        [scrollView setMinimumZoomScale:0.9];
        [scrollView setMaximumZoomScale:scale + 2.5];
        [scrollView setZoomScale:1.0];
    }
}

- (CGFloat)updateImageSizeWithImageView:(UIImageView *)imageView
{
    const CGFloat kPictureXYOffset = 0.f;
    if (imageView.image) {
        CGFloat width = imageView.image.size.width * imageView.image.scale;
        CGFloat height = imageView.image.size.height * imageView.image.scale;
        CGFloat scale = 1.f;
        if (width > (self.view.width - 2 * kPictureXYOffset)) {
            scale = (self.view.width - 2 * kPictureXYOffset) / width;
        }
        height *= scale;
        width *= scale;
        if (height > (self.view.height - 2 * kPictureXYOffset)) {
            scale = (self.view.height - 2 * kPictureXYOffset) / height;
            height *= scale;
            width *= scale;
        }
        imageView.frame = CGRectMake((self.view.width - width) / 2, (self.view.height - height) / 2, width, height);
        return scale;
    }
    else {
        return 1.f;
    }
}

- (void)updateImageTextLableAtIndex:(NSInteger)index
{
    NSString *string = [NSString stringWithFormat:@"%@/%@", @(index + 1), @(_numberOfImages)];
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:string];
    [attributedString setForegroundColor:[HZThemeManager pageControlHighlightedColor] range:NSRangeMake(0, [string rangeOfString:@"/"].location)];
    [attributedString setForegroundColor:[HZThemeManager pageControlNormalColor] range:NSRangeMake([string rangeOfString:@"/"].location, string.length - [string rangeOfString:@"/"].location)];
    [attributedString setFont:[HZThemeManager pageControlHighlightedFont] range:NSRangeMake(0, [string rangeOfString:@"/"].location)];
    [attributedString setFont:[HZThemeManager pageControlNormalFont] range:NSRangeMake([string rangeOfString:@"/"].location, string.length - [string rangeOfString:@"/"].location)];
    _pageLabel.attributedText = attributedString;
    
    _pageLabel.attributedText = attributedString;
    NSString *imageText = nil;
    if (_imageTextArray.count > index) {
        imageText = _imageTextArray[index];
    }
    
}

@end
