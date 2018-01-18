//
//  UserInfoListCell.h
//  SangYuQing
//
//  Created by mac on 2018/1/3.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserInfoListCell : UITableViewCell

-(void)configWithName:(NSString *)name_text value:(NSString *)value_text;

-(void)hideRight;

@end
