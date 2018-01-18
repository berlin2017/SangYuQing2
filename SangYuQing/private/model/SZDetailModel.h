//
//  SZDetailModel.h
//  SangYuQing
//
//  Created by mac on 2018/1/10.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SZDetailModel : NSObject
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSString *birthday;
@property(nonatomic,copy)NSString *death;
@property(nonatomic,copy)NSString *image;
@property(nonatomic,copy)NSString *jieshao;
@property(nonatomic,assign)int fangke;
@property(nonatomic,assign)int jidian;
@property(nonatomic,assign)NSArray *photos;
@end
