//
//  JPGLCollectionViewCell.m
//  SangYuQing
//
//  Created by mac on 2018/1/17.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "JPGLCollectionViewCell.h"
#import "DetailGiftModel.h"
#import "JPModel.h"
#import "JPUser.h"

@interface JPGLCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *user;
@property (weak, nonatomic) IBOutlet UILabel *type;
@property (weak, nonatomic) IBOutlet UISwitch *switch_btn;

@property(nonatomic,strong)DetailGiftModel*model;

@end
@implementation JPGLCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.layer.borderWidth = 1;
    self.contentView.layer.borderColor = [UIColor colorWithHexString:@"CD853F"].CGColor;
}

-(void)configWithModel:(DetailGiftModel *)model{
    _model = model;
    JPModel * jp = model.jipinInfo;
    JPUser * user = model.userInfo;
    [_image sd_setImageWithURL:[NSURL URLWithString:jp.image]];
    _user.text = [NSString stringWithFormat:@"敬祭人:%@",user.account_name];
    _name.text = jp.name;
    if(model.expired_time<=0){
        _type.text = @"已过期";
    }else{
        _type.text = [NSString stringWithFormat:@"剩余%zd天",model.expired_time/24/3600];
    }
    [_switch_btn addTarget:self action:@selector(changed:) forControlEvents:UIControlEventValueChanged];
}

-(void)changed:(UISwitch *)btn{
    if ([_delegate respondsToSelector:@selector(changed:show:)]) {
        [_delegate changed:_model show:[btn isOn]];
    }
}
@end
