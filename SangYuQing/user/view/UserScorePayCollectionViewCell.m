//
//  UserScorePayCollectionViewCell.m
//  SangYuQing
//
//  Created by mac on 2018/1/8.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "UserScorePayCollectionViewCell.h"

@interface UserScorePayCollectionViewCell()
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *image;

@end

@implementation UserScorePayCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.layer.borderWidth = 1;
    self.contentView.layer.cornerRadius = 5;
    self.contentView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.contentView.layer.masksToBounds = YES;
}

-(void)configWithIndex:(NSInteger)index{
    if (index) {
        _name.text = @"支付宝支付";
        _image.image = [UIImage imageNamed:@"ic_alipay"];
    }else{
        _name.text = @"微信支付";
        _image.image = [UIImage imageNamed:@"ic_weixin"];
    }
}

-(void)setBoraderColor:(UIColor*)color{
    self.contentView.layer.borderColor = color.CGColor;
}

@end
