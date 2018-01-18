//
//  ZhuiSiJiWenTableViewCell.m
//  SangYuQing
//
//  Created by mac on 2018/1/10.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "ZhuiSiJiWenTableViewCell.h"
#import "ArticleModel.h"

@interface ZhuiSiJiWenTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *name_label;
@property (weak, nonatomic) IBOutlet UILabel *time_label;
@property (weak, nonatomic) IBOutlet UILabel *count_label;
@property (weak, nonatomic) IBOutlet UILabel *content_label;

@end

@implementation ZhuiSiJiWenTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [_time_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.contentView.centerX);
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)configWithModel:(ArticleModel *)model{
    _titleLabel.text = model.jiwen_title;
    _time_label.text = [self formateTime:model.create_time];
    _content_label.text = model.jiwen_body;
    _count_label.text = [NSString stringWithFormat:@"阅读:%zd",model.liulan_count];
    _name_label.text = model.nickname;
}

-(NSString*)formateTime:(NSInteger )time{
    NSDateFormatter *stampFormatter = [[NSDateFormatter alloc] init];
    [stampFormatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
    //以 1970/01/01 GMT为基准，然后过了secs秒的时间
    NSDate *stampDate2 = [NSDate dateWithTimeIntervalSince1970:time];
    return [stampFormatter stringFromDate:stampDate2];
}

@end
