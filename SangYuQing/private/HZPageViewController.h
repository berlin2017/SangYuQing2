//
//  HZPageViewController.h
//  AnhuiNews
//
//  Created by History on 15/9/14.
//  Copyright © 2015年 ahxmt. All rights reserved.
//

#import "HZBaseViewController.h"

@class HZPageViewController;

typedef NS_ENUM(NSUInteger, HZPageVcEditButtonMode) {
    HZPageVcEditButtonModeDefault = 0,
    HZPageVcEditButtonModeEditing,
};

@protocol HZPageVcDataSource <NSObject>

- (UIViewController *)pageVc:(HZPageViewController *)pageVc viewControllerAtIndex:(NSUInteger)index;
- (NSString *)pageVc:(HZPageViewController *)pageVc titleAtIndex:(NSUInteger)index;
- (NSUInteger)numberOfContentForPageVc:(HZPageViewController *)pageVc;

@end

@protocol HZPageVcDelegate <NSObject>

@optional
- (void)pageVc:(HZPageViewController *)pageVc willChangeToIndex:(NSInteger)toIndex fromIndex:(NSInteger)fromIndex;
- (void)pageVc:(HZPageViewController *)pageVc didChangeToIndex:(NSInteger)toIndex fromIndex:(NSInteger)fromIndex;
- (void)pageVc:(HZPageViewController *)pageVc didClickAtIndex:(NSUInteger)index;
- (void)pageVc:(HZPageViewController *)pageVc didClickEditButtonWithMode:(HZPageVcEditButtonMode)mode;
@end

@interface HZPageViewController : HZBaseViewController
{
    UIScrollView *_contentScrollView;
    UIScrollView *_segmentScrollView;
}
@property (weak, nonatomic) id<HZPageVcDataSource> dataSource;
@property (weak, nonatomic) id<HZPageVcDelegate> delegate;
- (void)reloadData;
- (void)reloadDataAtIndex:(NSUInteger)index;
- (UIViewController *)viewControllerAtIndex:(NSUInteger)index;
@end

