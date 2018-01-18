//
//  CreatPhotoTableViewCell.m
//  SangYuQing
//
//  Created by mac on 2018/1/11.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "CreatPhotoTableViewCell.h"

@implementation CreatPhotoTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    _tishi_label.text = @"注：照片文件必须小于200kb，格式仅为png,jpg,jpeg。";
    
    UITapGestureRecognizer *key_recognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(choseImage)];
    [_imageview addGestureRecognizer:key_recognizer];
    _imageview.contentMode = UIViewContentModeScaleToFill;
    _imageview.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)choseImage{
    [_delegate choseImage];
}



@end
