//
//  CreatCheckBoxTableViewCell.h
//  SangYuQing
//
//  Created by mac on 2018/1/11.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CreatCheckBoxTableViewCellDelegate <NSObject>

@optional

-(void)checkedChanged:(BOOL)isChecked;
@end

@interface CreatCheckBoxTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UISwitch *checkBox;
@property(weak,nonatomic)id<CreatCheckBoxTableViewCellDelegate>delegate;

@end
