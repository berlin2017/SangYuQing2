//
//  GiftCollectionViewCell.h
//  SangYuQing
//
//  Created by mac on 2018/1/11.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GiftModel;

@interface GiftCollectionViewCell : UICollectionViewCell

-(void)configWithModel:(GiftModel*)model;
@end
