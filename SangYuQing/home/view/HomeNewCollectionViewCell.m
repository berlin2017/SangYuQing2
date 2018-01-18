//
//  HomeNewCollectionViewCell.m
//  SangYuQing
//
//  Created by mac on 2017/12/29.
//  Copyright © 2017年 mac. All rights reserved.
//

#import "HomeNewCollectionViewCell.h"
#import "MuDIModel.h"
@interface HomeNewCollectionViewCell(){
    
    __weak IBOutlet UIImageView *imageview;
    __weak IBOutlet UILabel *nameview;
}
@end

@implementation HomeNewCollectionViewCell

-(void)configWithModel:(MuDIModel*)model{
    [imageview sd_setImageWithURL:[NSURL URLWithString:model.sz_avatar]];
    nameview.text = model.sz_name;
}

@end
