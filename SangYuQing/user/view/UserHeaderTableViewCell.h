//
//  UserHeaderTableViewCell.h
//  SangYuQing
//
//  Created by mac on 2018/1/3.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class UserModel;

@interface UserHeaderTableViewCell : UITableViewCell

-(void)configWithModel:(UserModel*)model;

@end
