//
//  UserInfoTableViewCell.m
//  SangYuQing
//
//  Created by mac on 2018/1/3.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "UserInfoTableViewCell.h"

@interface UserInfoTableViewCell(){
    
    __weak IBOutlet UIImageView *user_photo;
}

@end
@implementation UserInfoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
//    [user_photo sd_setImageWithURL:[NSURL URLWithString:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1514450989988&di=b9d2b71adc10306f918cc5ff3db4ebae&imgtype=0&src=http%3A%2F%2Fimg.zcool.cn%2Fcommunity%2F01e4a1564da3d76ac7251c94308050.png%401280w_1l_2o_100sh.png"]];
    user_photo.layer.cornerRadius = 25;
    user_photo.layer.masksToBounds = YES;
}

-(void)setPhotoWithUrl:(NSString *)url{
    [user_photo sd_setImageWithURL:[NSURL URLWithString:url]];
}

-(void)setPhotoWithImage:(UIImage *)image{
    user_photo.image = image;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
