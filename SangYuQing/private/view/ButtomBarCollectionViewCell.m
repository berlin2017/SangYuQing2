//
//  ButtomBarCollectionViewCell.m
//  SangYuQing
//
//  Created by mac on 2018/1/9.
//  Copyright © 2018年 mac. All rights reserved.
//
#import "ButtomBarCollectionViewCell.h"

@interface ButtomBarCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageview;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation ButtomBarCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)configWithName:(NSString *)name image:(UIImage *)image{
    _nameLabel.text = name;
    _imageview.image =image;
}

@end
