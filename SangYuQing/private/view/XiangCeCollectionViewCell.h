//
//  XiangCeCollectionViewCell.h
//  SangYuQing
//
//  Created by mac on 2018/1/10.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PhotoItem;
@class PhotoModel;

@protocol XiangCeCollectionViewCellDelegate <NSObject>

-(void)setSelectedAtIndex:(NSInteger)index;

@end

@interface XiangCeCollectionViewCell : UICollectionViewCell
-(void)configWithModel:(PhotoItem*)model;
-(void)configWithXiangCeModel:(PhotoModel*)model;
-(void)configWithModel:(PhotoItem*)model atIndex:(NSInteger)index;
@property (weak, nonatomic) IBOutlet UIImageView *xiangce_imageview;
@property(nonatomic,weak)id<XiangCeCollectionViewCellDelegate>delegate;
@end
