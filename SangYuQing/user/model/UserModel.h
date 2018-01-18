//
//  UserModel.h
//  SangYuQing
//
//  Created by mac on 2018/1/12.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, assign ) NSInteger     user_id;
@property (nonatomic, strong  ) NSString     *username;
@property (nonatomic, strong) NSString        *mobile;
@property (nonatomic, assign) NSString    *email;
@property (nonatomic, strong) NSString    *nickname;
@property (nonatomic, assign ) long     bonus_point;
@property (nonatomic, assign) NSString    *qq;
@property (nonatomic, strong  ) NSString     *account_name;
@property (nonatomic, assign) NSInteger sex;
@property (nonatomic, strong) NSString      *head_logo;
@property (nonatomic, strong) NSString      *live_address;
@property (nonatomic, strong) NSString      *household_address;
@property (nonatomic, assign) NSInteger      live_province_id;
@property (nonatomic, assign) NSInteger      live_city_id;
@property (nonatomic, assign) NSInteger      household_province_id;
@property (nonatomic, assign) NSInteger      household_city_id;
@property (nonatomic, assign) NSInteger      user_state;
@property (nonatomic, strong) NSString      *password;
@property (nonatomic, assign) NSInteger      allow_state;
@property (nonatomic, assign) NSInteger      admin_id;
@property (nonatomic, assign) NSInteger      last_login_time;
@property (nonatomic, assign) NSInteger      register_time;
@end
