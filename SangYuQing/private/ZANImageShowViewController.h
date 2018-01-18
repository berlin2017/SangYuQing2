//
//  HZImageShowViewController.h
//  AnhuiNews
//
//  Created by History on 15/6/3.
//  Copyright (c) 2015年 ahnews. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZANImageShowViewController;

@protocol HZImageShowViewControllerDataSource <NSObject>

@required
- (NSInteger)numberOfImages:(ZANImageShowViewController *)imageShowViewController;

@optional
- (NSURL *)imageShowViewController:(ZANImageShowViewController *)imageShowViewController imageURLAtIndex:(NSInteger)index;
- (UIImage *)imageShowViewController:(ZANImageShowViewController *)imageShowViewController imageDataAtIndex:(NSInteger)index;
- (NSString *)imageShowViewController:(ZANImageShowViewController *)imageShowViewController imageTextAtIndex:(NSInteger)index;

@end

@protocol HZImageShowViewControllerDelegate <NSObject>

@optional

@end


@interface ZANImageShowViewController : UIViewController
@property (nonatomic, weak) id<HZImageShowViewControllerDataSource> dataSource;
@property (nonatomic, weak) id<HZImageShowViewControllerDelegate> delegate;
@property (nonatomic, assign) NSInteger currentIndex;
- (void)reloadData;
@end
