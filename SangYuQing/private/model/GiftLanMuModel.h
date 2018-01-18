//
//  GiftLanMuModel.h
//  SangYuQing
//
//  Created by mac on 2018/1/14.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GiftLanMuModel : MTLModel <MTLJSONSerializing>

@property(nonatomic,copy)NSString *jc_id;
@property(nonatomic,copy)NSString *jc_pid;
@property(nonatomic,copy)NSString *jc_name;
@end
