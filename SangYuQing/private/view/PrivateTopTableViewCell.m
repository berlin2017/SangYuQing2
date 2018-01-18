//
//  PrivateTopTableViewCell.m
//  SangYuQing
//
//  Created by mac on 2017/12/30.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "PrivateTopTableViewCell.h"
@interface PrivateTopTableViewCell(){
    
    __weak IBOutlet UISearchBar *searchBar;
}

@end

@implementation PrivateTopTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    searchBar.backgroundImage = [[UIImage alloc]init];
}
- (IBAction)search:(id)sender {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
