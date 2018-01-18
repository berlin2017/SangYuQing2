//
//  OrderInfo.h
//  SangYuQing
//
//  Created by mac on 2018/1/16.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OrderInfo : MTLModel <MTLJSONSerializing>

@property (nonatomic, assign  ) NSInteger     pay_type;
@property (nonatomic, copy  ) NSString     *trade_no;
@property (nonatomic, copy  ) NSString     *orderString;
@property (nonatomic, strong) NSString        *prepay_id;
@property (nonatomic, assign) NSString    *nonce_str;
@property (nonatomic, assign) NSString    *package;
@property (nonatomic, assign  ) NSInteger     money;
@property (nonatomic, copy  ) NSString     *sign;
@property (nonatomic, assign) NSInteger timestamp;
@end
