//
//  CreatPhotoTableViewCell.h
//  SangYuQing
//
//  Created by mac on 2018/1/11.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CreatPhotoTableViewCellDelegate <NSObject>

@optional

-(void)choseImage;
@end


@interface CreatPhotoTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageview;
@property (weak, nonatomic) IBOutlet UILabel *tishi_label;

@property(weak,nonatomic)id<CreatPhotoTableViewCellDelegate>delegate;
@end
