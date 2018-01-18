//
//  XianHuaViewController.h
//  SangYuQing
//
//  Created by mac on 2018/1/11.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "HZPageViewController.h"
@class GiftModel;

@protocol XianHuaViewControllerDelegate <NSObject>

@optional
-(void)clickWithModel:(GiftModel*)model;
@end

@interface XianHuaViewController : HZPageViewController

@property(nonatomic,weak)id<XianHuaViewControllerDelegate>delegate2;
@property(nonatomic,strong)NSArray *list;
@end
