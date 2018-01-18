//
//  JiWenDetailTableViewCell.m
//  SangYuQing
//
//  Created by mac on 2018/1/10.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "JiWenDetailTableViewCell.h"

@interface JiWenDetailTableViewCell()
@property (weak, nonatomic) IBOutlet UILabel *label;

@end

@implementation JiWenDetailTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)configWithString:(NSString *)s{
    _label.text = s;
    _label.numberOfLines = 0;
}

@end
