//
//  HomeNavCollectionViewCell.m
//  SangYuQing
//
//  Created by mac on 2017/12/28.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "HomeNavCollectionViewCell.h"

@interface HomeNavCollectionViewCell(){
    
}
@property(nonatomic,strong)UIImageView *imageView;
@property(nonatomic,strong)UILabel *label;
@end

@implementation HomeNavCollectionViewCell



-(void)configWithIndex:(int)index{
    _imageView = [[UIImageView alloc] init];
    [self.contentView addSubview:_imageView];
    [_imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.contentView);
        make.top.mas_equalTo(self.contentView).mas_offset(5);
        make.height.mas_equalTo(40);
        make.width.mas_equalTo(40);
    }];
    
    _label = [[UILabel alloc]init];
    [self.contentView addSubview:_label];
    [_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(_imageView.mas_bottom).mas_offset(10);
        make.centerX.mas_equalTo(self.contentView);
    }];
    _label.font = [UIFont systemFontOfSize:14];
    
    if (index==0) {
        _imageView.image = [UIImage imageNamed:@"ic_siren_light"];
        _label.text = @"私人墓园";
    }else{
        _imageView.image = [UIImage imageNamed:@"ic_gonggong_light"];
        _label.text = @"公共墓园";
    }
    
}

@end
