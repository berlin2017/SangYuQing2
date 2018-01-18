//
//  UserScoreCollectionViewCell.h
//  SangYuQing
//
//  Created by mac on 2018/1/8.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class JiFenModel;

@interface UserScoreCollectionViewCell : UICollectionViewCell

-(void)setBackColor:(UIColor*)color;
-(void)configWithModel:(JiFenModel*)model;
@end
