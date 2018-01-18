//
//  HZRefreshTableView.h
//  AnhuiNews
//
//  Created by History on 15/9/18.
//  Copyright © 2015年 ahxmt. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HZRefreshTableView;

@protocol HZRefreshTableDelegate <NSObject>

@optional
- (void)headerRefresh;
- (void)footerRefresh;
- (UIView *)emptyListTipViewOfRefreshTableView:(HZRefreshTableView *)tableView;
- (NSString *)emptyListTipStringOfRefreshTableView:(HZRefreshTableView *)tableView;
@end

typedef NS_OPTIONS(NSUInteger, HZRefreshTableStyle) {
    HZRefreshTableStyleNone   = 1 << 0,
    HZRefreshTableStyleHeader = 1 << 1,
    HZRefreshTableStyleFooter = 1 << 2,
};

@interface HZRefreshTableView : UIView
{
    @public
    UITableView *_tableView;
}
@property (assign, nonatomic) HZRefreshTableStyle refreshStyle;
@property (assign, nonatomic) NSUInteger currentPage;
@property (weak, nonatomic) id<HZRefreshTableDelegate> delegate;
@property (weak, nonatomic) id<UITableViewDelegate> realTableViewDelegate;
@property (weak, nonatomic) id<UITableViewDataSource> realTableViewDataSource;
- (instancetype)initWithTableViewStyle:(UITableViewStyle)style;
- (void)showNoDataTip;
- (void)beginHeaderRefreshing;
- (void)beginFooterRefreshing;
- (void)endAllRefreshing;
@end
