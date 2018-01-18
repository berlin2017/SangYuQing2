//
//  MyGuanZhuTableViewCell.m
//  SangYuQing
//
//  Created by mac on 2018/1/17.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "MyGuanZhuTableViewCell.h"
#import "MuDIModel.h"

@interface MyGuanZhuTableViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageview;
@property (weak, nonatomic) IBOutlet UILabel *name_label;
@property (weak, nonatomic) IBOutlet UILabel *birthday_label;
@property (weak, nonatomic) IBOutlet UILabel *death_label;
@property (weak, nonatomic) IBOutlet UILabel *look_label;
@property (weak, nonatomic) IBOutlet UILabel *jidian_label;
@property (weak, nonatomic) IBOutlet UILabel *time_label;

@end

@implementation MyGuanZhuTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    
}

-(void)configWithModel:(MuDIModel*)model{
    if (model.sz_avatar_url) {
        [_imageview sd_setImageWithURL:[NSURL URLWithString:model.sz_avatar_url]];
    }else{
        [_imageview sd_setImageWithURL:[NSURL URLWithString:model.sz_avatar]];
    }
    _name_label.text = model.sz_name;
    _birthday_label.text = [NSString stringWithFormat:@"生辰:%@",model.birthdate];
    _death_label.text = [NSString stringWithFormat:@"忌辰:%@",model.deathdate];
    _time_label.text = [NSString stringWithFormat:@"创建时间:%@",[self formateTime:model.create_time]];
    _look_label.text = [NSString stringWithFormat:@"访客:%@人",model.liulan_count];
    _jidian_label.text = [NSString stringWithFormat:@"祭奠:%@人",model.jibai_count];
}

-(NSString*)formateTime:(NSString*)time{
    NSDateFormatter *stampFormatter = [[NSDateFormatter alloc] init];
    [stampFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    //以 1970/01/01 GMT为基准，然后过了secs秒的时间
    NSDate *stampDate2 = [NSDate dateWithTimeIntervalSince1970:[time intValue]];
    return [stampFormatter stringFromDate:stampDate2];
}



@end
