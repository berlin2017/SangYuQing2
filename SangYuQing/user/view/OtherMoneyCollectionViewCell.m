//
//  OtherMoneyCollectionViewCell.m
//  SangYuQing
//
//  Created by mac on 2018/1/17.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "OtherMoneyCollectionViewCell.h"

@implementation OtherMoneyCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setBackColor:(UIColor*)color{
    self.contentView.layer.backgroundColor = color.CGColor;
}
@end
