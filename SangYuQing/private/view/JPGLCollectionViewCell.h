//
//  JPGLCollectionViewCell.h
//  SangYuQing
//
//  Created by mac on 2018/1/17.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JPXModel;

@protocol JPGLCollectionViewCellDelegate <NSObject>

@optional
-(void)changed:(JPXModel*)model show:(BOOL)show;
@end

@interface JPGLCollectionViewCell : UICollectionViewCell
@property(nonatomic,weak)id<JPGLCollectionViewCellDelegate>delegate;
-(void)configWithModel:(JPXModel *)model;
@end
