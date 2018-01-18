//
//  UserScoreCollectionViewCell.m
//  SangYuQing
//
//  Created by mac on 2018/1/8.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "UserScoreCollectionViewCell.h"
#import "JiFenModel.h"

@interface UserScoreCollectionViewCell()
@property (weak, nonatomic) IBOutlet UILabel *money_label;
@property (weak, nonatomic) IBOutlet UILabel *jifen_label;

@end

@implementation UserScoreCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.layer.borderWidth = 1;
    self.contentView.layer.cornerRadius = 5;
    self.contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.contentView.layer.masksToBounds = YES;
}

-(void)setBackColor:(UIColor*)color{
     self.contentView.layer.backgroundColor = color.CGColor;
}

-(void)configWithModel:(JiFenModel*)model{
    _money_label.text = [NSString stringWithFormat:@"%zd元",model.money];
    _jifen_label.text = [NSString stringWithFormat:@"%zd积分",model.jifen];
}

@end
