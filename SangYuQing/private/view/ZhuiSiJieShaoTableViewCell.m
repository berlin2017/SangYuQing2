//
//  ZhuiSiJieShaoTableViewCell.m
//  SangYuQing
//
//  Created by mac on 2018/1/10.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "ZhuiSiJieShaoTableViewCell.h"

@interface ZhuiSiJieShaoTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *content_label;
@property (weak, nonatomic) IBOutlet UIButton *btn;

@end

@implementation ZhuiSiJieShaoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)showMoreOrNot:(id)sender {
    if (_content_label.numberOfLines==0) {
        _content_label.numberOfLines = 4;
        [_btn setTitle:@"展开" forState:UIControlStateNormal];
        if (_delegate) {
            [_delegate reloadDataWithType:4];
        }
    }else{
        _content_label.numberOfLines = 0;
        [_btn setTitle:@"收起" forState:UIControlStateNormal];
        _content_label.size = [_content_label intrinsicContentSize];
        if (_delegate) {
            [_delegate reloadDataWithType:0];
        }
    }
}

-(void)configWithModel:(NSString*)model type:(int)type{
    _content_label.numberOfLines = type;
    _content_label.text = model;
}

-(void)configWithModel:(NSString*)model{
    [self configWithModel:model type:4];
}

@end
