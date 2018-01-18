//
//  BeijingCollectionViewCell.h
//  SangYuQing
//
//  Created by mac on 2018/1/18.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class BeiJingModel;

@interface BeijingCollectionViewCell : UICollectionViewCell
-(void)configWithModel:(BeiJingModel*)model;
@end
