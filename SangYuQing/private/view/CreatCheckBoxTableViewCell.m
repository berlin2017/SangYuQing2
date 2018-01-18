//
//  CreatCheckBoxTableViewCell.m
//  SangYuQing
//
//  Created by mac on 2018/1/11.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "CreatCheckBoxTableViewCell.h"

@implementation CreatCheckBoxTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [_checkBox addTarget:self action:@selector(onCheckChanged:) forControlEvents:UIControlEventValueChanged];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)onCheckChanged:(UISwitch*)sw{
    if([_delegate respondsToSelector:@selector(checkedChanged:)]){
        [_delegate checkedChanged:sw.isOn];
    }
}

@end
