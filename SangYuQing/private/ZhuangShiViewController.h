//
//  ZhuangShiViewController.h
//  SangYuQing
//
//  Created by mac on 2018/1/11.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "HZPageViewController.h"
@class GiftModel;

@protocol ZhuangShiViewControllerDelegate <NSObject>

@optional
-(void)clickWithModel:(GiftModel*)model;
@end
@interface ZhuangShiViewController : HZPageViewController
@property(nonatomic,weak)id<ZhuangShiViewControllerDelegate>delegate2;
@property(nonatomic,strong)NSArray *list;
@end
