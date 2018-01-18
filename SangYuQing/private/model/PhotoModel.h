//
//  PhotoModel.h
//  SangYuQing
//
//  Created by mac on 2018/1/10.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoModel  : MTLModel <MTLJSONSerializing>

@property(nonatomic,assign)NSInteger szxc_id;
@property(nonatomic,assign)NSInteger  user_id;
@property(nonatomic,assign)NSInteger  sz_id;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,assign)NSInteger  type;
@property(nonatomic,assign)NSInteger  state;
@property(nonatomic,assign)NSInteger create_time;
@property(nonatomic,copy)NSString *image;
@end
