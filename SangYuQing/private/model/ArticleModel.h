//
//  ArticleModel.h
//  SangYuQing
//
//  Created by mac on 2018/1/14.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ArticleModel : MTLModel <MTLJSONSerializing>

@property(nonatomic,assign)NSInteger user_id;
@property(nonatomic,assign)NSInteger  szjw_id;
@property(nonatomic,assign)NSInteger  sz_id;
@property(nonatomic,copy)NSString *jiwen_title;
@property(nonatomic,assign)NSInteger  jiwen_type;
@property(nonatomic,assign)NSInteger  liulan_count;
@property(nonatomic,assign)NSInteger  state;
@property(nonatomic,assign)NSInteger create_time;
@property(nonatomic,assign)NSInteger update_time;
@property(nonatomic,copy)NSString *head_logo;
@property(nonatomic,copy)NSString *username;
@property(nonatomic,copy)NSString *nickname;
@property(nonatomic,copy)NSString *jiwen_body;
@end
