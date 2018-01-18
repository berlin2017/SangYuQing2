//
//  DetailMenuCollectionViewCell.m
//  SangYuQing
//
//  Created by mac on 2018/1/9.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "DetailMenuCollectionViewCell.h"

@interface DetailMenuCollectionViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageview;
@property (weak, nonatomic) IBOutlet UILabel *name;

@end
@implementation DetailMenuCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.contentView.backgroundColor = [UIColor blackColor];
    self.contentView.layer.cornerRadius = 25;
    self.contentView.layer.masksToBounds = YES;
}

-(void)configWithName:(NSString *)name image:(UIImage*)image{
    _imageview.image = image;
    _name.text = name;
}
@end
