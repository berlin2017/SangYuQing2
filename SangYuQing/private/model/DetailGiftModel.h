//
//  DetailGiftModel.h
//  SangYuQing
//
//  Created by mac on 2018/1/14.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JPModel;
@class JPUser;

@interface DetailGiftModel : MTLModel <MTLJSONSerializing>

@property(nonatomic,copy)NSString *postion;
@property(nonatomic,copy)NSString *posx;
@property(nonatomic,copy)NSString *posy;

@property(nonatomic,strong)JPUser *userInfo;

@property(nonatomic,assign)NSInteger szjpx_id;
@property(nonatomic,assign)NSInteger expired_time;
@property(nonatomic,assign)NSInteger jpx_type;
@property(nonatomic,strong)JPModel *jipinInfo;
@end
