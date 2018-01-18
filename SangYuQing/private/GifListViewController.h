//
//  GifListViewController.h
//  SangYuQing
//
//  Created by mac on 2018/1/11.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GiftModel;

@protocol GifListViewControllerDelegate <NSObject>

@optional
-(void)clickWithModel:(GiftModel*)model;
@end

@interface GifListViewController : UIViewController
@property(nonatomic,weak)id<GifListViewControllerDelegate>delegate;
@property(nonatomic,assign)NSString *jc_id;
@end
