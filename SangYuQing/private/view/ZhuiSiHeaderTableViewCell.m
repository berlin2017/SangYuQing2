//
//  ZhuiSiHeaderTableViewCell.m
//  SangYuQing
//
//  Created by mac on 2018/1/10.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "ZhuiSiHeaderTableViewCell.h"
#import "MuDiDetailModel.h"

@interface ZhuiSiHeaderTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *name_label;
@property (weak, nonatomic) IBOutlet UILabel *birthday_label;
@property (weak, nonatomic) IBOutlet UILabel *death_label;
@property (weak, nonatomic) IBOutlet UILabel *fangke_label;
@property (weak, nonatomic) IBOutlet UILabel *jidian_label;
@property (weak, nonatomic) IBOutlet UIImageView *photo_image;

@end

@implementation ZhuiSiHeaderTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _photo_image.layer.borderColor = [[UIColor whiteColor]CGColor];
    _photo_image.layer.borderWidth = 1;
    _photo_image.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)configWithModel:(MuDiDetailModel*)model{
    _name_label.text = model.sz_name;
    _birthday_label.text = [NSString stringWithFormat:@"生辰:%@",model.birthdate];
    _death_label.text = [NSString stringWithFormat:@"祭辰:%@",model.deathdate];
    _fangke_label.text = [NSString stringWithFormat:@"访客: %@人",model.liulan_count];
     _jidian_label.text = [NSString stringWithFormat:@"祭奠: %@人",model.jibai_count];
    [_photo_image sd_setImageWithURL:[NSURL URLWithString:model.sz_avatar]];
}

@end
