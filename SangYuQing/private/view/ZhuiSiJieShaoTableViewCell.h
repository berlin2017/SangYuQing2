//
//  ZhuiSiJieShaoTableViewCell.h
//  SangYuQing
//
//  Created by mac on 2018/1/10.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZhuiSiJieShaoTableViewCellDelegate <NSObject>

@optional
-(void)reloadDataWithType:(int)type;
@end

@interface ZhuiSiJieShaoTableViewCell : UITableViewCell

-(void)configWithModel:(NSString*)model;
-(void)configWithModel:(NSString*)model type:(int)type;

@property(nonatomic,weak)id<ZhuiSiJieShaoTableViewCellDelegate>delegate;
@end
