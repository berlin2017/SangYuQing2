//
//  OtherMoneyCollectionViewCell.h
//  SangYuQing
//
//  Created by mac on 2018/1/17.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OtherMoneyCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UITextField *edit;
-(void)setBackColor:(UIColor*)color;
@end
