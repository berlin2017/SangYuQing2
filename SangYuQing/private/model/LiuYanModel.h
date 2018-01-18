//
//  LiuYanModel.h
//  SangYuQing
//
//  Created by mac on 2018/1/10.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LiuYanModel : MTLModel <MTLJSONSerializing>

@property(nonatomic,assign)NSInteger szly_id;
@property(nonatomic,assign)NSInteger  user_id;
@property(nonatomic,assign)NSInteger  sz_id;
@property(nonatomic,copy)NSString *content;
@property(nonatomic,assign)NSInteger  type;
@property(nonatomic,assign)NSInteger  showname;
@property(nonatomic,assign)NSInteger  create_time;
@property(nonatomic,assign)NSInteger  state;
@property(nonatomic,copy)NSString *head_logo;
@property(nonatomic,copy)NSString *username;
@property(nonatomic,copy)NSString *nickname;

@end
