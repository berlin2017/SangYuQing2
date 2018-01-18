//
//  PhotoItem.h
//  SangYuQing
//
//  Created by mac on 2018/1/14.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PhotoItem : MTLModel <MTLJSONSerializing>

@property(nonatomic,copy)NSString * szxcp_id;
@property(nonatomic,copy)NSString * szxc_id;
@property(nonatomic,copy)NSString * name;
@property(nonatomic,copy)NSString * image;
@property(nonatomic,assign)BOOL canEdit;
@property(nonatomic,assign)BOOL isSelected;
@end
