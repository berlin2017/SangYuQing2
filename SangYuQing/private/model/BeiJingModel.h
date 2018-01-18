//
//  BeiJingModel.h
//  SangYuQing
//
//  Created by mac on 2018/1/18.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BeiJingModel :MTLModel <MTLJSONSerializing>

@property(nonatomic,copy)NSString *background_id;
@property(nonatomic,copy)NSString *image;
@property(nonatomic,copy)NSString *image_url;
@property(nonatomic,copy)NSString *jifen;
@property(nonatomic,copy)NSString *type;

@property(nonatomic,assign)NSInteger goumai;
@property(nonatomic,assign)NSInteger default_type;
@end
