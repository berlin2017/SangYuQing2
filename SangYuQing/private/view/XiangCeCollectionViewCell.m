//
//  XiangCeCollectionViewCell.m
//  SangYuQing
//
//  Created by mac on 2018/1/10.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "XiangCeCollectionViewCell.h"
#import "PhotoItem.h"
#import "PhotoModel.h"

@interface XiangCeCollectionViewCell()

@property (weak, nonatomic) IBOutlet UILabel *xiangce_name;
@property (weak, nonatomic) IBOutlet UIImageView *select_imageview;

@end
@implementation XiangCeCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code

}

-(void)configWithModel:(PhotoItem*)model{
    if (model.canEdit) {
        _select_imageview.alpha = 1;
        if (model.isSelected) {
            _select_imageview.image = [UIImage imageNamed:@"ic_selected"];
        }else{
            _select_imageview.image = [UIImage imageNamed:@"ic_unselected"];
        }
    }else{
        _select_imageview.alpha = 0;
    }
    _xiangce_name.text = model.name;
    [_xiangce_imageview sd_setImageWithURL:[NSURL URLWithString:model.image]];
}

-(void)configWithModel:(PhotoItem*)model atIndex:(NSInteger)index{
    if (model.canEdit) {
        _select_imageview.alpha = 1;
        _select_imageview.tag = index;
        _select_imageview.userInteractionEnabled = YES;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(setectOrNot:)];
        [_select_imageview addGestureRecognizer:tap];
        if (model.isSelected) {
            _select_imageview.image = [UIImage imageNamed:@"ic_selected"];
        }else{
            _select_imageview.image = [UIImage imageNamed:@"ic_unselected"];
        }
    }else{
        _select_imageview.alpha = 0;
    }
    _xiangce_name.text = model.name;
    [_xiangce_imageview sd_setImageWithURL:[NSURL URLWithString:model.image]];
}

-(void)configWithXiangCeModel:(PhotoModel*)model{
    _select_imageview.alpha = 0;
    _xiangce_name.text = model.name;
    [_xiangce_imageview sd_setImageWithURL:[NSURL URLWithString:model.image]];
}

-(void)setectOrNot:(UITapGestureRecognizer *)tap{
    NSInteger index =  tap.view.tag;
    if ([_delegate respondsToSelector:@selector(setSelectedAtIndex:)]) {
        [_delegate setSelectedAtIndex:index];
    }
}

@end
