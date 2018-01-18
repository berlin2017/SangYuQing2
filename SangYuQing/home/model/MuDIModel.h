//
//  MuDIModel.h
//  SangYuQing
//
//  Created by mac on 2018/1/11.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MuDIModel : MTLModel <MTLJSONSerializing>

@property(nonatomic,copy)NSString *cemetery_id;
@property(nonatomic,copy)NSString *liulan_count;
@property(nonatomic,copy)NSString *jibai_count;
@property(nonatomic,copy)NSString *sz_id;
@property(nonatomic,copy)NSString *sz_name;
@property(nonatomic,copy)NSString *sz_avatar;
@property(nonatomic,copy)NSString *sz_avatar_url;
@property(nonatomic,copy)NSString *birthdate;
@property(nonatomic,copy)NSString *deathdate;
@property(nonatomic,copy)NSString *create_time;
@property(nonatomic,assign)NSInteger follow;
@property(nonatomic,assign)NSInteger total_follow;

@property(nonatomic,copy)NSString *cemetery_type;
@property(nonatomic,copy)NSString *relation;
@property(nonatomic,copy)NSString *pass;
@end
