//
//  CityModel.h
//  SangYuQing
//
//  Created by mac on 2018/1/18.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CityModel: MTLModel <MTLJSONSerializing>

@property (nonatomic, copy  ) NSString     *city_id;
@property (nonatomic, copy) NSString        *name;
@property (nonatomic, copy) NSString    *pid;
@end
