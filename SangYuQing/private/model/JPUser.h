//
//  JPUser.h
//  SangYuQing
//
//  Created by mac on 2018/1/17.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JPUser :MTLModel <MTLJSONSerializing>

@property(nonatomic,copy)NSString *username;
@property(nonatomic,copy)NSString *account_name;

@property(nonatomic,assign)NSInteger user_id;
@end
