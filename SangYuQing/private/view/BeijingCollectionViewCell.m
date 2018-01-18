//
//  BeijingCollectionViewCell.m
//  SangYuQing
//
//  Created by mac on 2018/1/18.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "BeijingCollectionViewCell.h"
#import "BeiJingModel.h"


@interface BeijingCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageview;
@property (weak, nonatomic) IBOutlet UILabel *jifenLabel;
@property (weak, nonatomic) IBOutlet UIButton *userBtn;


@end
@implementation BeijingCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)configWithModel:(BeiJingModel*)model{
    if (model.default_type==1) {
        _jifenLabel.text = @"默认";
    }else{
        _jifenLabel.text = [NSString stringWithFormat:@"%@积分",model.jifen];
    }
    
    [_imageview sd_setImageWithURL:[NSURL URLWithString:model.image_url]];
}

@end
