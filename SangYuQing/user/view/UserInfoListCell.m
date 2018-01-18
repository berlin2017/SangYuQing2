//
//  UserInfoListCell.m
//  SangYuQing
//
//  Created by mac on 2018/1/3.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "UserInfoListCell.h"

@interface UserInfoListCell(){
    
    __weak IBOutlet UILabel *name;
    __weak IBOutlet UILabel *value;
    __weak IBOutlet UIImageView *right_arrow;
}
@end

@implementation UserInfoListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

-(void)configWithName:(NSString *)name_text value:(NSString *)value_text{
    name.text = name_text;
    value.text = value_text;
}

-(void)hideRight{
    [right_arrow setHidden:YES];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
