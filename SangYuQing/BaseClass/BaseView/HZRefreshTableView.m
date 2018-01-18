//
//  HZRefreshTableView.m
//  AnhuiNews
//
//  Created by History on 15/9/18.
//  Copyright © 2015年 ahxmt. All rights reserved.
//

#import "HZRefreshTableView.h"

@interface HZRefreshTableView ()
{
    UIView *_emptyTipView;
}
@end
@implementation HZRefreshTableView

- (instancetype)init
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        [self initTableViewWithStyle:UITableViewStyleGrouped];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initTableViewWithStyle:UITableViewStyleGrouped];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initTableViewWithStyle:UITableViewStyleGrouped];
    }
    return self;
}
- (instancetype)initWithTableViewStyle:(UITableViewStyle)style
{
    self = [super initWithFrame:CGRectZero];
    if (self) {
        [self initTableViewWithStyle:style];
    }
    return self;
}
- (void)initTableViewWithStyle:(UITableViewStyle)style
{
    _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:style];
    _tableView.keyboardDismissMode = UIScrollViewKeyboardDismissModeOnDrag;
    [self addSubview:_tableView];
    
    [_tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.mas_equalTo(self);
    }];
}

#pragma mark - Private
- (void)showNoDataTip
{
    if ([_delegate respondsToSelector:@selector(emptyListTipViewOfRefreshTableView:)]) {
        _emptyTipView = [_delegate emptyListTipViewOfRefreshTableView:self];
    }
    if (!_emptyTipView) {
        UILabel *label = [[UILabel alloc] init];
        label.text = @"这里空空如也~";
        if ([_delegate respondsToSelector:@selector(emptyListTipStringOfRefreshTableView:)]) {
            label.text = [_delegate emptyListTipStringOfRefreshTableView:self];
        }
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor lightGrayColor];
        _emptyTipView = label;
    }
    [self addSubview:_emptyTipView];
    [_emptyTipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.mas_equalTo(self);
    }];
}

- (void)removeNoDataTip
{
    if (_emptyTipView) {
        [_emptyTipView removeFromSuperview];
        _emptyTipView = nil;
    }
}

#pragma mark - MJRefresh
- (void)setupRefresh
{
    if (_refreshStyle & HZRefreshTableStyleHeader) {
        // 1.下拉刷新(进入刷新状态就会调用self的headerRefreshing)
        _tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingTarget:self refreshingAction:@selector(headerRefreshing)];
        _tableView.mj_header.automaticallyChangeAlpha = YES;
    }
    if (_refreshStyle & HZRefreshTableStyleFooter) {
        // 2.上拉加载更多(进入刷新状态就会调用self的footerRereshing)
        MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingTarget:self refreshingAction:@selector(footerRereshing)];
        _tableView.mj_footer = footer;
        _tableView.mj_footer.automaticallyChangeAlpha = YES;
    }
}

- (void)headerRefreshing
{
    if ((_refreshStyle & HZRefreshTableStyleHeader) &&
        ![_delegate respondsToSelector:@selector(headerRefresh)]) {
        NSAssert(false, @"Refresh Header should headerRefresh");
        return;
    }
    [self removeNoDataTip];
    _currentPage = 0;
    [_delegate headerRefresh];
}
- (void)footerRereshing
{
    if ((_refreshStyle & HZRefreshTableStyleFooter) &&
        ![_delegate respondsToSelector:@selector(footerRefresh)]) {
        NSAssert(false, @"Refresh Footer should footerRefresh");
        return;
    }
    [self removeNoDataTip];
    ++ _currentPage;
    [_delegate footerRefresh];
}

#pragma mark - Getter & Setter
- (void)setRefreshStyle:(HZRefreshTableStyle)refreshStyle
{
    if (_refreshStyle != refreshStyle) {
        _refreshStyle = refreshStyle;
        [self setupRefresh];
    }
}
- (void)setRealTableViewDataSource:(id<UITableViewDataSource>)realTableViewDataSource
{
    if (_realTableViewDataSource != realTableViewDataSource) {
        _realTableViewDataSource = realTableViewDataSource;
        _tableView.dataSource = _realTableViewDataSource;
    }
}

- (void)setRealTableViewDelegate:(id<UITableViewDelegate>)realTableViewDelegate
{
    if (_realTableViewDelegate != realTableViewDelegate) {
        _realTableViewDelegate = realTableViewDelegate;
        _tableView.delegate = _realTableViewDelegate;
    }
}

#pragma mark - Public
- (void)endAllRefreshing
{
    [_tableView.mj_footer endRefreshing];
    [_tableView.mj_header endRefreshing];
}
- (void)beginHeaderRefreshing
{
    [_tableView.mj_header beginRefreshing];
}
- (void)beginFooterRefreshing
{
    [_tableView.mj_footer beginRefreshing];
}
@end
