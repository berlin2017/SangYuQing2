//
//  DetailVideoCollectionViewCell.h
//  SangYuQing
//
//  Created by mac on 2018/1/10.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
@class VideoModel;

@interface DetailVideoCollectionViewCell : UICollectionViewCell
-(void)configWithModel:(VideoModel*)model;
@end
