//
//  GiftCollectionViewCell.m
//  SangYuQing
//
//  Created by mac on 2018/1/11.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "GiftCollectionViewCell.h"
#import "GiftModel.h"

@interface GiftCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageview;
@property (weak, nonatomic) IBOutlet UILabel *time_label;
@property (weak, nonatomic) IBOutlet UILabel *name_label;

@property (weak, nonatomic) IBOutlet UILabel *jifen_label;

@end

@implementation GiftCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.layer.borderWidth = 1;
    self.contentView.layer.borderColor = [UIColor colorWithHexString:@"CD853F"].CGColor;
}

-(void)configWithModel:(GiftModel*)model{
    [_imageview sd_setImageWithURL:[NSURL URLWithString:model.image]];
    _name_label.text = model.name;
    if (model.jifen==0) {
        _jifen_label.text = @"免费";
    }else{
         _jifen_label.text = [NSString stringWithFormat:@"%zd积分",model.jifen];
    }
   
    _time_label.text = [NSString stringWithFormat:@"%zd天",model.expired/24/3600];
}

@end
