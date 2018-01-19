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

-(void)configWithModel:(BeiJingModel*)model index:(NSInteger)index{
    if (model.default_type==1) {
        _jifenLabel.text = @"默认";
    }else{
        _jifenLabel.text = [NSString stringWithFormat:@"%@积分",model.jifen];
    }
    
    [_imageview sd_setImageWithURL:[NSURL URLWithString:model.image_url]];
    
    if (model.goumai==1) {
        [_userBtn setTitle:@"使用" forState:UIControlStateNormal];
         _userBtn.backgroundColor = [UIColor colorWithHexString:@"CD853F"];
    }else if (model.goumai==3) {
        [_userBtn setTitle:@"已选择" forState:UIControlStateNormal];
        _userBtn.backgroundColor = [UIColor grayColor];
    }else{
        [_userBtn setTitle:@"购买" forState:UIControlStateNormal];
         _userBtn.backgroundColor = [UIColor colorWithHexString:@"CD853F"];
     }
    _userBtn.tag = index;
    [_userBtn addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)click:(UIButton*)btn{
    if ([_delegate respondsToSelector:@selector(clickAtIndex:)]) {
        [_delegate clickAtIndex: btn.tag];
    }
}

@end
