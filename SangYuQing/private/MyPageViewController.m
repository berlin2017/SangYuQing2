//
//  MyPageViewController.m
//  SangYuQing
//
//  Created by mac on 2018/1/18.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "MyPageViewController.h"



@interface MyPageViewController () <UIScrollViewDelegate>
{
    UIView *_segmentContainerView;
    UIView *_contentContainerView;
    UIView *_indicatorView;
    
    BOOL _doneLayout;
    
    BOOL _editMode;
    
    CGFloat kHZPageVcSegmentHeight         ;
    CGFloat kHZPageVcSegmentIndicatorHeight ;
    NSUInteger kHZPageVcMaxVisiblePages    ;
}
@property (assign, nonatomic) NSUInteger          numberOfContent;
@property (strong, nonatomic) NSMutableArray      *segmentTitles;
@property (strong, nonatomic) UIColor             *normalTextColor;
@property (strong, nonatomic) UIColor             *highlightedTextColor;
@property (assign, nonatomic) NSUInteger          currentIndex;
@property (assign, nonatomic) NSUInteger          lastIndex;

@property (strong, nonatomic) NSMutableDictionary *reuableViewControllerDictionary;
@end

@interface MyPageViewController ()

@end

@implementation MyPageViewController

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    kHZPageVcSegmentHeight          = 60.f;
    kHZPageVcSegmentIndicatorHeight = 3.f;
    kHZPageVcMaxVisiblePages     = 5;
    
    [self defaultSetup];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)defaultSetup
{
    self.view.backgroundColor = [UIColor clearColor];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _editMode = HZPageVcEditButtonModeDefault;
    
    _highlightedTextColor = [UIColor colorWithHexString:@"CD853F"];
    _normalTextColor = [UIColor blackColor];
    
    _currentIndex = 0;
    
    _segmentScrollView = [[UIScrollView alloc] init];
    _segmentScrollView.showsHorizontalScrollIndicator = NO;
    _segmentScrollView.showsVerticalScrollIndicator = NO;
    _segmentScrollView.scrollsToTop = NO;
    [self.view addSubview:_segmentScrollView];
    _segmentScrollView.backgroundColor = [UIColor whiteColor];
    [_segmentScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.top.mas_equalTo(64+[[UIApplication sharedApplication] statusBarFrame].size.height);
        make.right.mas_equalTo(self.view);
        make.height.mas_equalTo(kHZPageVcSegmentHeight);
    }];
    
    UIView *blank_view = [[UIView alloc]init];
    [self.view addSubview:blank_view];
    [blank_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.view);
        make.top.mas_equalTo(self.view);
        make.right.mas_equalTo(self.view);
        make.bottom.mas_equalTo(_segmentScrollView.mas_top);
    }];
    UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(back)];
    [blank_view addGestureRecognizer:gesture];
    
    _segmentContainerView = [[UIView alloc] init];
    [_segmentScrollView addSubview:_segmentContainerView];
    
    [_segmentContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_segmentScrollView);
        make.height.mas_equalTo(_segmentScrollView);
    }];
    
    _indicatorView = [[UIView alloc] init];
    _indicatorView.backgroundColor = _highlightedTextColor;
    [_segmentScrollView addSubview:_indicatorView];
    
    _segmentTitles = [NSMutableArray array];
    
    _contentScrollView = [[UIScrollView alloc] init];
    _contentScrollView.showsHorizontalScrollIndicator = NO;
    _contentScrollView.scrollsToTop = NO;
    _contentScrollView.delegate = self;
    _contentScrollView.pagingEnabled = YES;
    [self.view addSubview:_contentScrollView];
    [_contentScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.left.mas_equalTo(self.view);
        make.top.mas_equalTo(_segmentScrollView.mas_bottom);
        make.bottom.mas_equalTo(self.mas_bottomLayoutGuide);
    }];
    
    _contentContainerView = [[UIView alloc] init];
    [_contentScrollView addSubview:_contentContainerView];
    [_contentContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(_contentScrollView);
        make.height.mas_equalTo(_contentScrollView);
    }];
    
    //    _segmentFrameRects = [NSMutableArray array];
    
    _reuableViewControllerDictionary = [NSMutableDictionary dictionary];
    _doneLayout = NO;
    
    
}

- (void)reloadDataAtIndex:(NSUInteger)index
{
    NSString *title = [_dataSource pageVc:self titleAtIndex:index];
    [_segmentTitles replaceObjectAtIndex:index withObject:title];
    UILabel *label = (UILabel *)[_segmentContainerView viewWithTag:1000 + index];
    label.text = title;
    
    UIViewController *oldController = [_reuableViewControllerDictionary objectForKey:@(index)];
    [oldController removeFromParentViewController];
    [oldController.view removeFromSuperview];
    
    UIViewController *newController = [_dataSource pageVc:self viewControllerAtIndex:index];
    [self addChildViewController:newController];
    UIView *contentBgView = [_contentContainerView viewWithTag:2000 + index];
    [contentBgView addSubview:newController.view];
    [newController.view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(contentBgView);
    }];
    [_reuableViewControllerDictionary setObject:newController forKey:@(index)];
    
}

- (void)reloadData
{
    _doneLayout = NO;
    
    [_reuableViewControllerDictionary removeAllObjects];
    _numberOfContent = [_dataSource numberOfContentForPageVc:self];
    [_segmentTitles removeAllObjects];
    [_segmentContainerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    [_contentContainerView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UIView *lastSegmentView = nil;
    UIView *lastContentView = nil;
    
    
    _currentIndex = 0;
    
    for (NSUInteger index = 0; index < _numberOfContent; ++ index) {
        
        // load segment
        NSString *title = [_dataSource pageVc:self titleAtIndex:index];
        [_segmentTitles addObject:title];
        
        UILabel *label = [[UILabel alloc] init];
        label.userInteractionEnabled = YES;
        label.text = [NSString stringWithFormat:@"%@", title];
        label.textColor = _normalTextColor;
        label.font = [UIFont systemFontOfSize:17.f];
        label.textAlignment = NSTextAlignmentCenter;
        label.highlightedTextColor = _highlightedTextColor;
        label.tag = 1000 + index;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapSegmentItemAction:)];
        [label addGestureRecognizer:tapGesture];
        
        [_segmentContainerView insertSubview:label belowSubview:_indicatorView];
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(_segmentContainerView);
            if (lastSegmentView) {
                make.left.mas_equalTo(lastSegmentView.mas_right);
            }
            else {
                make.left.mas_equalTo(_segmentContainerView.mas_left);
            }
            make.width.mas_equalTo([UIScreen mainScreen].bounds.size.width/[_dataSource numberOfContentForPageVc:self]);
        }];
        
        lastSegmentView = label;
        
        UIView *view = [[UIView alloc] init];
        view.tag = 2000 + index;
        [_contentContainerView addSubview:view];
        [view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.bottom.mas_equalTo(_contentContainerView);
            make.width.mas_equalTo(CGRectGetWidth([[UIScreen mainScreen] bounds]));
            if (lastContentView) {
                make.left.mas_equalTo(lastContentView.mas_right);
            }
            else {
                make.left.mas_equalTo(_contentContainerView.mas_left);
            }
        }];
        lastContentView = view;
        
        if (index < 3) {
            UIViewController *controller = [_dataSource pageVc:self viewControllerAtIndex:index];
            [self addChildViewController:controller];
            [_reuableViewControllerDictionary setObject:controller forKey:@(index)];
            
            [view addSubview:controller.view];
            [controller.view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(view);
            }];
        }
    }
    
    [_segmentContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(lastSegmentView.mas_right);
    }];
    
    [_contentContainerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(lastContentView.mas_right);
    }];
    
    UILabel *currentLabel = (UILabel *)[_segmentContainerView viewWithTag:1000 + _currentIndex];
    currentLabel.highlighted = YES;
    [self.view layoutIfNeeded];
    CGRect frame = currentLabel.frame;
    _indicatorView.frame = CGRectMake(CGRectGetMinX(frame), CGRectGetHeight(frame)-kHZPageVcSegmentIndicatorHeight, CGRectGetWidth(frame), kHZPageVcSegmentIndicatorHeight);
    
    _contentScrollView.contentOffset = CGPointMake(0, 0);
    
    
    
}

- (void)tapSegmentItemAction:(UITapGestureRecognizer *)gesture
{
    UIView *view = [gesture view];
    NSUInteger index = view.tag - 1000;
    
    
    [_contentScrollView setContentOffset:CGPointMake(index * CGRectGetWidth(_contentScrollView.frame), 0) animated:YES];
}

#pragma mark - Setter & Getter
- (void)setDataSource:(id<MyPageViewControllerDataSource>)dataSource
{
    if (_dataSource != dataSource) {
        _dataSource = dataSource;
        if (_dataSource) {
            [self reloadData];
        }
    }
}

- (void)setCurrentIndex:(NSUInteger)currentIndex
{
    if (_currentIndex != currentIndex) {
        UILabel *oldLabel = (UILabel *)[_segmentContainerView viewWithTag:1000 + _currentIndex];
        UILabel *newLable = (UILabel *)[_segmentContainerView viewWithTag:1000 + currentIndex];
        oldLabel.highlighted = NO;
        newLable.highlighted = YES;
        _lastIndex = _currentIndex;
        _currentIndex = currentIndex;
        
        [UIView animateWithDuration:0.3 animations:^{
            UILabel *currentLabel = (UILabel *)[_segmentContainerView viewWithTag:1000 + _currentIndex];
            CGRect frame = currentLabel.frame;
            _indicatorView.frame = CGRectMake(CGRectGetMinX(frame), CGRectGetHeight(frame)-kHZPageVcSegmentIndicatorHeight, CGRectGetWidth(frame), kHZPageVcSegmentIndicatorHeight);
        }];
        
        [self updateSegmentContentOffset];
        
    }
}

- (UIViewController *)viewControllerAtIndex:(NSUInteger)index
{
    if (index >= _numberOfContent) {
        return nil;
    }
    return _reuableViewControllerDictionary[@(index)];
}

#pragma mark - Private Function
- (void)updateSegmentContentOffset
{
    UILabel *currentLabel = (UILabel *)[_segmentContainerView viewWithTag:1000 + _currentIndex];
    CGRect rect = currentLabel.frame;
    CGFloat midX = CGRectGetMidX(rect);
    CGFloat offset = 0;
    CGFloat contentWidth = _segmentScrollView.contentSize.width;
    CGFloat halfWidth = CGRectGetWidth(_segmentScrollView.bounds) / 2.0;
    if (midX < halfWidth) {
        offset = 0;
    }
    else if (midX > contentWidth - halfWidth) {
        offset = contentWidth - 2 * halfWidth;
    }
    else {
        offset = midX - halfWidth;
    }
    [_segmentScrollView setContentOffset:CGPointMake(offset, 0) animated:YES];
}

- (void)transitionFromIndex:(NSUInteger)fromIndex toIndex:(NSUInteger)toIndex
{
    if (fromIndex == toIndex) {
        return;
    }
    HZLog(@"%@ - %@", @(fromIndex), @(toIndex));
    NSInteger removeIndex = 0;
    NSInteger addIndex = 0;
    if (toIndex > fromIndex) {
        removeIndex = fromIndex - 1;
        addIndex = toIndex + 1;
    }
    else {
        removeIndex = fromIndex + 1;
        addIndex = toIndex - 1;
    }
    
    if (addIndex >= 0 && addIndex < _numberOfContent) {
        if (!_reuableViewControllerDictionary[@(addIndex)]) {
            UIViewController *toController = [_dataSource pageVc:self viewControllerAtIndex:addIndex];
            [self addChildViewController:toController];
            [_reuableViewControllerDictionary setObject:toController forKey:@(addIndex)];
            UIView *contentBgView = [_contentContainerView viewWithTag:2000 + addIndex];
            [contentBgView addSubview:toController.view];
            [toController.view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.edges.mas_equalTo(contentBgView);
            }];
        }
    }
    
    if (!_reuableViewControllerDictionary[@(toIndex)]) {
        UIViewController *toController = [_dataSource pageVc:self viewControllerAtIndex:toIndex];
        [self addChildViewController:toController];
        [_reuableViewControllerDictionary setObject:toController forKey:@(toIndex)];
        UIView *contentBgView = [_contentContainerView viewWithTag:2000 + toIndex];
        [contentBgView addSubview:toController.view];
        [toController.view mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.mas_equalTo(contentBgView);
        }];
    }
    
    if (removeIndex >= 0 && removeIndex < _numberOfContent && [_reuableViewControllerDictionary allKeys].count > kHZPageVcMaxVisiblePages) {
        UIViewController *fromController = _reuableViewControllerDictionary[@(removeIndex)];
        [fromController removeFromParentViewController];
        [fromController.view removeFromSuperview];
        [_reuableViewControllerDictionary removeObjectForKey:@(removeIndex)];
    }
    
    [self setCurrentIndex:toIndex];
}

#pragma mark - ScrollView Delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    NSInteger contentOffsetX = scrollView.contentOffset.x;
    NSInteger index = floor((contentOffsetX - CGRectGetWidth(scrollView.frame) / 2) / CGRectGetWidth(scrollView.frame))+1;
    [self transitionFromIndex:_currentIndex toIndex:index];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    NSInteger contentOffsetX = scrollView.contentOffset.x;
    NSInteger index = floor((contentOffsetX - CGRectGetWidth(scrollView.frame) / 2) / CGRectGetWidth(scrollView.frame))+1;
    [self transitionFromIndex:_currentIndex toIndex:index];
}

-(void)back{
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
