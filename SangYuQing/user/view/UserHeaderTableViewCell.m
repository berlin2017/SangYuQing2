//
//  UserHeaderTableViewCell.m
//  SangYuQing
//
//  Created by mac on 2018/1/3.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "UserHeaderTableViewCell.h"
#import "UserModel.h"

@interface UserHeaderTableViewCell(){
    
    __weak IBOutlet UIImageView *user_photo;
    __weak IBOutlet UILabel *user_name;
    __weak IBOutlet UILabel *user_location;
}
@end

@implementation UserHeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    user_photo.layer.cornerRadius = 15;
    user_photo.layer.masksToBounds = YES;
    user_name.text = @"未登录";
    user_location.text = @"点击登录";
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)configWithModel:(UserModel*)model{
    if (model) {
        [user_photo sd_setImageWithURL:[NSURL URLWithString:model.head_logo] placeholderImage:[UIImage imageNamed:@"ic_user"]];
        user_name.text = model.nickname;
        user_location.text = model.household_address;
    }else{
        user_photo.image = [UIImage imageNamed:@"ic_user"];
        user_name.text = @"未登录";
        user_location.text = @"点击登录";
    }
}

@end
