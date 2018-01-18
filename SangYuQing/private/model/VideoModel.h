//
//  VideoModel.h
//  SangYuQing
//
//  Created by mac on 2018/1/14.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VideoModel  : MTLModel <MTLJSONSerializing>

@property(nonatomic,copy)NSString *szv_id;
@property(nonatomic,copy)NSString *sz_id;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *image;
@property(nonatomic,copy)NSString *video;
@end
