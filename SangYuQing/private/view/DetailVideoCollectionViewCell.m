//
//  DetailVideoCollectionViewCell.m
//  SangYuQing
//
//  Created by mac on 2018/1/10.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "DetailVideoCollectionViewCell.h"
#import "VideoModel.h"

@interface DetailVideoCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageview;
@property (weak, nonatomic) IBOutlet UILabel *name;

@end

@implementation DetailVideoCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(void)configWithModel:(VideoModel*)model{
    [_imageview sd_setImageWithURL:[NSURL URLWithString:model.image]];
    _name.text = model.name;;
}

@end
