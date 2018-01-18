//
//  JPModel.h
//  SangYuQing
//
//  Created by mac on 2018/1/14.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JPModel : MTLModel <MTLJSONSerializing>

@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *image;

@property(nonatomic,assign)NSInteger jipin_id;
@property(nonatomic,assign)NSInteger jifen;
@property(nonatomic,assign)NSInteger expired;
@end
