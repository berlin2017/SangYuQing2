//
//  JiPinViewController.h
//  SangYuQing
//
//  Created by mac on 2018/1/11.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "HZPageViewController.h"
@class GiftModel;

@protocol JiPinViewControllerDelegate <NSObject>

@optional
-(void)clickWithModel:(GiftModel*)model;
@end
@interface JiPinViewController : HZPageViewController
@property(nonatomic,weak)id<JiPinViewControllerDelegate>delegate2;
@property(nonatomic,strong)NSArray *list;
@end
