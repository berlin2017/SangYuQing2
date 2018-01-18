//
//  MyPageViewController.h
//  SangYuQing
//
//  Created by mac on 2018/1/18.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyPageViewController;

typedef NS_ENUM(NSUInteger, HZPageVcEditButtonMode) {
    HZPageVcEditButtonModeDefault = 0,
    HZPageVcEditButtonModeEditing,
};

@protocol MyPageViewControllerDataSource <NSObject>

- (UIViewController *)pageVc:(MyPageViewController *)pageVc viewControllerAtIndex:(NSUInteger)index;
- (NSString *)pageVc:(MyPageViewController *)pageVc titleAtIndex:(NSUInteger)index;
- (NSUInteger)numberOfContentForPageVc:(MyPageViewController *)pageVc;

@end


@interface MyPageViewController : UIViewController
{
    UIScrollView *_contentScrollView;
    UIScrollView *_segmentScrollView;
}

@property (weak, nonatomic) id<MyPageViewControllerDataSource> dataSource;
@property (weak, nonatomic) id<MyPageViewControllerDataSource> delegate;
- (void)reloadData;
- (void)reloadDataAtIndex:(NSUInteger)index;
- (UIViewController *)viewControllerAtIndex:(NSUInteger)index;

@end


