//
//  JiFenDetailModel.h
//  SangYuQing
//
//  Created by mac on 2018/1/16.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JiFenDetailModel : MTLModel <MTLJSONSerializing>

@property (nonatomic, copy  ) NSString     *order_numer;
@property (nonatomic, copy) NSString        *type;
@property (nonatomic, copy) NSString    *point_value;
@property (nonatomic, copy) NSString    *add_time;
@property (nonatomic, copy) NSString    *price;
@property (nonatomic, copy  ) NSString     *payment_type;
@property (nonatomic, copy  ) NSString     *remark;
@end
