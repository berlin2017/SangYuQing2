//
//  JPXModel.h
//  SangYuQing
//
//  Created by mac on 2018/1/30.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>
@class JPModel;
@class JPUser;
@interface JPXModel : MTLModel <MTLJSONSerializing>

@property(nonatomic,strong)JPUser *userInfo;

@property(nonatomic,assign)NSInteger szjpx_id;
@property(nonatomic,assign)NSInteger expired_time;
@property(nonatomic,assign)NSInteger jpx_type;
@property(nonatomic,strong)JPModel *jipinInfo;
@property(nonatomic,assign)NSInteger is_show;
@end
