//
//  GiftModel.h
//  SangYuQing
//
//  Created by mac on 2018/1/11.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GiftModel : MTLModel <MTLJSONSerializing>

@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *image;
@property(nonatomic,copy)NSString *use_range;
@property(nonatomic,assign)NSInteger jipin_id;
@property(nonatomic,assign)NSInteger jc_id;
@property(nonatomic,assign)NSInteger jifen;
@property(nonatomic,assign)NSInteger expired;
@property(nonatomic,assign)NSInteger state;
@end
